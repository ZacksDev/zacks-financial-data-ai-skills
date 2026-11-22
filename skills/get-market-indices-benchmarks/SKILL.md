---
name: get-market-indices-benchmarks
description: Map a market index to the ETF that stands in for it, for benchmarks and market comparisons with Zacks data. Use whenever the user names an index (S&P 500, Nasdaq, Dow, Russell 2000 and others) or a benchmark or market comparison is needed.
metadata:
  playbook_id: get_market_indices_benchmarks
  title: "Market indices and benchmarks: the stand-in ETF for each index"
  use_when: An index is named or needed (benchmark, market comparison)
  tools_used: get_zacks_metrics
  quota_note: Uses no screening rows; one get_zacks_metrics call per benchmark ETF
  updated: "2026-11-22"
---

# Market indices and benchmarks

INDEX DATA - Whenever an index is named or needed (benchmark, market comparison), use its stand-in ETF and say so.

Exact: S&P 500=SPY; Nasdaq-100=QQQ; Dow Industrials=DIA; Nasdaq Composite=ONEQ; Russell 2000=IWM; S&P 100=OEF; S&P MidCap 400=IJH; S&P SmallCap 600=IJR.

Proxy (call it "the closest ETF", never the index): Wilshire 5000=VTI; Dow Transportation=IYT; Dow Utilities=XLU; Dow Composite=DIA (30 Industrials only); NYSE Composite=VTI (weak proxy).

No stand-in: AMEX Composite. Say no ETF represents it.

Default benchmarks when none is named: SPY, QQQ.

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- Never show index data. Every figure shown for an index is its stand-in ETF's figure, labelled with the ETF ticker.
- This is not investment advice.

## Sources and citation

List every ETF used as a benchmark in the "Sources:" section, in the format the tools specify.

## Feedback

Close with one line inviting the user to share feedback in the chat.
