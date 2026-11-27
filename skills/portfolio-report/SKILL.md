---
name: portfolio-report
description: Review a stock portfolio or watchlist with Zacks data - return attribution, sector and industry position, comparison with the market benchmark ETFs (SPY and QQQ by default, or the ETF standing for any index the user names), Zacks Rank changes with the estimate revisions and Street actions behind them, Zacks' industry outlook for the largest exposures, and Zacks' view on the holdings that changed. Use when the user asks to analyze, review, grade or report on a portfolio, holdings or watchlist. For replacement ideas or new weights, use the portfolio-rebalance skill after this one.
metadata:
  playbook_id: portfolio_report
  title: "Portfolio report: attribution, sectors, benchmarks, Rank changes and the Zacks view"
  use_when: User asks to analyze, review, grade or report on a portfolio, holdings or watchlist
  tools_used: compare_stocks, get_zacks_metrics, get_etf_holdings, get_industry_commentary, get_zacks_research, get_wall_st_rating, get_zacks_commentary, get_real_time_news
  version: "1.3.0"
  updated: "2026-11-27"
---

# Portfolio report

Build a portfolio review from Zacks data: what drove the returns, where the money sits, how it compares with the market, what has changed in Zacks' view and why, what Zacks says about the industries the portfolio leans on, and what Zacks says about the holdings that changed.

## Steps

1. **Read the holdings.** Take tickers and weights from the user: typed ("AAPL 30, MSFT 25"), or from an attached CSV, spreadsheet or table. Use only the ticker and weight columns; every other column in the file is the user's own data and may be stale, so never use it as a figure, a baseline or a label in the report. If the user gives share counts or dollar amounts, convert them to weights after step 2 using the previous-day close from the profile. If no weights are given, use equal weights and say so. Make the weights sum to 100%. Ask for the tickers if the user only names a saved portfolio.
2. **Profile every equity.** Call `compare_stocks`, 5 tickers per call, until every holding is covered. Symbols the tool did not return stay out of every calculation. Keep, per holding, the industry rank and position fields, the 4-week change in the F1 and F2 consensus estimates, and `is_zer` (N means no analyst report); all are used below.
3. **ETFs and funds in the portfolio.** For each ETF, call `get_zacks_metrics` and `get_etf_holdings`. Treat the returned holdings as look-through exposure in the sector mix. Mutual funds, CUSIP-only positions and cash are listed as not covered.
4. **Benchmarks.** `get_zacks_metrics` for `SPY` and `QQQ` by default; if the user names another index, use the ETF that stands for it in the index-to-ETF mapping. The benchmark comparison is YTD (`ytd_pct_change`). For the shorter windows use the per-holding `4w_sp500` and `12w_sp500` fields from step 2.
5. **Rank changes and what is behind them.** From step 2, list every holding with its `zacks_rank.value`, `prev_value` and `last_change_date`; sort newest first and mark the changes inside the last 60 days. For the holdings that changed in that window, and for any holding now at Rank 4 or 5, call `compare_stocks` once more per group of 5 with `section = "ERV"` and once with `section = "BR"`: the revisions explain the Rank move, and the broker counts show whether the Street moved with Zacks or against it.
6. **Industry outlook for the largest exposures.** Take the two or three Zacks industries that carry the most weight (from step 2, after look-through). Call `get_industry_commentary` for each. Use it to frame the sector concentration, and note which of the portfolio's holdings in that industry Zacks names, if any. Report each industry's current position only; the tools carry no history of it, so never describe an industry's rank as having changed.
7. **Select the holdings for the Zacks view.** Pick up to 5, in this order, until 5 are filled: (a) holdings now at Zacks Rank 4 or 5; (b) holdings upgraded to Rank 1 or 2 in the last 60 days; (c) the largest YTD detractor and the largest YTD contributor (from step 9); (d) the largest holdings by weight. Skip `is_zer = N` holdings in (a)-(d) and say they were skipped. For each selected holding: `get_zacks_research`; `get_wall_st_rating` with `day_range` "0-30"; `get_zacks_commentary` (`rec_count: 2`), keeping only pieces whose subject is that company. Skip ETF round-ups, Focus List and "trending stock" boilerplate where the ticker is one of many.
8. **What happened.** For holdings that moved 15% or more in the last 4 weeks, or that report earnings within 30 days, and are not already in step 7, call `get_real_time_news` (default count) and keep the newest one or two items that explain the move or preview the report. Give each item's publish date.
9. **Calculate.** If you can run code, compute in code; otherwise compute step by step and show the inputs. Every result below is a calculation, not a Zacks figure:
   - Contribution per holding = weight x % price change, for 4 weeks, 12 weeks and YTD; the portfolio return is the sum.
   - Sector weights = the sum of holding weights per Zacks sector, with ETF look-through from step 3.
   - Weighted average Zacks Rank; share of weight in Rank 1-2 versus 4-5; share of weight in holdings whose Zacks industry is in the top or bottom quartile (from the industry position fields).
   - Portfolio YTD return minus each benchmark ETF's YTD; weighted average of `4w_sp500` and `12w_sp500`.
   - Top-5 concentration and largest single sector, as shares of weight.

