---
name: portfolio-report
description: Analyze or review a stock portfolio or watchlist with Zacks data, covering return attribution, sector mix, a comparison with SPY and QQQ, and Zacks' view on the largest holdings. Use when the user asks to analyze, review, grade or report on a portfolio, holdings or watchlist.
metadata:
  playbook_id: portfolio_report
  title: "Portfolio report: attribution, sectors, benchmarks and the Zacks view"
  use_when: User asks to analyze or review a portfolio, holdings or watchlist
  tools_used: compare_stocks, get_zacks_metrics, get_zacks_commentary, get_zacks_research
  quota_note: Uses no screening rows; one compare_stocks call per 5 holdings, plus 2 benchmark and up to 10 research calls
  updated: "2026-11-03"
---

# Portfolio report

Build a portfolio review from Zacks data: what drove the returns, where the money sits, how it compares with the market, and what Zacks thinks of the largest positions.

## Steps

1. **Read the holdings.** Take tickers and weights from the user, for example "AAPL 30, MSFT 25". If the user gives share counts or dollar amounts instead, convert them to weights after step 2 using `last_close`. If no weights are given, use equal weights and say so. Make the weights sum to 100%. Ask for the tickers if the user only names a saved portfolio.
2. **Profile every holding.** Call `compare_stocks` with up to 5 tickers per call (default `section`), until every holding is covered. Name every symbol listed under "Not Returned" and explain why, for example "SPY is an ETF, which this comparison does not cover". Leave those symbols out of the calculations and say so.
3. **Benchmarks.** Call `get_zacks_metrics` once for `SPY` and once for `QQQ`, and take their price changes over the same windows. An ETF returns fund metrics, so a window can be missing, for example when only `ytd_pct_change` comes back. Compare only the windows both sides have, and say which ones are missing.
4. **Zacks view on the top holdings.** For the 5 largest holdings by weight, call `get_zacks_research` and `get_zacks_commentary` (default lookback, `rec_count: 3`).
5. **Calculate.** If you can run code, compute in code; otherwise compute step by step and show the inputs. Every result below is a calculation, not a Zacks figure:
   - Contribution per holding = weight × % price change, for 4 weeks, 12 weeks and YTD. The portfolio return is the sum.
   - Sector weights = the sum of holding weights per Zacks sector.
   - Weighted average Zacks Rank, and the share of weight in Zacks Rank 1 or 2 versus 4 or 5.
   - Portfolio return minus SPY and minus QQQ, for each window.

## Output

1. **Summary**: three or four sentences giving the portfolio's YTD return against SPY and QQQ, its biggest contributor and detractor, and its sector tilt.
2. **Holdings table**: ticker, company, weight, Zacks Rank, sector, 4-week %, 12-week %, YTD %, forward P/E (F1), next earnings date.
3. **Attribution table**: ticker, weight, YTD %, YTD contribution in percentage points, sorted by contribution.
4. **Sectors**: if your client can render charts, draw a bar chart of sector weights; otherwise show a table.
5. **Benchmarks table**: rows for Portfolio, SPY and QQQ, with columns for 4-week, 12-week and YTD %.
6. **Zacks view on the top 5**: for each holding, give the current Zacks Rank as of the latest trade date first. Then add the research report's position, with its `publish_date` stated, and up to two recent commentary pieces, each dated. Keep them in time order and never merge them into a single view.

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- Label every number you computed (contributions, sector weights, averages, differences from a benchmark) as "calculated from Zacks data". Show Zacks' own fields as Zacks figures.
- Keep dated research separate from the daily Zacks Rank. Research reports and commentary are opinions as of their publish date, while the Rank is recomputed daily. State both dates and never present a figure from a report as current.
- Present the narrative as Zacks' opinion, attributed and dated. This is not investment advice.

## Sources and citation

End with a "Sources:" section that credits Zacks Investment Research. List [<TICKER> — Zacks](https://www.zacks.com/stock/quote/<TICKER>?utm_source=zacks_mcp) for every holding, and the exact URL of each research report and commentary piece you used. Append ?utm_source=zacks_mcp to every zacks.com link you give (use &utm_source=zacks_mcp if the URL already has a query string), so Zacks can attribute the visit to this AI chat.

## Feedback

Close with one line inviting the user to share feedback on this portfolio report in the chat.
