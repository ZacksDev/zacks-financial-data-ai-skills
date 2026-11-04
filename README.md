# Zacks Financial Data

The plugin adds Zacks Investment Research workflows to Claude (claude.ai chat, Cowork and Claude Code), on top of the Zacks Financial Data connector:

- **market-extremes**: finds overbought and oversold US stocks with four Zacks screens, then charts and tables them. Uses 40 of the 100 daily screening rows.
- **portfolio-report**: reviews a portfolio or watchlist. It covers return attribution, sector weights, a comparison with SPY and QQQ, and Zacks' view on the five largest holdings.

## How to use it

Install the plugin, open its Connectors tab, connect **Zacks Financial Data** and sign in with your Zacks account. Then ask Claude, for example, "show me this week's market extremes" or "review my portfolio: AAPL 30, MSFT 25, NVDA 20, JPM 15, XOM 10".

## What data it sends

The plugin itself stores nothing. Your requests (tickers, screen criteria and portfolio symbols) go only to the declared Zacks connector at `https://mcp.zacksdata.com/`, which answers with Zacks data. The skills tell Claude to use only Zacks data, to label any number it derives as a calculation, and to cite zacks.com sources. See the [privacy policy](https://zacksdata.com/privacy/).

## License

MIT. See [LICENSE](LICENSE).
