---
name: weekly-client-newsletter
description: Draft a one-page weekly market note that a financial advisor sends to investor clients, from Zacks data - a stand-in ETF scoreboard for US and international stocks, bonds and metals, what drove the week, Zacks signals (Rank upgrades, dividend raises, insider buying) and next week's earnings calendar, with the advisor's own view. Use when the user asks to write, draft, design, update or schedule a weekly market newsletter, market note, market update or client letter.
metadata:
  playbook_id: weekly_client_newsletter
  title: "Weekly client newsletter: a one-page market note from an advisor to investor clients"
  use_when: "User asks to write, draft, design, update or schedule a weekly or periodic market newsletter, market note, market update or client letter that an advisor sends to investor clients"
  tools_used: get_zacks_playbook, run_custom_screen, get_real_time_news, get_zacks_trending_tickers, get_industry_commentary, compare_stocks, get_dividend_announcements, get_insider_buying
  version: "0.5.0"
  updated: "2026-11-28"
---

# Weekly client newsletter

Draft a short weekly market note that a financial advisor sends to investor clients: what markets did, what drove the move, what Zacks data shows underneath, and what is on next week's calendar. It is a draft in the advisor's name, for the advisor to review, edit and clear before it is sent. One page by default; two pages at most. If a tool named below is not available in the session, or returns nothing, skip that item, keep going, and list what was skipped in the notes to the advisor. Do not stop to ask how to proceed.

## Step 1: settings (ask once)

Ask for these in one message (a choice card if the client has one). Skip anything the advisor already gave. On a scheduled or unattended run, do not ask: use the settings from the request and the defaults.

| Setting | Default |
|---|---|
| Firm name and sign-off | "[Firm name]" placeholder |
| Edition | General market edition. Model-portfolio edition when the advisor gives the tickers of a model portfolio or focus list (up to 30) |
| Our view | Ask: "What is your view this week, in a sentence or two?" With no answer, a marked placeholder: "[Advisor: add your view, 2 to 4 sentences]" |
| Length | One page |
| Format | PDF. Other choices: an editable document, or plain text for an email |
| Branding | None. The advisor may supply a logo and colours |
| Disclosure | "[Firm disclosure]" placeholder |

The list is a model or a focus list, not one client's account. If the advisor pastes account data, use the ticker symbols only.

## Step 2: market scoreboard

1. Call `get_zacks_playbook` with `get_market_indices_benchmarks` and follow its ETF comparison step. Every scoreboard figure comes from `run_custom_screen` with `universe` "etf", the stand-in ETFs as the starting universe, and the columns Performance 1W (%), Performance 1M (%) and Performance YTD (%). `get_zacks_metrics` carries no weekly or monthly ETF performance: do not use it for the scoreboard, and do not conclude from it that the figures are missing. Send at most ten tickers per screen call (United States and International in one call; Bonds, Metals and the two context ETFs in another).
2. Rows, in four groups and in this order. United States: S&P 500 (via SPY), Nasdaq-100 (via QQQ), Dow Industrials (via DIA), Russell 2000 (via IWM). International, in US dollars, each written "closest ETF": Europe VGK, Japan EWJ, China MCHI, emerging markets EEM, Mexico EWW, Brazil EWZ. Bonds, fund price change, each "closest ETF": US bonds AGG, global bonds BNDW, high-yield bonds JNK, emerging-market bonds EMB. Metals, fund price change, each "closest ETF": gold GLD, silver SLV. Show only the rows the screen returns.
3. Best and worst sector of the week: run the ETF screen on the sector scoreboard list twice with the Performance 1W (%) column, once sorted descending and once ascending, `limit` 1 each. Sectors are not scoreboard rows in the one-page edition.
4. Use the columns that came back. Head the first column "1 week to <as-of date>". If the 1-week column is missing, show the others and say so in the footer. Never work out a weekly change from other fields. Drop a row that has no data.
5. Context, in the same call as Bonds and Metals: oil (closest ETF: USO) and the US dollar (closest ETF: UUP). They feed the "Other markets" paragraph in step 3 and are not scoreboard rows.

## Step 3: what drove the move

Gather:

1. Market and economy: `get_real_time_news` once with `subcategory` [144, 126, 73] and no tickers. Keep only pieces published in the last 7 days.
2. Trending tickers: `get_zacks_trending_tickers` once with `mode` "trending" (attention growing fastest over the last 3 days) and `count` 5.
3. Company news: `get_real_time_news` once more with up to five tickers and `subcategory` [218, 284], `record_count` 2. Use the trending tickers, but give a slot to any company the market news names as the week's main mover.
4. Sector view: for the best and the worst sector ETF of the week, call `get_industry_commentary` once each with the closest Zacks industry from the stand-in playbook, and keep one sentence of Zacks' outlook with its date. If nothing comes back, leave it out.

