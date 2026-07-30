#!/usr/bin/env python3
"""Bump every pinned cask to its upstream project's latest release.

Why this lives in the tap rather than in each project's release workflow:

* One mechanism instead of four, and it works for casks whose source
  repository nobody here controls.
* It needs no cross-repository credential. A workflow in this repository can
  commit to this repository with the ordinary `GITHUB_TOKEN`; pushing from
  four other repositories would need a personal access token in each of them,
  which is four secrets to rotate and four places to leak one.

The cost is latency: a release is picked up on the next scheduled run rather
than the moment it is published. `workflow_dispatch` covers the impatient case.

Reads `version "x.y.z"` and `url "...github.com/OWNER/REPO/releases/..."` out
of each cask, asks GitHub for that repository's latest release, and rewrites
`version` and `sha256` when the tag has moved. Deliberately does NOT touch
anything else in the file: everything but those two lines is authored by hand
or upstream.
"""

import hashlib
import json
import os
import re
import sys
import urllib.request
from pathlib import Path

CASKS = Path(__file__).resolve().parent.parent / "Casks"

# `version :latest` casks have nothing to bump and are skipped, not failed:
# the tap may legitimately hold both kinds.
VERSION_RE = re.compile(r'^(\s*version )"([^"]+)"$', re.M)
SHA_RE = re.compile(r'^(\s*sha256 )"([0-9a-f]{64})"$', re.M)
URL_RE = re.compile(r'^\s*url "(https://github\.com/([^/]+)/([^/]+))/releases/download/[^"]*"', re.M)


def get(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": "alexnodeland-tap-bump"})
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        # Unauthenticated GitHub API is 60 requests an hour per IP, which a
        # shared runner exhausts without anyone noticing why.
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


def latest_release(owner: str, repo: str) -> dict | None:
    """The latest release, or None if the project has never cut one.

    A 404 here is not an error. A cask can legitimately sit in the tap pinned
    at 0.0.0 waiting for its project's first release -- which is exactly the
    state `tome` was in when this script was written, and it crashed on it.
    """
    try:
        return json.loads(get(f"https://api.github.com/repos/{owner}/{repo}/releases/latest"))
    except urllib.error.HTTPError as error:
        if error.code == 404:
            return None
        raise


def bump(path: Path) -> str | None:
    """Rewrite one cask. Returns a summary line if it changed."""
    text = path.read_text()

    version_match = VERSION_RE.search(text)
    sha_match = SHA_RE.search(text)
    url_match = URL_RE.search(text)
    if not (version_match and sha_match and url_match):
        print(f"{path.name}: not a pinned cask, skipped")
        return None

    current = version_match.group(2)
    owner, repo = url_match.group(2), url_match.group(3)

    release = latest_release(owner, repo)
    if release is None:
        print(f"{path.name}: {owner}/{repo} has no releases yet, skipped")
        return None
    tag = release["tag_name"]
    upstream = tag[1:] if tag.startswith("v") else tag
    if upstream == current:
        print(f"{path.name}: {current} is current")
        return None

    # The asset name is derived from the URL template with the NEW version, so
    # a project that puts the version in the file name still resolves. If that
    # asset is not in the release, fail loudly rather than committing a cask
    # that 404s on install.
    template = url_match.group(0).split('"')[1]
    wanted = template.replace("#{version}", upstream).rsplit("/", 1)[-1]
    asset = next((a for a in release["assets"] if a["name"] == wanted), None)
    if asset is None:
        names = ", ".join(a["name"] for a in release["assets"]) or "(none)"
        raise SystemExit(
            f"{path.name}: {owner}/{repo} {tag} has no asset named {wanted}. Has: {names}"
        )

    digest = hashlib.sha256(get(asset["browser_download_url"])).hexdigest()

    text = VERSION_RE.sub(lambda m: f'{m.group(1)}"{upstream}"', text, count=1)
    text = SHA_RE.sub(lambda m: f'{m.group(1)}"{digest}"', text, count=1)
    path.write_text(text)
    print(f"{path.name}: {current} -> {upstream}")
    return f"{path.stem} {current} -> {upstream}"


def main() -> int:
    changed = [line for line in (bump(p) for p in sorted(CASKS.glob("*.rb"))) if line]
    # Written for the workflow to read; empty means nothing to commit.
    summary = ", ".join(changed)
    if output := os.environ.get("GITHUB_OUTPUT"):
        with open(output, "a") as handle:
            handle.write(f"changed={summary}\n")
    print(f"\n{summary or 'nothing to do'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
