#!/usr/bin/env bash
# Validate the plugin and check every skill against the playbook-tool contract:
# required metadata fields, playbook_id matches the folder, required sections present,
# and the served body stays under the 8 KB tool-result budget.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN="$ROOT/zacks-financial-data"

claude plugin validate --profile directory "$PLUGIN"

python3 -I - "$PLUGIN" <<'PY'
import pathlib, re, sys
plugin = pathlib.Path(sys.argv[1])
required = ["playbook_id", "title", "use_when", "tools_used", "quota_note", "updated"]
sections = ["## Guardrails", "## Sources and citation", "## Feedback"]
failed = False
for skill in sorted((plugin / "skills").glob("*/SKILL.md")):
    text = skill.read_text()
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", text, re.S)
    if not m:
        print(f"FAIL {skill}: no frontmatter"); failed = True; continue
    front, body = m.groups()
    meta = dict(re.findall(r'^  ([a-z_]+): *"?(.*?)"?$', front, re.M))
    folder = skill.parent.name
    for key in required:
        if not meta.get(key):
            print(f"FAIL {folder}: metadata.{key} missing"); failed = True
    if meta.get("playbook_id") != folder.replace("-", "_"):
        print(f"FAIL {folder}: playbook_id must be {folder.replace('-', '_')}"); failed = True
    for s in sections:
        if f"\n{s}\n" not in body:
            print(f"FAIL {folder}: section {s!r} missing"); failed = True
    size = len(body.encode())
    if size > 8000:
        print(f"FAIL {folder}: body is {size} bytes (limit 8000)"); failed = True
    print(f"ok   {folder}: {size} bytes")
sys.exit(1 if failed else 0)
PY