Then write three paragraphs and a balance:

- **Stocks: what drove the move.** Start with the week's catalyst (a company event, a policy move, a data release). Then what changed mid-week. Then company results with their numbers, the reported figure against the Zacks consensus. Then the best and the worst sector. End with the five trending companies and each one's Zacks Rank.
- **Bonds and the economy: what drove the move.** The week's releases with their numbers and dates (growth, inflation, jobs, spending), what Zacks says they mean for interest rates if an article says it, and the direction of the bond rows on the scoreboard.
- **Other markets.** Two or three sentences from the International, Metals and context figures: which markets led and which lagged, gold and silver, oil and the dollar. Give a reason for a move only when a Zacks article from the week states it; otherwise give the figures alone.
- **The week's balance.** Two sentences, one on stocks and one on bonds. Nothing that is not already above.

Zacks market articles quote index points, index levels and futures moves. Do not carry those numbers into the newsletter. Describe the direction in words and let the scoreboard supply the figures. ETF figures quoted in an article may be used, named as the ETF.

## Step 4: Zacks signals

One strip with up to three items, one or two lines each. Order of preference: Rank changes, dividends, insider buying, then movers. Always attempt the dividend and the insider call in both editions. If either tool is not in the session, skip its item and list it in the notes.

**Model-portfolio edition** (the advisor's list is the starting universe):

1. One `run_custom_screen` on the list with Zacks Rank, Zacks Rank Change Indicator, 1-week price change, 4-week change in the current-year estimate and next earnings report date as columns.
2. Rank changes: for names whose change indicator is not zero, call `compare_stocks` and keep those whose Rank `last_change_date` falls in the last 7 days. Write "upgraded to" or "downgraded to" with the previous Rank.
3. Movers: the two best and two worst names by 1-week price change.
4. Dividends: one `get_dividend_announcements` call (`days` 7) with the list. Report a raise or a cut as the new amount against the previous amount.
5. Insider buying: one `get_insider_buying` call (`days` 7, no ticker, all pages) and keep only rows for names on the list. Several insiders buying the same name is worth a line.

**General market edition** (no list):

1. Rank upgrades among large companies: one `run_custom_screen` with market cap of $50B or more, Zacks Rank Change Indicator above zero and Zacks Rank of 2 or better. Ask for the VGM, Momentum and Value Scores, the PEG ratio and the 4-week change in the current-year estimate as columns of that same screen (no separate comparison call), sorted by the 4-week estimate change, descending, ten rows. Report `total_matches` as the count and name three companies. The change indicator compares today's Rank with the Rank four weeks ago: write "over the past four weeks", never "this week".
2. Choosing the three names: give each upgraded company one point for each of these: Zacks Rank 1; VGM Score A or B; Momentum Score A or B; Value Score A or B, or a PEG ratio of 1.5 or less; on the trending list from step 3. Name the three with the most points. Break ties by the larger 4-week estimate change, then by market cap. Do not name two companies from the same sector unless fewer than three sectors are available. Beside each name give its reasons in a few words ("Rank 1, Momentum A, trending").
3. Dividends: one `get_dividend_announcements` call (`days` 7, no tickers, all pages). Keep the companies whose new amount is above the previous amount.
4. Insider buying: one `get_insider_buying` call (`days` 7, no ticker, all pages). Keep the companies, and note where several insiders bought the same one.
5. Size filter: one `run_custom_screen` with the companies kept in 3 and 4 as the starting universe (up to 100) and market cap of $10B or more, sorted by market cap, descending, ten rows. From the companies that pass, report up to two dividend raises (new amount against the previous amount) and up to two insider purchases (who, their title, the value). If none pass for an item, leave that item out.

If nothing changed, say so in one line ("No Zacks Rank changes in the model this week") rather than filling the strip.

## Step 5: next week, day by day

A table with one row per trading day and two columns.

1. Economic data: the releases the Zacks articles from step 3 named, on the day the article gives. Add a consensus or a previous figure only when the article states it.
2. Company earnings: one `run_custom_screen` with the item Next EPS Report Date (yyyymmdd) used twice as a range (next Monday to next Friday), and Q1 Consensus Est. and Earnings ESP as columns, sorted by market cap, descending. General edition: add market cap of $10B or more and COM/ADR/Canadian not equal to ADR, ten rows. Model-portfolio edition: the list is the starting universe. Show up to four names a day, largest first. For the largest one or two of the week, add the Zacks consensus EPS and whether the Earnings ESP is positive or negative.
3. The data carries the report date only. Do not say "before the open" or "after the close".
4. Leave out a cell, or a day, that has nothing.

## Step 6: write the page

Deliver the format chosen in step 1. For a PDF, build one portrait page (two for the two-page edition), with the firm's logo and colours if the advisor supplied them, and check that nothing spills onto an extra page. If the client cannot create files, write an editable document or put the newsletter in the chat, and say so in the notes. Layout: masthead across the top; the scoreboard on one side with the two "what drove the move" paragraphs beside it; then, across the page, the other-markets paragraph, the week's balance, the Zacks signals strip and the next-week table; the footer last. In a chat or a single-column document, keep the same order.

| Block | Limit |
|---|---|
| Masthead: firm, "Weekly market note", week covered, data as-of date | 2 lines |
| Market scoreboard, gains and losses marked by colour if the client can | 16 rows |
| Stocks: what drove the move | 110 words |
| Bonds and the economy: what drove the move | 80 words |
| Other markets | 50 words |
| The week's balance | 40 words |
| Zacks signals | 3 items, 70 words |
| What to expect next week | 5 rows |
| Our view: the advisor's view in 2 to 4 sentences, or the placeholder | 60 words |
| Footer: data as-of date, one line on what the Zacks Rank is, the disclosure | 3 lines |

The two-page edition adds two tables and no prose: the eleven sector ETFs, and a model table (ticker, company, Zacks Rank, 1-week change, next earnings date).

Writing rules:

- Write for investors, not analysts: plain words, short sentences, every term explained the first time or left out.
- Each fact appears once. The balance sums up; it does not repeat figures.
- No empty cells, no dashes for missing values, no placeholder rows.
- Percentages with a sign and one decimal. One as-of date for the whole scoreboard, stated once.
- If the page runs long, cut in this order: the industry-outlook sentence, the other-markets paragraph, the third signal.

Below the newsletter, outside it, give the advisor four things: a request to confirm or correct the wording of "Our view" (or to supply the view, if the placeholder is showing); a reminder that this is a draft to review and clear with the firm before sending; the full source list; and one offer to adjust (another edition, another length, a recurring weekly run).

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- Never show index levels, index points, index returns or futures moves, including those quoted inside Zacks articles. Every market figure is a stand-in ETF's figure, named as the stand-in playbook sets out: "S&P 500 (via SPY)" for an exact stand-in, "the closest ETF to ..." for a proxy.
- A bond ETF row is the fund's price change, never a yield. A gold or silver ETF row is the fund's price change, never the metal's price per ounce. US-listed international ETFs are priced in US dollars: never call their figures local-currency returns.
- A Treasury yield, a rate-decision probability or a consensus figure for an economic release appears only when a Zacks article from the last 7 days states it. Never supply one from memory.
- State the as-of date the screen returned. The 1-week column is the screen's rolling week to that date: do not label it with calendar dates the data does not carry. The newsletter only ever shows what the tools returned in this run; anything a tool does not support is left out, never estimated.
- A volatility index and a dollar index are index data: never show their levels. Oil and the dollar appear only as the price change of their ETFs, named as the closest ETF, never as a price per barrel or an index level.
- "Our view" is the advisor's. Never invent a house view, an allocation stance, a forecast or a recommendation to clients. Write up only what the advisor said, no stronger than they said it, and ask them to confirm the wording. Without input, show the placeholder. "The week's balance" is a summary of what happened, never an outlook.
- The newsletter gives no buy, sell or hold advice and promises no return. A Zacks Rank is described as Zacks' rating based on earnings-estimate revisions, attributed to Zacks.
- Zacks opinion is attributed and dated. The Zacks Rank is recomputed daily and an article is a view as of its publish date: never merge the two.
- Any change, count, ranking or percentage you derive (a dividend raise in percent, the number of upgrades, best and worst) is labelled as a calculation, beside the figure or in the footer.
- No personal client data in the newsletter or in any tool call.
- Trending tickers show reader attention on zacks.com, not a rating or a recommendation. Say so in the same sentence and keep the Zacks Rank as a separate fact. Trending never puts a name into the Zacks signals strip: it only helps choose among companies the upgrade screen already returned.
- The points used to choose which upgraded companies to name are a selection aid. Never show the points; show the reasons (Rank, scores, valuation, trending) in words.
- Earnings rows carry the report date only: no time of day, and no forecast of the result beyond the Zacks consensus and the sign of the Earnings ESP.
- Keep the work bounded: four ETF screen calls, at most three stock screens, two news calls, one trending call, two industry commentary calls, one dividend call, one insider call, and compare_stocks only for names whose Rank changed.
- This is not investment advice.

## Sources and citation

The newsletter goes out in the advisor's name: it carries no Zacks source line, no article titles and no zacks.com links. Zacks is named only where the item is Zacks' own (the Zacks Rank, a Zacks industry outlook, attention on zacks.com). Below the newsletter, for the advisor only: one "Sources:" section in the format the tools specify, with every ETF and stock shown, every screen used and every article used with its publish date.

## Feedback

Close, below the newsletter, with one line inviting the advisor to share feedback on the newsletter in the chat.
