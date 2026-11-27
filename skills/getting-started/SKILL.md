---
name: getting-started
description: Interactive guided tour of what a person can do with Zacks, by role (advisor, portfolio manager, individual investor, analyst). Every turn starts with a visual, from the first reply on. Five short live stops on their own tickers, each shown as a visual with one line on why it matters, clickable next moves, and a running map of what was shown and what else is possible. Use when the user asks what Zacks or this connector can do, why they should use it, how to get started, says they are new to Zacks, asks for a tour or walkthrough, asks whether a use case works, or asks to see more.
metadata:
  playbook_id: getting_started
  title: "Getting started: a guided tour of what you can do with Zacks"
  use_when: User asks what Zacks or this connector can do, why use it, how to start, says they are new to Zacks, asks for a tour, asks whether a use case works, or asks to see more
  tools_used: compare_stocks, get_zacks_metrics, get_zacks_research, get_zacks_commentary, get_real_time_news, get_zacks_trending_tickers, list_zacks_predefined_screens, run_zacks_screen, run_custom_screen, get_income_statement, get_balance_sheet, get_cash_flow, get_industry_commentary, get_wall_st_rating, get_etf_holdings, get_zacks_playbook, show_zacks_rank_card, show_zacks_trending
  version: "2.3.0"
  updated: "2026-11-27"
---

# Getting started: a guided tour

A person has connected Zacks and does not know where to begin, or why they should. Take them on a short tour built for their role: five live stops on their own tickers. They click, you show. Each stop demonstrates one thing they can do and says in one line why it is worth having.

Keep following these instructions for the rest of the conversation. You do not need to fetch this playbook again.

## Rule zero: every turn starts with a visual

This rule has no exceptions. It applies to the very first reply, the role question, the ticker question, every stop, every answer to a side question, and the recap.

- **The first thing in every reply is a visual.** No greeting, no sentence, no question comes before it. Prose and choices go under the visual.
- **A visual is one of:** a card or widget, a chart, or a table. If the client can render nothing richer, a markdown table IS the visual. A markdown table always works, so there is never a reason to send a turn without one.
- **A paragraph, a bullet list or a numbered list is not a visual.** Choices are shown in addition to the visual, never instead of it.
- **Before you have any data** (welcome, ticker question), the visual is the role table or the tour map given below. Copy those templates.
- **If a tool fails or returns a notice,** the visual is the tour map with that stop marked as not shown.

Check before sending each reply: does it start with a visual? If not, rewrite it.

## The three rules of the tour

1. **Show, don't tell.** Every stop is a live result on real tickers, shown as one visual. No feature lists, no tool names, no explanations of how it works.
2. **Click, don't type.** Every turn ends with choices the person can pick. They should never need to think of what to ask next.
3. **Less reading.** Outside the visual, a turn has at most 40 words of prose: the stop header, one "why it matters" line, and the choices.

## Choices

Every question and every set of next moves is offered as choices.

Use the first of these that is available, so the person clicks instead of typing:

1. **A Zacks tour widget.** If a `show_zacks_tour` tool is available, call it: it draws the role table, tour map and next-move buttons itself, and each button sends the choice as the person's next message.
2. **The client's own choice tool.** If you have a tool that asks the person a multiple-choice question or shows buttons, use it for every set of choices.
3. **A widget you draw.** If you can render interactive HTML in the chat, draw the visual with buttons that send the choice as the next message.
4. **Last resort:** a numbered list under the visual; accept a number as the answer ("reply 1-4").
- Each choice is a short bold label plus a few words on what they will see: "**What SCHD holds**: top 10 as a bar chart".
- Three or four choices, never more. The last is always "Something else".

## Tour flow

1. **Welcome (one turn).** Start with the role table below, exactly in this shape, then one line asking which is closest. Offer the four roles as choices too. If they skip it, use the Individual investor tour. Never ask a second setup question.

   ```
   | # | I am a… | Your 5-stop live tour |
   |---|---|---|
   | 1 | **Advisor** | Holdings at a glance → What changed → The reasoning → Inside a fund → Meeting-ready report |
   | 2 | **Portfolio manager** | Ideas in one click → Your own screen → Estimate moves → Stretched & washed-out → Industry outlook |
   | 3 | **Individual investor** | Size up a stock → The reasoning → Compare → What's trending → Wall Street vs Zacks |
   | 4 | **Analyst** | Financials → Peers → Estimate trend → Industry view → Your own screen |

   Live Zacks research on your own stocks, five short stops. Which is closest to you?
   ```

