#!/opt/homebrew/bin/python3

#! Download data from Yahoo Finance

# Import libraries
import yfinance as yf
import pandas as pd
import os

# Read tickers from the .txt files

with open('Tickers.txt', 'r') as f:
    symbols = f.read().splitlines()
    symbols = [line.split('\t')[0] for line in symbols]

print(len(symbols), type(symbols), '\n', symbols[:10])

# Download data
data = pd.DataFrame()

for i in range(0, len(symbols), 100):
    symbol_group = symbols[i:i+100]

    try:
        group_data = yf.download(symbol_group, start="2022-01-01", end="2023-01-01", period="1d")["Close"]
        data = pd.concat([data, group_data], axis=1)
    except Exception as e:
        print(f"Error downloading data for symbols {symbol_group}: {e}")

# Clear and export data
data_cleaned = data.drop(data.columns[data.isna().any()].tolist(), axis=1)
data_cleaned = data_cleaned.round(4)

print(type(data_cleaned), data_cleaned.shape)

data_cleaned.to_csv('US_stock_22-23.csv', index=False)
