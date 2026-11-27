---
name: portfolio-rebalance
description: Propose replacement candidates and new weights for a stock portfolio using Zacks data - flag weak or concentrated holdings, find candidates among industry peers, Zacks screens and thematic screens, compare them side by side on the client's goal, and show the portfolio before and after. Use when the user asks to rebalance, reposition, upgrade or find replacements for holdings in a portfolio. Run the portfolio-report skill first if the portfolio has not been reviewed in this conversation.
metadata:
  playbook_id: portfolio_rebalance
  title: "Portfolio rebalance: flagged holdings, Zacks-ranked candidates and proposed weights"
  use_when: User asks to rebalance, reposition, upgrade or find replacements for holdings in a portfolio
  tools_used: compare_stocks, get_zacks_trending_tickers, run_custom_screen, get_custom_screen_criteria, get_industry_commentary, get_zacks_research, get_zacks_commentary
  version: "0.3.0"
  updated: "2026-11-27"
---

# Portfolio rebalance

Turn a reviewed portfolio into a set of rebalance proposals for the advisor or investor to decide on: which holdings are flagged and why, which Zacks-covered candidates could replace them, and what the portfolio would look like after. Everything here is a proposal built from Zacks data and labelled as such; suitability, taxes, timing and execution belong to the advisor.

## Inputs

- The holdings and weights (from the portfolio-report run in this conversation, or from the user as in that skill's step 1: tickers and weights only).
- The client's goal, in the user's words: income, growth, lower risk, lower concentration, or "upgrade the Zacks Ranks". Ask once if it is not given; default to "upgrade the Zacks Ranks while keeping the sector mix".
- Constraints the user states: holdings to keep, number of positions, no new sectors, and their concentration caps (maximum weight for one name and for one sector). There are no default caps: if the user gives none, report concentration shares as figures and do not flag on them.

## Steps

1. **Flag holdings.** From the review data (`compare_stocks` profile for every holding, 5 per call if not already fetched), flag a holding when any of these is true, and say which:
   - Zacks Rank 4 or 5.
   - Downgraded in the last 60 days to Rank 3 or worse from Rank 1 or 2 (`prev_value`, `last_change_date`).
   - Zacks industry in the bottom quartile of the industry ranking (industry position fields).
   - Concentration: a single name or a sector above the cap the user gave. With no cap given, show the top-5 and largest-sector shares (calculated) without a flag.
   Do not flag on price moves alone.
2. **Trending check.** Call `get_zacks_trending_tickers` once with `count: 10`. Mark any flagged holding and, later, any candidate that appears on the list. It is context for the conversation, never a reason to add or remove a name.
3. **Find candidates** for each flagged holding, from three sources, all Zacks-ranked or Zacks-named:
   - `compare_stocks` with `section = "PEERS"` on the flagged holding; keep the Rank 1 and 2 peers.
   - A screen: `run_custom_screen` with Zacks Rank <= 2 plus the goal criterion (dividend yield for income, projected EPS growth for growth, beta or Value Score for lower risk), over a matching thematic screen as `base_screen_id` when the holding sits in a theme the user cares about, otherwise over the holding's Industry. One screen per flagged holding.
   - Zacks commentary. `get_industry_commentary` for the flagged holding's industry: take the stocks Zacks names in it. When a thematic screen was run, also take the names singled out in its related article. Mark these candidates as "named by Zacks" with the article date, and still check their current Zacks Rank in step 4.
   Merge the three lists, drop names already in the portfolio, and keep 2-4 candidates per flagged holding. A holding with no Rank 1-2 peer or screen match is reported as "no Zacks-ranked replacement found in its industry"; do not substitute a different industry unless the user allows a sector change.
4. **Compare.** One `compare_stocks` call per flagged holding: the holding plus its candidates (5 tickers maximum), with the `section` that matches the goal: `CFIN` for income or value, `GRAT` for growth, `ETR` or `ERV` for estimate momentum, `BR` for Street sentiment. Name the field each candidate is ranked on.
5. **Zacks' view on the leading candidate** for each flagged holding: `get_zacks_research` only for that one name; `get_zacks_commentary` (`rec_count: 2`) only if the research report is older than 30 days, or there is none.
6. **Propose weights.** Build the after-portfolio as a calculation: by default a replacement takes the flagged holding's weight; a concentration flag is cut to the limit and the excess goes pro rata to the Rank 1-2 holdings, or to the candidates if the user prefers. Then recompute, as in the report skill and labelled as calculations: sector weights, weighted average Zacks Rank, share of weight in Rank 1-2 and 4-5, top-5 concentration. Show before and after.

## Output

1. **Summary**: how many holdings are flagged and why, how many have Zacks-ranked candidates, and the before/after weighted Zacks Rank and sector mix in one sentence each.
2. **Flagged holdings table**: ticker, weight, Zacks Rank (and previous Rank with change date), industry position, flag reason(s), trending (yes/no).
3. **Candidates per flagged holding**: a side-by-side table from step 4 (holding first, then candidates), with the goal fields, Zacks Rank, Value/Growth/Momentum scores, industry position and trending flag. One line naming the leading candidate and the field that decides it.
4. **Zacks' view on each leading candidate**: Rank as of the latest trade date first, then the research position with its `publish_date`, then commentary if fetched, dated.
5. **Before and after**: a table of holdings and weights, old and new, with the recalculated sector mix, weighted Rank and concentration shares. A bar chart of sector weights before and after if your client can render charts.
6. **Open decisions for the advisor**: a short list - tax lots, position sizing, timing against earnings dates (from the profile), any constraint the proposal could not satisfy.

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- Every proposed weight and every before/after figure is a calculation from Zacks data and is labelled as such. Zacks Rank, scores, industry positions and screen results are Zacks figures.
- Proposals are for discussion. Write "candidate" and "proposed weight", never "buy", "sell" or "trade". For an advisor, the output is material for the client conversation; suitability, taxes and timing are the advisor's decisions and are listed under open decisions, not resolved.
- Trending status is context only; never rank, add or drop a name because it is trending.
- Keep the calls bounded: one screen per flagged holding, one research report per flagged holding, peers only for flagged holdings.
- Never show index data. Every index means its ETF from the index-to-ETF mapping (S&P 500 is SPY, Nasdaq-100 is QQQ, Russell 2000 is IWM).
- Holdings the user asked to keep are never flagged for replacement; they can still be flagged for concentration, with the cut shown as optional.

## Sources and citation

One "Sources:" section for the whole proposal, in the format the tools specify: every holding and candidate shown, the screens used by name, and every research report, industry commentary and commentary piece used.

## Feedback

Close with one line inviting the user to share feedback on this rebalance proposal in the chat.