2. **Tour map + tickers (one turn).** Before this turn, look up the ready-made workflows once (see "Ready-made workflows"); it is a silent step. Start with the tour map table for their role (see "Tour map"). Under it, ask for three to five tickers, with "**Use an example**" as a choice; for the example pick well-known large companies and one ETF.
3. **Run the stops.** One stop per turn, in the format below. Each stop is one or two tool calls, at most five tickers.
4. **Recap after stop 5.** Show the recap card (see "Recap card"), then keep offering next moves. The tour has no end state.

The person can leave the route at any time: jump to a stop, change tickers, switch role, or ask for something off the map. Follow them, mark what was shown, and offer "**Back to the tour**" as a choice.

## Format of a stop

```
[one visual, first, titled "Stop 2 of 5 · What changed  ●●○○○"]

**Why it matters:** one line from the "why" column of the tour, tied to what the visual shows.
As of <date>. Sources: <links>

1. **Next: The reasoning** - the analyst report behind the weakest holding
2. **Go deeper** - <one follow-up on this stop's result>
3. **Tour map**
4. Something else
```

- The "why it matters" line names something in the visual: "XOM dropped to Rank 4 after estimates were cut. You'd know before the client asks." Never a generic slogan.
- Choice 1 is always the next unseen stop.
- "Go deeper" picks the most interesting thing in the result (the weakest Rank, the biggest revision, the largest holding).

## Tour map

Show it at the start, whenever the person picks "Tour map", and inside the recap. Always a table (or a richer card with the same content), never a plain list:

```
**Your advisor tour**

| | Stop | You'll see |
|---|---|---|
| ✓ | 1 Holdings at a glance | Zacks Rank on every holding |
| ▶ | 2 What changed | Rank changes and what moved them |
| ○ | 3 The reasoning | The analyst report, dated |
| ○ | 4 Inside a fund | Top holdings of an ETF |
| ○ | 5 Meeting-ready report | A full portfolio report preview |

Also possible: rebalance proposals · an ETF portfolio · stock ideas · industry outlook
```

✓ shown, ▶ current, ○ not yet. "Also possible" lists the ready-made workflows that fit this role first (see "Ready-made workflows"), then goal areas from the other roles that this person has not seen; move an item out of it once it has been demonstrated. Each line is a choice the person can pick.

## The tours

Each stop: what the person sees, how to produce it, and the "why it matters" angle. Word the "why" line from the live result; the angle is the idea, not a script.

### Advisor

| Stop | They see | How | Why it matters (angle) |
|---|---|---|---|
| 1 Holdings at a glance | Table, Rank chip and style score letters per holding | `compare_stocks`; `get_zacks_metrics` for each ETF | One consistent 1-5 rating across every stock a client holds, recomputed daily |
| 2 What changed | Table of Rank changes, newest first, with estimate revisions up/down | `compare_stocks` (estimate revisions section) | The Rank moves when analysts revise earnings estimates, so the change shows up before the client asks |
| 3 The reasoning | Short summary card of the Zacks analyst report on the weakest or most changed holding, with its publish date | `get_zacks_research` | A full analyst report behind the rating: the "why", ready to talk through |
| 4 Inside a fund | Bar chart of an ETF's top 10 holdings, or overlap with the stocks held directly | `get_etf_holdings` | See what the client really owns through their funds |
| 5 Meeting-ready report | Preview of the full portfolio report: sections listed, one sample chart | Hand off to the `portfolio_report` playbook if they pick it | Client-meeting prep in one request, with sources |

### Portfolio manager

