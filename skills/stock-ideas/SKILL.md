---
name: stock-ideas
description: Find interesting stock picks from Zacks data, organised by strategy - hidden gems, quality the ratings have not caught up with, fresh upgrades, momentum leaders, blue-chip income, contrarian rebounds, Zacks-versus-Street disagreements, theme and industry leaders, and names Zacks analysts single out in articles. Use when the user asks for stock ideas, stock picks, interesting stocks, opportunities, gems, "what should I look at", or the best stocks in an industry or theme.
metadata:
  playbook_id: stock_ideas
  title: "Stock ideas: screens, contradicting signals and Zacks commentary by strategy"
  use_when: "User asks for stock ideas, stock picks, interesting stocks, opportunities or gems, or the best stocks in an industry or theme"
  tools_used: list_zacks_predefined_screens, run_zacks_screen, run_custom_screen, get_custom_screen_criteria, get_industry_commentary, get_zacks_commentary, compare_stocks
  version: "1.4.0"
  updated: "2026-11-27"
---

# Stock ideas

Surface a short list of stocks worth a closer look, each with the reason it surfaced, the signal that agrees or disagrees with it, and what Zacks has written about it. Ideas come from three sources used together: Zacks predefined and thematic screens, custom screens that look for signals pulling in different directions, and Zacks commentary (industry outlooks, featured "best stocks" articles, analyst pieces). The output is a research shortlist, not a recommendation.

## Step 1: let the user pick a strategy

Show the menu below as a short numbered list (name and one line each) and ask which one or two they want. Use a choice card if the client has one. Ask at the same time for any focus: sector, industry, theme, size range, or income need. If the user says "surprise me" or does not choose, run strategies 1, 2 and 3. If the user already named a strategy or described one in their own words, skip the menu and match it.

| # | Strategy | The idea | Starting screens (Zacks predefined) | Signal mix for the custom screen |
|---|---|---|---|---|
| 1 | Hidden gems | Small, thinly followed companies with strong numbers | Underfollowed Gems (32553), Small-Cap #1's (32542), Small-Caps with Big Growth (32543) | Market cap <= $2B; 2 to 6 brokers covering; ROE >= 15%; this year's estimated EPS growth >= 15%; Zacks Rank <= 2 |
| 2 | Unrecognised quality | Cheap and profitable, but the Rank and the price have not moved yet | Discount Fundamental Strength (32577), Return on Equity (32579) | Value Score A or B; ROE >= 15%; net margin >= 10%; PEG <= 1.5; Zacks Rank = 3; F1 estimate change over 4 weeks >= 0; 12-week price change <= 5% |
| 3 | Fresh upgrades | The Rank just improved: estimates are moving before the crowd | Zacks Rank Upgrades (32552), Upgrades & Revisions (32330), Upgraded Broker Ratings and Zacks #1 Rank (32574) | Zacks Rank Change Indicator > 0; Zacks Rank <= 2; F1 estimate change over 4 weeks >= 2% |
| 4 | Momentum leaders | Price and estimates rising together | Zacks #1 Rank Uptrends (32563), Price & Earnings Estimate Momentum (32566), Zacks #1 Rank New Highs (32564) | Momentum Score A or B; price in the top 20% of its 52-week range; 12-week price change >= 10%; Zacks Rank <= 2 |
| 5 | Blue-chip income | Large, established dividend payers with a decent Rank | Top Zacks Rank Dividend-Payers (32555), Dividends with Style (32641); themes Top Dividend Yield Companies (409), Shareholder Yield (364) | Market cap >= $25B; dividend yield >= 3%; 5-year dividend growth >= 5%; debt/equity <= 1; Zacks Rank <= 3 |
| 6 | Contrarian rebound | Washed-out price, improving estimates | Oversold Zacks Buys (32554) | Price in the bottom 20% of its 52-week range; F1 and Q1 estimate change over 4 weeks >= 0; Zacks Rank <= 2; market cap >= $1B |
| 7 | Zacks versus the Street | Zacks and the brokers disagree | Price Target Upside & Top Zacks Rank (207866) | Two screens. Zacks ahead: Zacks Rank <= 2 with average broker recommendation >= 3 (Hold or worse). Caution list: Zacks Rank >= 4 with 80% or more of brokers at Buy or Strong Buy |
| 8 | Growth at a fair price | Large companies growing fast without a stretched multiple | Top Ranked Large-Caps (32544), XL Large-Caps with the Best Zacks Rank (32530), Growth & Value Stocks Plus Zacks #1 Rank (32328); theme Wide Moat (348) | Market cap >= $10B; this year's estimated EPS growth >= 15%; PEG <= 1.5; Growth Score A or B; Zacks Rank <= 2 |
| 9 | Theme and industry leaders | The best-ranked names inside a theme or a favoured industry | The matching thematic list (AI, Quantum Computing, Cybersecurity, Space Technology, Nuclear Energy, Robotics and others) | The theme as the starting universe plus Zacks Rank <= 2; or, for an industry: that Industry plus Zacks Rank <= 2, with the industry in the top half of the Zacks Industry Rank |
| 10 | Zacks analyst picks | Names Zacks analysts single out in their articles | None: this strategy starts from commentary (step 3) | Check each named stock's current Zacks Rank and scores afterwards |

