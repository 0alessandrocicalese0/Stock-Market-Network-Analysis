# Stock Market Network Analysis

### Stock market connections

This project utilizes network theory to analyze complex interactions within the stock market. The *MATLAB* script **Network.m** is central to this analysis. It employs advanced graph theory techniques to construct and analyze a network graph of the stock market. This includes calculating node centrality to identify the most influential stocks, and community detection algorithms to uncover clusters of stocks that move similarly. 
The *Python* script **Get_data.py** supports this analysis by extracting up-to-date ticker and stock data from various financial databases, ensuring that the input data is comprehensive and current. Together, these tools allow for a detailed exploration of market dynamics, offering insights that can inform better investment strategies and market predictions.

### Top-stock Index

Additionally, this project focuses on how top stocks interact and influence each other, using specific stock indices and tickers for detailed insights. The main tool here is a MATLAB file, degree.m, which calculates the connectivity levels of these stocks, identifying key players and their links. A significant outcome of this analysis was the creation of a composite index combining the most connected top stocks identified in Network.m and degree.m. This new index was compared with traditional market indices such as the NASDAQ and S&P 500, revealing strong correlations. 
A Python file helps gather the necessary stock data and tickers, supporting the analysis.
