"""Build an upload zip of the plugin for claude.ai (Customize > Plugins > Upload plugin).

    python3 scripts/build_zip.py                  -> dist/zacks-financial-data.zip (prod connector)
    python3 scripts/build_zip.py --target stage   -> dist/zacks-financial-data-stage.zip

The stage zip only swaps the .mcp.json URL for the stage gateway. Never submit it to the
directory.
"""

import argparse
import json
import pathlib
import zipfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
PLUGIN = ROOT / "zacks-financial-data"
STAGE_URL = "https://zacks-gateway-o5w6zsrgta-uc.a.run.app/"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", choices=["prod", "stage"], default="prod")
    parser.add_argument("--stage-url", default=STAGE_URL)
    args = parser.parse_args()

    name = "zacks-financial-data" + ("" if args.target == "prod" else "-stage") + ".zip"
    out = ROOT / "dist" / name
    out.parent.mkdir(exist_ok=True)
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as zf:
        for path in sorted(PLUGIN.rglob("*")):
            if not path.is_file():
                continue
            arc = str(pathlib.Path("zacks-financial-data") / path.relative_to(PLUGIN))
            if path.name == ".mcp.json" and args.target == "stage":
                doc = json.loads(path.read_text())
                doc["mcpServers"]["zacks-financial-data"]["url"] = args.stage_url
                zf.writestr(arc, json.dumps(doc, indent=2) + "\n")
            else:
                zf.write(path, arc)
    print(f"built {out}")


if __name__ == "__main__":
    main()
