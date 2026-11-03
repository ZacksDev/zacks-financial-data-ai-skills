# Zacks Financial Data: Claude plugin and playbooks

This repository holds the **Zacks Financial Data** Claude plugin and the playbook text that the Zacks MCP server also serves to every assistant through its `get_zacks_playbook` tool.

The plugin adds Zacks Investment Research workflows to Claude (claude.ai chat, Cowork and Claude Code), on top of the Zacks Financial Data connector:

- **market-extremes**: finds overbought and oversold US stocks with four Zacks screens, then charts and tables them. Uses 40 of the 100 daily screening rows.
- **portfolio-report**: reviews a portfolio or watchlist. It covers return attribution, sector weights, a comparison with SPY and QQQ, and Zacks' view on the five largest holdings.

The listing-facing README is [zacks-financial-data/README.md](zacks-financial-data/README.md).

## Layout

```
zacks-financial-data/          the plugin (submitted to the Claude directory)
  .claude-plugin/plugin.json   manifest; `version` is also the playbook version
  .claude-plugin/icon.png
  .mcp.json                    the approved connector URL, no keys
  skills/<skill>/SKILL.md      one workflow each; the single source of truth
scripts/
  check.sh                     validate the plugin and check each skill's size and metadata
  build_zip.py                 build an upload zip (prod, or `--target stage` for testing)
```

## One source of truth

Each `SKILL.md` is served word for word by the MCP tool `get_zacks_playbook`. The gateway copies these files in at build time from a release tag. So the body must work in every client, not only Claude. Steps that need charts, artifacts or code have to stay conditional ("if your client can render charts..."). Each file's frontmatter `metadata` holds the playbook catalog fields (`playbook_id`, `title`, `use_when`, `tools_used`, `quota_note`, `updated`). The `## Guardrails`, `## Sources and citation` and `## Feedback` sections are returned as their own fields.

## Releasing

1. Edit the skill and update `metadata.updated`.
2. Raise `version` in `plugin.json`, run `scripts/check.sh`, then merge to the tracked branch. The Claude directory scans and publishes the new version.
3. Tag `vX.Y.Z`, then sync the gateway's bundled copy (`scripts/sync_playbooks.py` in the MCP server repo) and deploy it.

## License

MIT. See [LICENSE](LICENSE).