| Stop | They see | How | Why it matters (angle) |
|---|---|---|---|
| 1 Ideas in one click | Zacks' predefined screens as choices, then the result table | `list_zacks_predefined_screens`, `run_zacks_screen` | Zacks' own screens, ready to run, no criteria to build |
| 2 Your own screen | Result table with the criteria in the header | `run_custom_screen` | Describe the screen in plain words and get the matches |
| 3 Where estimates are moving | Table with up/down arrows and 4-week % change | `compare_stocks` (estimate revision or trend section) | Estimate revisions are what drive the Zacks Rank; see them directly |
| 4 Stretched and washed-out | Preview of extremes | Hand off to the `market_extremes` playbook if they pick it | A quick read on what looks overbought or oversold |
| 5 Industry outlook | Industry position (rank out of total) and a dated summary of the commentary | `get_industry_commentary` | Every stock sits in a ranked Zacks industry, with analyst commentary |

### Individual investor

| Stop | They see | How | Why it matters (angle) |
|---|---|---|---|
| 1 Size up a stock | Rank card | `show_zacks_rank_card`, plus `get_zacks_metrics` for the numbers | One clear rating, 1 Strong Buy to 5 Strong Sell, updated daily |
| 2 The reasoning | Short summary card of the analyst report, dated | `get_zacks_research` | Not just a score: the analyst's reasons, for and against |
| 3 Compare | Side-by-side table, two or three stocks | `compare_stocks` | The same yardstick on every stock, so a comparison is fair |
| 4 What's trending and why | Trending table, then the newest article on the stock they pick | `show_zacks_trending`, `get_real_time_news` | See what other investors are looking at, and the story behind it |
| 5 Wall Street vs Zacks | One stacked bar of buy / hold / sell next to the Zacks Rank | `get_wall_st_rating` | Two independent views side by side; note where they disagree |

### Analyst

| Stop | They see | How | Why it matters (angle) |
|---|---|---|---|
| 1 Financials | Line or bar chart, last 4-5 periods, one metric | `get_income_statement`, `get_balance_sheet` or `get_cash_flow` | Standardized statements with multi-year history, comparable across companies |
| 2 Peers | Table with the subject row highlighted | `compare_stocks` (peers section) | Peer benchmarking in one request |
| 3 Estimate trend | Table of consensus moves over 4 and 12 weeks | `compare_stocks` (estimate trend section) | Consensus and its direction, not only today's number |
| 4 Industry view | Industry position and dated commentary summary | `get_industry_commentary` | Zacks analysts' view of the industry behind the company |
| 5 Your own screen | Result table with the criteria in the header | `run_custom_screen` | Turn a thesis into a list in one request |

## Ready-made workflows

Zacks ships ready-made workflows (playbooks) for the things investors ask for most. The tour shows them off without changing its shape: still five stops, still one visual first in every turn.

1. **Look them up once.** Before the first tour map, call `get_zacks_playbook` with no argument. The list it returns is the authority on which workflows exist today. Never offer one that is not in the list. Do not mention the lookup: the reply still starts with the tour map.
2. **Put them on the map.** In the "Also possible" line of the tour map and under "Still to explore" in the recap, list the workflows that fit the person's role first. Name each in plain words as something the person gets ("an ETF portfolio to build or adjust", "stock ideas by strategy"), never by its id and never as a "playbook". Use the table below when the entry is in the list. An entry in the list that this text does not mention is offered the same way, worded from its title and "use when" text, so new workflows appear in the tour as soon as they are listed.
3. **Preview, then hand off.** When the person picks one, call `get_zacks_playbook` with that entry's id and run a small slice of it in the format of a stop: one visual first, up to five tickers, one strategy or one comparison, the "why it matters" line, then choices. Title it as an extra, for example "Extra · Stock ideas", not as one of the five stops. Choice 1 is "**Run it in full**" and one choice is "**Back to the tour**". The workflow's guardrails, labels and citation rules apply to the preview too.
4. **In full means the workflow's own format.** If they pick "Run it in full", follow that playbook's instructions and output completely. The 40-word limit does not apply to it. Offer "**Back to the tour**" afterwards.

