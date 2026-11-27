---
name: market-index-etf-standins
description: The ETF that replaces each market index, each Zacks sector and each leading industry. Use whenever an index, a sector or an industry is named or needed with Zacks data - for a benchmark, a market or sector comparison, "how did the market / technology / semiconductors / banks do", "top sectors this month", or a screen that names a sector or an industry.
metadata:
  playbook_id: get_market_indices_benchmarks
  title: "ETF stand-ins: the ETF that replaces each index, sector and industry"
  use_when: "An index, a sector or an industry is named or needed: a benchmark, a market, sector or industry comparison, how the market or a sector did, top sectors, or a screen that names a sector or an industry"
  tools_used: get_zacks_metrics, run_custom_screen
  updated: "2026-11-27"
---

# ETF stand-ins for indices, sectors and industries

Zacks data has no index levels and no sector or industry performance series. Whenever an index, a sector or an industry is named or needed, use its stand-in ETF and say so.

## 1. Index-to-ETF mapping

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

## 2. Sector-to-ETF mapping

Keyed on the Zacks sectors. Every sector ETF is a proxy: the fund follows its own sector definition, so its holdings differ from the Zacks sector. Always write "the closest ETF to the Zacks <sector> sector".

| Zacks sector | Closest ETF | Alternate | Note |
|---|---|---|---|
| Computer and Technology | XLK | VGT | |
| Medical | XLV | | |
| Finance | XLF | | The Zacks sector also holds REITs: add VNQ when real estate matters |
| Oils-Energy | XLE | | |
| Consumer Discretionary | XLY | | |
| Consumer Staples | XLP | | |
| Industrial Products | XLI | | |
| Basic Materials | XLB | | |
| Utilities | XLU | | |
| Retail-Wholesale | XRT | | Equal-weighted fund |
| Transportation | IYT | XTN | |
| Aerospace | ITA | XAR, PPA | |
| Construction | PKB | ITB, XHB | PKB is a small fund; use ITB or XHB when the question is about housing |
| Auto-Tires-Trucks | CARZ | DRIV | Weak proxy: both are small, global funds |
| Business Services | none | | Say that no ETF represents it |
| Conglomerates | none | | Say that no ETF represents it |

Two market sectors users name that are not Zacks sectors: **Communication Services** -> XLC; **Real Estate** -> XLRE (alternate VNQ).

**Sector scoreboard** (for "top sectors", "which sectors led", "sector rotation"): XLK, XLV, XLF, XLE, XLY, XLP, XLI, XLB, XLU, XLC, XLRE.

## 3. Industry-to-ETF mapping

All proxies: "the closest ETF to <industry>". The right-hand column lists the Zacks industry names the ETF comes closest to, for screens and industry commentary.

**Twenty leading industries:**

| Industry | Closest ETF | Alternate | Closest Zacks industries |
|---|---|---|---|
| Semiconductors | SMH | SOXX | Electronics - Semiconductors; Semiconductor - General, Analog and Mixed, Memory; Semiconductor Equipment - Wafer Fabrication |
| Software | IGV | | Computer - Software; Internet - Software |
| Internet | FDN | | Internet - Services, Content, Commerce |
| Cybersecurity | CIBR | HACK | Security |
| Cloud computing | SKYY | | Internet - Software and Services; Computers - IT Services |
| AI and robotics | AIQ | BOTZ | Industrial Automation and Robotics |
| Biotech | XBI | IBB | Medical - Biomedical and Genetics |
| Pharmaceuticals | IHE | XPH | Large Cap Pharmaceuticals; Medical - Drugs; Medical - Generic Drugs |
| Medical devices | IHI | | Medical - Instruments; Medical - Products |
| Healthcare providers | IHF | | Medical - HMOs; Medical - Hospital; Medical Services |
| Banks | KBWB | KBE | Banks - Major Regional; Financial - Investment Bank |
| Regional banks | KRE | | Banks - Midwest, Northeast, Southeast, Southwest, West |
| Insurance | KIE | IAK | Insurance - Property and Casualty, Life Insurance, Multi line, Brokerage |
| Brokers and capital markets | IAI | | Financial - Investment Bank; Securities and Exchanges; Financial - Investment Management |
| REITs | VNQ | XLRE | REIT and Equity Trust (all four) |
| Homebuilders | ITB | XHB | Building Products - Home Builders |
| Aerospace and defense | ITA | XAR, PPA | Aerospace - Defense; Aerospace - Defense Equipment |
| Oil and gas exploration and production | XOP | | Oil and Gas - Exploration and Production - United States |
| Oil services | OIH | XES | Oil and Gas - Field Services; Oil and Gas - Drilling; Oil and Gas - Mechanical and and Equipment |
| Gold miners | GDX | | Mining - Gold |

