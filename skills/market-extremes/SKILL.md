---
name: market-extremes
description: Find today's market extremes, meaning overbought and oversold US stocks, using Zacks screens. Use when the user asks for market extremes, overbought or oversold stocks, stretched or washed-out names, or stocks at the top or bottom of their 52-week range.
metadata:
  playbook_id: market_extremes
  title: "Market extremes: overbought and oversold stocks"
  use_when: User asks for market extremes, overbought or oversold, stretched or washed-out stocks
  tools_used: run_custom_screen
  quota_note: Uses up to 40 distinct tickers of the plan's daily ticker budget (4 screens of 10 rows); tickers already used today are free
  updated: "2026-11-23"
---

# Market extremes

Find the US stocks that are most stretched, up or down, using four Zacks screens. Each stock is placed on two measures:

- **Range position**: price as a % of its 52-week high-low range (item 14020). 0 = at the 52-week low, 100 = at the high.
- **Momentum**: % price change over 4 weeks (item 14035).

The four screens are the four corners of that grid.

## Steps

1. Run these four calls to `run_custom_screen`, in any order. Every call uses `universe: "stock"`, `limit: 10`, and `columns: ["14020", "14035", "14040", "14045"]`. Every call also includes the size filter `{"item_id": "12010", "operator": ">=", "value": 2000}` (market cap of at least $2B), so thinly traded names don't crowd the list.

   | Bucket | Criteria (added to the size filter) | sort_by |
   | --- | --- | --- |
   | Overbought | 14020 >= 90, 14035 >= 15 | `14035:desc` |
   | Oversold | 14020 <= 10, 14035 <= -15 | `14035:asc` |
   | Pullback near highs | 14020 >= 80, 14035 <= -8 | `14035:asc` |
   | Bounce off lows | 14020 <= 20, 14035 >= 8 | `14035:desc` |

2. Do not page further or rerun a screen. The user's plan has a daily budget of distinct tickers, and the four calls can use up to 40 of it (tickers already used today are free). Make extra calls only if the user asks for them.
3. For each bucket, note `total_count` (how many stocks matched in all) and `as_of`. `total_count` 0 means no stock matched. `null` means the screen is unavailable right now: say so, and never report it as "no matches".
4. If a response carries a `plan_notice` (the result starts with "Plan limit reached:"), the plan's daily ticker limit was hit. Show `plan_notice.message` to the user exactly as returned, show any rows that did come back, and say how many rows were not returned (`plan_notice.rows_not_returned`), for example "showing 3 of 81 matches; 7 rows not returned because of the plan limit". It is not an empty result: never say "no matches" for what the notice cut. Do not retry, or run the remaining screens, before `plan_notice.resets_at`.

## Output

1. **One-line summary**: the as-of date, and how many stocks matched each bucket (using `total_count`).
2. **Chart**: if your client can render charts, draw a scatter plot of every returned stock, with 4-week % change on x and range position on y. Color the points by bucket and label them with tickers. Draw reference lines at x = 0 and y = 50. If you cannot render charts, skip this and rely on the tables.
3. **Overbought table**, then an **Oversold table**: ticker, company, industry, Zacks Rank, range position %, 4-week %, 12-week %, YTD %. Sort each as the screen returned it.
4. **Pullback near highs** and **Bounce off lows**: a shorter table each, with ticker, company, Zacks Rank, range position % and 4-week %.
5. **What it means**: two or three sentences. Point out where Zacks Rank agrees or disagrees with the move, for example an overbought stock with Zacks Rank 4 or 5, or an oversold stock with Zacks Rank 1 or 2. Present these as observations, not advice.

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- Any number you derive, such as a count, an average or a share of the list, is your own calculation. Label it "calculated from Zacks data", never as a Zacks figure.
- RSI caveat: these screens measure range position and price momentum, not RSI. If the user asks about RSI, say that the Zacks screener has no RSI item and these are price-based proxies.
- Overbought and oversold describe price behaviour, not a buy or sell call. This is not investment advice.

## Sources and citation

End with a "Sources:" section that credits Zacks Investment Research and lists [<TICKER> — Zacks](https://www.zacks.com/stock/quote/<TICKER>?utm_source=zacks_mcp) for each stock in the two main tables. Append ?utm_source=zacks_mcp to every zacks.com link you give (use &utm_source=zacks_mcp if the URL already has a query string), so Zacks can attribute the visit to this AI chat.

## Feedback

Close with one line inviting the user to share feedback on this market extremes report in the chat.