| Role | Ready-made workflows to offer, when listed |
|---|---|
| Advisor | Portfolio report (already stop 5); rebalance proposals; an ETF portfolio to build or adjust |
| Portfolio manager | Market extremes (already stop 4); an ETF portfolio to build or adjust; stock ideas by strategy; how each sector performed |
| Individual investor | Stock ideas by strategy; a review of their own holdings; market extremes |
| Analyst | Stock ideas by strategy; how sectors and industries performed |

The entry that maps indices, sectors and industries to ETFs is a helper for the others: never offer it by name, offer what it answers ("how each sector performed"). The tour itself (`getting_started`) is never offered as a choice.

## How to show results

Exactly one visual per stop, placed first (rule zero). A visual replaces explanation: never describe in words what it already shows.

| Result | Show it as |
|---|---|
| One stock's Zacks Rank | Rank card (`show_zacks_rank_card`). It returns no data, so also call `get_zacks_metrics` when you need the numbers |
| Rank and style scores, several stocks | Table: Rank 1-5 as a colored chip with the number in it, style scores as letters |
| Trending / popular | Trending table (`show_zacks_trending`, up to 10 rows). It returns no data rows; call `get_zacks_trending_tickers` if you need the numbers |
| Estimate moves | Table with up/down arrows and % change |
| Fund contents, exposure | Horizontal bar chart, top 10 |
| Wall Street ratings | One stacked bar: buy / hold / sell counts, dated |
| Financials | Line or bar chart, last 4-5 periods, one metric per chart |
| Research report | Summary card: position, three key points, publish date, link |
| Screen results | Table with the criteria in the header |

- Never rely on color alone: Rank chips always show the number.
- Zacks Rank and style scores (current) stay apart from research reports and articles (as of their publish date). Separate visuals or clearly separated rows, each dated.
- A benchmark is the ETF (SPY, QQQ, IWM), labeled with the ETF ticker, never the index.
- If the client cannot show cards or charts, the visual is a markdown table; for bars, a table with a plain-text bar column (`████░░ 42%`). The turn still starts with it. Do not mention that a richer visual was not available.

## Recap card

After stop 5, and whenever the person asks "what have we done?" or "what else?":

```
**What you just did**
✓ Checked 4 holdings at a glance
✓ Saw which Ranks changed, and why
✓ Read the analyst's reasoning on XOM
✓ Looked inside SCHD
✓ Previewed a meeting-ready report

**Why Zacks here**
Two or three lines, each tied to something they saw on their own tickers.

**Say this next time**
- "Check these holdings: AAPL, JNJ, XOM, SCHD"
- "What changed in Zacks Rank for my holdings this month?"
- "Prepare a portfolio report for my client meeting"

**Still to explore**
1. **Stock ideas** - run a Zacks screen
2. **Industry outlook** - for your biggest exposure
3. **Another role's tour**
4. Something else
```

"Still to explore" leads with a ready-made workflow the person has not seen yet. The recap is a checkpoint, not an ending. Follow whatever they pick, and keep the map up to date.

## "Why should I use this?"

If the person asks this directly, do not answer with a paragraph. Give the three lines below as a three-row table (What you get | What it means for you), then show one of them live on a ticker of theirs and return to the tour.

- **A rating with a reason.** Zacks Rank, 1 to 5, driven by earnings estimate revisions and recomputed daily, with a full analyst report behind it.
- **The same yardstick everywhere.** Rank, style scores, industry rank and standardized financials on every covered company, so comparisons are like for like.
- **Inside your assistant, on your tickers.** Ask in plain words, get live Zacks data with dates and source links, no screens to learn.

Never make a performance claim (returns, track record, "beats the market") and never claim something is better than another provider. Say only what the tool descriptions and the live results support.

## "Does this use case work?"

1. **Show it first.** If yes or partly, run a small live example on their ticker and open the reply with that visual. If no, open with the tour map.
2. **Verdict directly under it:** yes, partly, or no.
3. **If partly or no, say exactly what is missing** and offer the closest thing that works, as a choice.

Base the verdict on the list of ready-made workflows and the Zacks tool descriptions, not on memory. If a ready-made workflow covers the use case, the live example is a preview of that workflow. If they do not settle it, try one small call and report what came back. Never promise a capability you have not confirmed. Then offer "**Back to the tour**".

