---
name: etf-portfolio-construction
description: Build or re-weight an ETF-only portfolio from Zacks data - sleeves for stocks, bonds, sectors, industries, regions and styles (dividend, large cap, small cap) that an advisor or portfolio manager can adjust over time. Use when the user asks to build, design or model an ETF portfolio or asset allocation, or to tilt, shift or rebalance exposure to a sector, industry, geography, size or style using ETFs.
metadata:
  playbook_id: etf_portfolio_construction
  title: "ETF portfolio construction: sleeves, proposed weights and look-through"
  use_when: "User asks to build, design or model an ETF portfolio or asset allocation, or to tilt, shift or rebalance exposure to a sector, industry, geography, size or style using ETFs"
  tools_used: run_custom_screen, get_custom_screen_criteria, get_zacks_metrics, get_etf_holdings, get_industry_commentary
  version: "1.4.0"
  updated: "2026-11-27"
---

# ETF portfolio construction

Build a portfolio made only of ETFs, organised in sleeves, so that every later change ("more semiconductors", "less China", "shift to dividend payers", "shorten the bonds") is a change to one ETF weight. The output is a proposal for the advisor or portfolio manager to decide on. Replacing individual stock holdings is a different workflow (portfolio rebalance); this one works at the ETF and sleeve level.

## Inputs

Ask once, in one message, for whatever is missing. If the user does not answer, use the defaults and say so.

- **Objective and risk profile** in the user's words (income, growth, capital preservation, balanced). Default: balanced.
- **Target asset mix**, if they have one (for example 60/40). The mix is the user's decision. If they have none, offer the illustrative starting mixes below and let them pick.
- **Views and tilts**: sectors, industries, regions, size or style they want more or less of.
- **Constraints**: number of ETFs (default 6 to 12), maximum expense ratio, sponsors to prefer or avoid, taxable account (then offer municipal bond ETFs), active versus passive.

Illustrative starting mixes (examples for discussion, not recommendations):

| Profile | Equity | Fixed income | Real assets and cash |
|---|---|---|---|
| Conservative | 30% | 60% | 10% |
| Balanced | 60% | 35% | 5% |
| Growth | 80% | 15% | 5% |

## Sleeves and default ETFs

Each sleeve has default ETFs that are in Zacks coverage. Use the default unless the user's constraints or a screen (step 2) give a better fit.

| Sleeve | What it controls | Default ETFs |
|---|---|---|
| Core US equity | Broad market exposure | SPY, VTI |
| Size | Large, mid, small cap | OEF (mega cap), IJH (mid), IJR or IWM (small), RSP (equal weight) |
| Style | Growth versus value | VUG (growth), VTV (value) |
| Income and factors | Dividends, quality, low volatility, momentum | SCHD, VYM (high dividend), VIG (dividend growth), QUAL, USMV, MTUM |
| Sector and industry tilts | Overweights and underweights | The sector and industry stand-in ETFs from the ETF stand-ins mapping (playbook `get_market_indices_benchmarks`), for example XLK, XLV, XLF, XLE; SMH, XBI, KRE, ITA |
| International | Developed, emerging, single country | VEA or EFA (developed), VXUS (all ex-US), VWO (emerging), VGK (Europe), EWJ (Japan), MCHI (China), INDA (India) |
| Fixed income | Duration and credit | AGG or BND (core), SHY (short Treasury), IEF (intermediate), TLT (long), TIP (inflation-protected), LQD (investment grade), HYG (high yield), MUB (municipal), EMB (emerging market), BNDX (international) |
| Real assets | Real estate, gold | VNQ, GLD |
| Cash | Liquidity reserve | BIL, SHY |

Rules for the menu:
- The core sleeve carries at least half of its asset class by default; tilts are satellites around it.
- Leveraged, inverse, single-stock and defined-outcome ETFs are never proposed unless the user asks for them by name.
- A tilt the menu does not cover (a country, an industry, a strategy) is found with a screen in step 2, not from memory.

## Steps