## Output

1. **Summary**: four sentences: YTD return against the benchmark ETFs; biggest contributor and detractor; sector tilt and what Zacks says about the largest industry; how many holdings changed Rank in the last 60 days and in which direction.
2. **Rank changes**: one row per holding, newest change first: ticker, previous Rank, current Rank, change date, direction, 4-week change in the F1 estimate (%), estimate revisions up/down over 30 days (ERV), broker rating shift over 4 weeks (BR). Grey out or separate rows older than 60 days.
3. **Holdings table**: ticker, company, weight, Zacks Rank, Zacks industry and its position (rank out of total), 4-week %, 12-week %, YTD %, forward P/E (F1), next earnings date. Mark holdings with no analyst report.
4. **Attribution**: bar chart (or table) of YTD contribution per holding, sorted.
5. **Sectors and industries**: bar chart (or table) of sector weights; a short table of the top industries by weight with Zacks' industry position and a one-line summary of the industry commentary, dated.
6. **Benchmarks table**: Portfolio and each benchmark ETF with the YTD column, plus the portfolio's weighted 4-week and 12-week return relative to the S&P 500.
7. **Zacks view on the selected holdings**: for each, the current Zacks Rank as of the latest trade date first, then the research report's position with its `publish_date`, then the Street actions from step 7 with their dates, then any commentary piece with its date. Keep them in time order and never merge them. Say in one line why each holding was selected.
8. **What happened**: the step-8 items, one line each, with dates.

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- The user's file contributes tickers and weights only. Any other column in it is never shown, compared against or used as a baseline.
- Label every number you computed (contributions, sector weights, averages, relative returns, concentration shares, differences from a benchmark) as "calculated from Zacks data". Show Zacks' own fields as Zacks figures.
- Never show index data. Every index means its ETF from the index-to-ETF mapping (S&P 500 is SPY, Nasdaq-100 is QQQ, Russell 2000 is IWM), and say so.
- Present the narrative as Zacks' opinion, attributed and dated. This is not investment advice. For an advisor, every item is a talking point for the client conversation, not a trade instruction. Do not propose trades, replacements or new weights here; offer the portfolio-rebalance skill instead, or, for an ETF-level allocation, the ETF portfolio construction playbook.
- Holdings that are not Zacks-covered equities are listed as not covered, never dropped silently.

## Sources and citation

One "Sources:" section for the whole report, in the format the tools specify: every holding and benchmark ETF, and every research report, industry commentary, commentary piece and news item used.

## Feedback

Close with one line inviting the user to share feedback on this portfolio report in the chat.