**Further industries:**

| Industry | Closest ETF | Alternate | Note |
|---|---|---|---|
| Airlines | JETS | | Transportation - Airline |
| Pipelines and MLPs | AMLP | | Energy and Pipeline - Master Limited Partnerships |
| Metals and mining | XME | | Mining - Miscellaneous, Non Ferrous; Steel - Producers |
| Steel | SLX | | Small fund |
| Copper miners | COPX | | |
| Lithium and batteries | LIT | | |
| Clean energy | ICLN | | Alternative Energy - Other |
| Solar | TAN | | Solar |
| Nuclear and uranium | URA | NLR | |
| Infrastructure | PAVE | | Building Products - Heavy Construction; Engineering - R and D Services |
| Water | PHO | | Utility - Water Supply |
| Agribusiness | MOO | | Agriculture - Operations, Products; Fertilizers |
| Telecom | IYZ | | Wireless National; Wireline - National; Diversified Communication Services |
| Leisure and entertainment | PEJ | | Leisure and Recreation Services; Hotels and Motels |
| Food and beverage | PBJ | | Small fund |
| Online retail | IBUY | ONLN | Small funds |
| Fintech | FINX | | Financial Transaction Services |

An industry not in these tables: look for an ETF with a screen (`run_custom_screen`, `universe: "etf"`, on Investment Strategy), take the largest long-only match and call it "the closest ETF". If nothing matches, say that no ETF represents it. Never pick an ETF from memory.

## Steps

1. Map each index, sector or industry the user names (or the default benchmarks) to its ETF with the tables above. A theme (AI, quantum, drones) is a thematic stock list first; use the ETF only for its performance.
2. For one to three ETFs, call `get_zacks_metrics` for each and use the ETF figures.
3. For a comparison across many sectors or industries ("top sectors this month", "which industries led this year"), run one ETF screen with `run_custom_screen` (`universe: "etf"`) with those ETF tickers as the starting universe and the performance columns the question needs (1 week, 1 month, 3 months, 6 months, YTD, 1 year), sorted on the period asked about. Use the sector scoreboard list for sectors. If the call returns fewer rows than the tickers sent, fetch the rest with `offset` before ranking.
4. When a stock screen or an industry question names a sector or an industry, add the stand-in ETF's performance next to the screen results, and use the "Closest Zacks industries" column for the screen's Industry condition and for `get_industry_commentary`.
5. In the answer, name the ETF next to what the user asked about: "S&P 500 (via SPY)" for an exact stand-in; "the closest ETF to semiconductors is SMH" for a proxy, with the note from the table. Where there is no stand-in, say so and do not substitute another ETF.

## Guardrails

- Never show or quote index levels, index returns, or sector or industry returns as such. Every such figure is the ETF's figure, and say so.
- A proxy ETF is never described as the index, the sector or the industry itself. Only the eight exact index stand-ins may be written as "via".
- A ranking of sectors or industries is a ranking of their stand-in ETFs: say "ranked by the performance of each stand-in ETF". The Zacks Industry Rank is a different measure (earnings-estimate based) and is never mixed into it.
- Use the sector and industry names above and the Zacks sector and industry names only; do not reference any other classification standard.
- Use only Zacks MCP tools as the data source. Do not search the web or fill gaps from memory.
- This is not investment advice.

## Sources and citation

Cite each ETF used with its Zacks quote page, in the format the tools specify, and attribute the figures to Zacks.

## Feedback

Close with one line inviting the user to share feedback on the comparison in the chat.