The thresholds are starting points. If a screen returns more than about 40 matches, tighten one condition (Rank = 1, a higher market-cap floor) rather than paging; if it returns none, relax the least important condition once and say which one.

## Step 2: screen

For each chosen strategy:

1. Run the first starting screen with `run_zacks_screen`. Keep its description and any related article it returns: the article is Zacks' own explanation of the screen and part of the story.
2. Run the custom signal mix with `run_custom_screen`. When the user gave a focus, apply it here: a theme as the starting universe (find it with `list_zacks_predefined_screens`), a sector or industry as a condition, a size range as market-cap conditions. Ask for the columns that tell the story of that strategy (for example Value Score, ROE and 12-week price change for strategy 2) so the table needs no extra calls.
3. Merge the two lists. A stock on both is marked "on both the Zacks screen and the signal screen" and goes to the top.
4. Keep 5 names per strategy, at most 10 in total. Prefer variety of industry over ten names from one industry, unless the user asked for one industry.

For strategy 9, when the user names a theme, always look for a matching thematic list first. For an industry, use the Industry condition.

## Step 3: add what Zacks has written

Commentary is a source of ideas as well as support for them.

1. **Industry view.** For the one to three industries that hold most of the shortlist (or the industry the user named), call `get_industry_commentary` with the industry name. From the Industry News section take Zacks' outlook and the stocks it names; from the Featured section take the "best stocks" style articles and the stocks they single out. Stocks named there that are not on the shortlist are added as "named by Zacks" candidates with the article date, and their current Zacks Rank is checked in step 4 before they are shown.
2. **Strategy 10** is built entirely this way: ask which industries or themes the user cares about (or take the industries of their holdings if known), pull the industry commentary for each, and list the stocks Zacks singles out, with what was said and when.
3. **Company view.** For the two or three leading ideas only, call `get_zacks_commentary` (`rec_count: 2`) and keep pieces whose subject is that company.

## Step 4: check the tension

An idea is interesting when signals pull in different directions, so name the tension for each stock. Run `compare_stocks` on the shortlist (5 tickers per call) and note where the picture is mixed:

- Strong Zacks Rank but a weak Value Score, or the reverse.
- Estimates rising while the price is flat or falling, or the reverse.
- Zacks Rank 1 or 2 with a cautious Street, or a popular stock with Zacks Rank 4 or 5.
- A top-ranked stock in a bottom-ranked industry, or the reverse.
- An article that named the stock, written before its Rank changed.

If nothing pulls the other way, say so in one line: "the signals agree".

## Output

1. **Summary**: the strategies run, how many stocks matched each screen in total and how many are shown, with the as-of date.
2. **One section per strategy**, with:
   - A table: ticker, company, industry, market cap, Zacks Rank, the three or four columns that define the strategy, and the source (Zacks screen, signal screen, both, or named by Zacks).
   - For each stock, two lines: **why it surfaced** (the conditions it met, in words) and **what pulls the other way** (from step 4).
3. **Chart**: if the client can render charts, one scatter per strategy on the two measures that define it (for example Value Score rank against 12-week price change for strategy 2; market cap against estimated growth for strategy 1), labelled with tickers.
4. **What Zacks says**: for each industry used, Zacks' outlook in one or two sentences with the article date; for the leading ideas, the analyst view with its date. Opinion is attributed and dated, and pieces from different dates are never merged.
5. **Where to go next**: offer one follow-up per idea type: a deeper look at one stock, the same strategy in another industry or size range, or another strategy from the menu.

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- These are ideas for further research. Write "idea", "candidate" or "worth a closer look", never "buy", "sell" or "will go up". "Hidden gem" and "opportunity" describe why a stock passed a screen, not an expected return.
- Short interest is not available in the Zacks screens or metrics. If the user asks for it, say so and offer the nearest Zacks signals: broker-rating changes, estimate revisions and the caution list in strategy 7.
- Any count, average, rank order or combined measure you derive is labelled "calculated from Zacks data". Zacks Rank, Style Scores, estimates, broker figures and screen results are Zacks figures.
- The Zacks Rank is recomputed daily and an article is a view as of its publish date. Show the current Rank first, then the article with its date, and say when the Rank has changed since the article.
- Trending or popular tickers are not a source of ideas here.
- Never show index data; any market comparison uses the stand-in ETF (S&P 500 is SPY).
- Keep the work bounded: at most two screens per strategy, commentary for at most three industries and three companies, and no paging unless the user asks to see more.
- This is not investment advice.

## Sources and citation

One "Sources:" section, in the format the tools specify: every stock shown with its Zacks page, every screen used by name with its zacks.com link, and every article used with its publish date.

## Feedback

Close with one line inviting the user to share feedback on these stock ideas in the chat.