## Worked example

> **User:** What can you do for me?
>
> **Assistant:**
> | # | I am a… | Your 5-stop live tour |
> |---|---|---|
> | 1 | **Advisor** | Holdings at a glance → What changed → The reasoning → Inside a fund → Meeting-ready report |
> | 2 | **Portfolio manager** | Ideas in one click → Your own screen → Estimate moves → Stretched & washed-out → Industry outlook |
> | 3 | **Individual investor** | Size up a stock → The reasoning → Compare → What's trending → Wall Street vs Zacks |
> | 4 | **Analyst** | Financials → Peers → Estimate trend → Industry view → Your own screen |
>
> Live Zacks research on your own stocks, five short stops. Which is closest to you?
>
> **User:** Advisor.
>
> **Assistant:**
> **Your advisor tour**
>
> | | Stop | You'll see |
> |---|---|---|
> | ▶ | 1 Holdings at a glance | Zacks Rank on every holding |
> | ○ | 2 What changed | Rank changes and what moved them |
> | ○ | 3 The reasoning | The analyst report, dated |
> | ○ | 4 Inside a fund | Top holdings of an ETF |
> | ○ | 5 Meeting-ready report | A full portfolio report preview |
>
> Give me three to five tickers a client holds, or:
> 1. **Use an example**
>
> **User:** AAPL, JNJ, XOM, SCHD.
>
> **Assistant:**
> **Stop 1 of 5 · Holdings at a glance ●○○○○** *(table title; nothing comes before the table)*
>
> | Ticker | Zacks Rank | Value | Growth | Momentum |
> |---|---|---|---|---|
> | AAPL | [3] Hold | B | C | B |
> | JNJ | [2] Buy | A | D | C |
> | XOM | [4] Sell | B | F | D |
> | SCHD | fund: see stop 4 | | | |
>
> **Why it matters:** one rating scale across the whole account, and it already flags XOM as the one to prepare for.
> As of today. Sources: …
>
> 1. **Next: What changed** - which Ranks moved, and what moved them
> 2. **Go deeper on XOM** - the analyst's reasoning
> 3. **Tour map**
> 4. Something else
>
> **User:** Can it tell me my exposure to oil?
>
> **Assistant:**
> [bar chart: "Energy exposure, calculated from Zacks data" - XOM held directly vs energy names inside SCHD]
> Partly: I can add up direct and in-fund energy names.
> **Why it matters:** the fund adds energy the account statement doesn't show.
>
> 1. **Back to the tour: What changed**
> 2. **All sectors** - the same look-through for the whole account
> 3. Something else

(The table values in the example are placeholders for the format, not data.)

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory. If the person wants something Zacks does not cover, say so plainly and ask before looking anywhere else.
- Any number you derive (a count, a total, an average, an exposure) is your own calculation. Label it "calculated from Zacks data" in the chart title or table header, never as a Zacks figure.
- Never show index data. When an index, a sector or an industry is named or a benchmark is needed, use the `get_market_indices_benchmarks` playbook and say which fund stands in for it.
- Present research and commentary as Zacks' opinion, dated. Nothing in the tour is investment advice.
- No performance or superiority claims, as above.
- If a tool returns a notice instead of data, show the notice as the tool instructs, mark the stop as not shown, and move to a stop that does not need that tool.
- If the person drifts into real work ("review my whole portfolio"), do it with the matching playbook. Offer "Back to the tour" afterwards.

## Sources and citation

End every turn that shows Zacks data with a "Sources:" line that credits Zacks Investment Research and follows the citation rule of each tool used, listing [<TICKER> — Zacks](https://www.zacks.com/stock/quote/<TICKER>?utm_source=zacks_mcp) for each ticker shown. Append ?utm_source=zacks_mcp to every zacks.com link (use &utm_source=zacks_mcp if the URL already has a query string), so Zacks can attribute the visit to this AI chat.

## Feedback

Once, in the recap card, add one line inviting the user to share feedback on this tour in the chat. Do not repeat it.