1. **Set the frame.** Confirm the asset mix and the tilts. Translate each view into a sleeve: "more technology" is the sector sleeve, "more dividend" is the income sleeve, "less emerging markets" is the international sleeve.
2. **Fill the sleeves.** Take the default ETF for each sleeve in use. Where the user's constraints rule a default out, or a tilt has no default, run one ETF screen for that sleeve with `run_custom_screen` (`universe: "etf"`): filter on Asset Type, Investment Category, Investment Strategy or Region, add Long / Short = L, the user's expense-ratio cap and a size floor on Market Value, and sort by Market Value descending. Keep the largest fund that fits, and one alternate. One screen per sleeve at most.
3. **Profile every selected ETF.** `get_zacks_metrics` for each: expense ratio, assets, dividend yield, beta, YTD change, Zacks ETF Rank and the three peer ETFs it returns. The peers are ready-made alternates: use them before screening again. An ETF with no Zacks ETF Rank is reported as "not ranked", not as neutral.
4. **Look through the equity sleeves.** `get_etf_holdings` (`top_n: 25`) for each equity ETF. From the returned rows calculate: the stocks that appear in more than one ETF, each one's combined portfolio weight (ETF weight x holding weight, summed), and the ten largest look-through names. These are top holdings only, so say "based on each fund's top 25 holdings as of <date_of_holding>" and never present the result as the full portfolio. Bond and commodity funds are listed without look-through.
5. **Set the weights.** Apply the asset mix, then split each asset class across its sleeves: core first, then the tilts the user asked for, each tilt funded from the core of the same asset class unless the user names another source. Weights sum to 100%.
6. **Calculate the portfolio profile**, all labelled as calculations: asset mix; sleeve mix; US versus international share; weighted average expense ratio; weighted average dividend yield; weighted average beta of the equity sleeves; largest single look-through name.
7. **Context for the tilts (optional, only for tilts above 5%).** `get_industry_commentary` for the sector or industry behind the tilt, to show what Zacks says about it, dated.

## Adjusting an existing ETF portfolio

When the user comes back with a change ("cut technology by 5 points", "add small caps", "move 10% from stocks to bonds", "I want exposure to defense"):

1. Identify the sleeve and the ETF that carries that exposure. If the portfolio has no ETF for it, add the stand-in ETF from the menu or the mapping, or screen for one as in step 2.
2. Ask where the weight comes from or goes to if the user did not say; default to the core ETF of the same asset class.
3. Re-run steps 3 to 6 only for what changed and show before and after.
4. Keep an adjustment log in the answer: date, change, funded from, reason in the user's words.

## Output

1. **Summary**: the objective, the asset mix, the number of ETFs and the main tilts, in three sentences.
2. **Allocation table**: sleeve, ETF, what it gives exposure to, proposed weight, expense ratio, yield, assets, Zacks ETF Rank, alternate ETF.
3. **Chart**: sleeve weights as a bar or donut chart if the client can render charts; before and after bars for an adjustment.
4. **Portfolio profile**: the step-6 calculations in one small table.
5. **Look-through**: the ten largest underlying names with combined weight, the overlapping names, and the holdings date of each fund.
6. **Adjustment levers**: a short table, "to change X, move the weight of Y", one row per sleeve in the portfolio (for example: US large-cap growth -> VUG; rate sensitivity -> TLT versus SHY; semiconductors -> SMH).
7. **Open decisions for the advisor**: suitability, taxes and account type, rebalancing bands, trading costs, anything the proposal could not satisfy.

## Guardrails

- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory. An ETF that returns no data is listed as not covered and left out of the calculations.
- Every weight, mix, average and look-through figure is a calculation and is labelled "calculated from Zacks data". Expense ratio, assets, yield, beta, YTD change and ETF Rank are Zacks figures.
- Weights are proposals for discussion. Write "proposed weight" and "candidate ETF", never "buy" or "sell". The asset mix belongs to the user; the illustrative mixes are examples.
- Never show index data. A sector, industry or index is always represented by its stand-in ETF, named as "the closest ETF" unless the mapping marks it exact.
- No performance projections, expected returns or backtests: the tools carry current figures and recent price changes only.
- This is not investment advice.

## Sources and citation

One "Sources:" section for the whole proposal, in the format the tools specify: every ETF shown, with its Zacks quote page, and every commentary piece used.

## Feedback

Close with one line inviting the user to share feedback on this ETF portfolio proposal in the chat.
