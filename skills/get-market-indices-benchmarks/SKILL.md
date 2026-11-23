---
name: get-market-indices-benchmarks
description: Map a market index to the ETF that stands in for it in Zacks data. Use whenever an index is named or needed, such as a benchmark, a market comparison or "how did the market do", and as the index-to-ETF mapping that the portfolio-report and portfolio-rebalance skills refer to.
metadata:
  playbook_id: get_market_indices_benchmarks
  title: "Market indices and benchmarks: the ETF that stands in for each index"
  use_when: An index is named or needed, for a benchmark, a market comparison or how the market did
  tools_used: get_zacks_metrics
  quota_note: Uses one distinct ticker of the plan's daily ticker budget per benchmark ETF (2 by default; repeats are free); one get_zacks_metrics call per benchmark ETF
  version: "0.1.0"
  updated: "2026-11-23"
---

# Market indices and benchmarks

Zacks data has no index levels. Whenever an index is named or needed (a benchmark, a market comparison), use its stand-in ETF and say so.

## Index-to-ETF mapping

**Exact stand-ins:**

| Index | ETF |
|---|---|
| S&P 500 | SPY |
| Nasdaq-100 | QQQ |
| Dow Industrials | DIA |
| Nasdaq Composite | ONEQ |
| Russell 2000 | IWM |
| S&P 100 | OEF |
| S&P MidCap 400 | IJH |
| S&P SmallCap 600 | IJR |

**Proxies** (call it "the closest ETF", never the index):

| Index | Closest ETF | Note |
|---|---|---|
| Wilshire 5000 | VTI | |
| Dow Transportation | IYT | |
| Dow Utilities | XLU | |
| Dow Composite | DIA | 30 Industrials only |
| NYSE Composite | VTI | weak proxy |

**No stand-in:** AMEX Composite. Say that no ETF represents it.

**Default benchmarks** when none is named: SPY and QQQ.

## Steps

1. Map each index the user names (or the default benchmarks) to its ETF with the tables above.
2. Call `get_zacks_metrics` for those ETFs and use the ETF figures.
3. In the answer, name the ETF next to the index the user asked about, for example "S&P 500 (via SPY)". For a proxy, write "the closest ETF to the Dow Transportation index is IYT" and add the note from the table. For an index with no stand-in, say so and do not substitute another ETF.

## Guardrails

- Never show or quote index levels or index returns. Every index figure is the ETF's figure, and say so.
- A proxy ETF is never described as the index itself.
- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- This is not investment advice.

## Sources and citation

Cite each ETF used with its Zacks quote page, in the format the tools specify, and attribute the figures to Zacks.

## Feedback

Close with one line inviting the user to share feedback on the benchmark comparison in the chat.
