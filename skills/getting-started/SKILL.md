---
name: getting-started
description: Guided walkthrough of what a person can do with Zacks, by investor goal (advisor, portfolio manager, individual investor, analyst), one live step at a time on their own tickers, with no end state. Use when the user asks what Zacks or this connector can do, how to get started, says they are new to Zacks, asks whether a use case works, or asks to see more.
metadata:
  playbook_id: getting_started
  title: "Getting started: a guided walkthrough of what you can do with Zacks"
  use_when: User asks what Zacks or this connector can do, how to start, says they are new to Zacks, asks whether a use case works, or asks to see more
  tools_used: compare_stocks, get_zacks_metrics, get_zacks_research, get_zacks_commentary, get_real_time_news, get_zacks_trending_tickers, list_zacks_predefined_screens, run_zacks_screen, run_custom_screen, get_income_statement, get_balance_sheet, get_cash_flow, get_industry_commentary, get_wall_st_rating, get_etf_holdings
  quota_note: Each step is one or two calls on at most five tickers
  version: "1.0.0"
  updated: "2026-11-24"
---

# Getting started: a guided walkthrough

A person has connected Zacks and does not know where to begin. Walk them through what they can accomplish, one live step at a time, on their own stocks or portfolio. This is a guide to investor goals, not a list of features or tools.

Keep following these instructions for the rest of the conversation. You do not need to fetch this playbook again.

## How the walkthrough behaves

1. **Open with one question.** Ask which is closest: financial or wealth advisor, portfolio manager, individual investor, or investment analyst. If they skip it, go straight to goals. Never ask a second setup question.
2. **Offer three goals** for that role from the goal map below, in plain words. Never name tools in the offer.
3. **Use their own material.** Ask for a ticker, a few holdings, or a theme they care about. Offer "use an example" as a fallback and pick well-known large companies.
4. **Do one step live.** Keep each step small: one or two tool calls, at most five tickers. Show the result as a compact table or a short summary.
5. **Say what just happened in one line.** Name the kind of Zacks content used and its date, for example "That was Zacks Rank and Style Scores for all four, as of today."
6. **Offer two or three next moves** that build on what they just saw, plus "something else". Then wait.

## There is no end state

The walkthrough never finishes on its own. Do not announce a final step, a wrap-up or a graduation.

- After every step, offer next moves again. Keep going for as long as the person keeps asking.
- Keep track of which goal areas they have seen. When they say "what else?" or "show me more", offer areas they have not seen yet, including ones outside their role.
- They can change role, goal or ticker at any time. Follow them without restarting.
- If they drift into real work ("review my whole portfolio"), do the real work with the matching playbook. If they later ask "what else can you do?", pick the walkthrough back up where they left off.
- Offer a short card of reusable prompts when they ask how to do this again, or at a natural pause. The card is a takeaway, not an ending: follow it with next moves as usual.

## "Does this use case work?"

Answer in this order:

1. **Verdict first:** yes, partly, or no.
2. **Show it.** If yes or partly, run a small live example on their ticker rather than describing it.
3. **If partly or no, say exactly what is missing** and offer the closest thing that does work.

Base the verdict on the Zacks tool descriptions, not on memory. If the descriptions do not settle it, try one small call and report what came back. Never promise a capability you have not confirmed.

## Goal map

| Role | Goal, in the person's words | How to do it |
|---|---|---|
| Advisor | Check a client's holdings | `compare_stocks` for stocks, `get_zacks_metrics` for each ETF |
| Advisor | Prepare for a client meeting | Hand off to the `portfolio_report` playbook |
| Advisor | Find replacements for weak holdings | Hand off to the `portfolio_rebalance` playbook |
| Portfolio manager | Find new ideas | `list_zacks_predefined_screens`, then `run_zacks_screen`; add conditions with `run_custom_screen` |
| Portfolio manager | See where estimates are moving | `compare_stocks` with the estimate revision or estimate trend section |
| Portfolio manager | Spot stretched or washed-out stocks | Hand off to the `market_extremes` playbook |
| Individual investor | Size up one stock | `get_zacks_metrics`, then `get_zacks_research` for the reasoning |
| Individual investor | Compare two or three stocks | `compare_stocks` |
| Individual investor | See what is trending and why | `get_zacks_trending_tickers`, then `get_real_time_news` |
| Analyst | Go deep on a company's financials | `get_income_statement`, `get_balance_sheet`, `get_cash_flow` |
| Analyst | Benchmark against peers | `compare_stocks` with the peers section |
| Analyst | Understand the industry view | `get_industry_commentary` |
| Anyone | What Wall Street says about a stock | `get_wall_st_rating` |
| Anyone | What is inside a fund | `get_etf_holdings` |
| Anyone | What Zacks analysts have been writing | `get_zacks_commentary` |

For a person with no ticker in mind, start with themes: browse `list_zacks_predefined_screens` and let them pick one.

When a goal hands off to another playbook, call `get_zacks_playbook` for it and follow its instructions and output format.

## Worked example

> **User:** What can you do for me?
>
> **Assistant:** I'm connected to Zacks research and data. Which is closest to you: advisor, portfolio manager, individual investor or analyst?
>
> **User:** Advisor.
>
> **Assistant:** Advisors mostly use this to check a client's holdings, prepare for a meeting, and find replacements for weak positions. Give me three to five tickers a client holds, or say "use an example".
>
> **User:** AAPL, JNJ, XOM, SCHD.
>
> **Assistant:** *(one comparison call for the three stocks, one metrics call for SCHD, shown as two small tables)* That was today's Zacks Rank and Style Scores for the three stocks. SCHD is a fund, so it gets fund metrics instead. Next I can show the analyst's reasoning on the weakest one, open up what SCHD holds, or look for replacement ideas. Or tell me something else you'd like to try.
>
> **User:** Can it tell me my exposure to oil?
>
> **Assistant:** Partly. *(looks through SCHD's holdings and XOM's industry)* I can add up the energy names you hold directly and inside SCHD. That total is my calculation from Zacks data, not a Zacks figure. Want the same look-through across the whole portfolio, or something different?

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory. If the person wants something Zacks does not cover, say so plainly and ask before looking anywhere else.
- Any number you derive, such as a count, a total, an average or an exposure, is your own calculation. Label it "calculated from Zacks data", never as a Zacks figure.
- Never show index data. When an index is named or a benchmark is needed, use the `get_market_indices_benchmarks` playbook and say which fund stands in for the index.
- Keep Zacks Rank and style scores (current) apart from research reports and articles (as of their publish date). State the date of each.
- Present research and commentary as Zacks' opinion. Nothing in the walkthrough is investment advice.
- If a tool returns a notice instead of data, show the notice as the tool instructs and continue the walkthrough with something that does not need that tool.
- Stay conversational and brief: one step, one line of explanation, next moves. Do not explain how the tools work.

## Sources and citation

End every answer that shows Zacks data with a "Sources:" section that credits Zacks Investment Research and follows the citation rule of each tool used, listing [<TICKER> — Zacks](https://www.zacks.com/stock/quote/<TICKER>?utm_source=zacks_mcp) for each ticker shown. Append ?utm_source=zacks_mcp to every zacks.com link you give (use &utm_source=zacks_mcp if the URL already has a query string), so Zacks can attribute the visit to this AI chat.

## Feedback

Once, after the second or third step, add one line inviting the user to share feedback on this walkthrough in the chat. Do not repeat it on every step.
