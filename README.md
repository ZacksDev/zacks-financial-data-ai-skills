# Zacks Financial Data

The plugin adds Zacks Investment Research workflows to Claude (claude.ai chat, Cowork and Claude Code), on top of the Zacks Financial Data connector:

- **market-extremes**: finds overbought and oversold US stocks with four Zacks screens, then charts and tables them. Uses 40 of the 100 daily screening rows.
- **portfolio-report**: reviews a portfolio or watchlist. It covers return attribution, sector and industry weights, a comparison with benchmark ETFs (SPY and QQQ by default), Zacks Rank changes with the estimate revisions and Street actions behind them, Zacks' industry outlook for the largest exposures, and Zacks' view on the holdings that changed.
- **portfolio-rebalance**: proposes Zacks-ranked replacement candidates and new weights for flagged holdings (weak Rank, recent downgrade, bottom-quartile industry or over a concentration cap), and shows the portfolio before and after. Uses one custom screen per flagged holding.
- **get-market-indices-benchmarks**: maps a named index to its stand-in ETF (exact stand-ins, closest-ETF proxies, and indices with no stand-in), with SPY and QQQ as default benchmarks. Uses no screening rows.

## How to use it

Install the plugin, open its Connectors tab, connect **Zacks Financial Data** and sign in with your Zacks account. Then ask Claude, for example, "show me this week's market extremes" or "review my portfolio: AAPL 30, MSFT 25, NVDA 20, JPM 15, XOM 10", then "suggest a rebalance".

## What data it sends

The plugin itself stores nothing. Your requests (tickers, screen criteria and portfolio symbols) go only to the declared Zacks connector at `https://mcp.zacksdata.com/`, which answers with Zacks data. The skills tell Claude to use only Zacks data, to label any number it derives as a calculation, and to cite zacks.com sources. See the [privacy policy](https://zacksdata.com/privacy/).

## For maintainers

This repository is the plugin. It is also the only home of the playbook text: the Zacks MCP gateway downloads `main` when its image is built, and serves each `skills/*/SKILL.md` through its `get_zacks_playbook` tool to every assistant, not only Claude. So:

- Keep each skill's body client-neutral. Make chart, artifact and code steps conditional ("if your client can render charts...").
- Keep the frontmatter `metadata` fields (`playbook_id`, `title`, `use_when`, `tools_used`, `quota_note`, `updated`) and the `## Guardrails`, `## Sources and citation` and `## Feedback` sections, which the tool returns as separate fields. If one is missing, the gateway build fails.
- To release, raise `version` in `.claude-plugin/plugin.json` and merge to `main`. The Claude directory publishes the plugin, and the next gateway deploy serves the new text.
- To check a change, run `claude plugin validate --profile directory .`.

## License

MIT. See [LICENSE](LICENSE).
