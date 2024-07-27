clear
clc
close all

% Load Data
historical_data_table   = readtable("Historical_data_top.csv");
market_data_table       = readtable("Market_share_top.csv");

N = size(historical_data_table, 2);
M = size(historical_data_table, 1);

% New index construction
market_cap = zeros(M, 1);
for i = 1:N  
    market_cap = market_cap + market_data_table{i, 2} * historical_data_table{:, i};
end

tot_share = sum(market_data_table.Market_share);
market_cap = market_cap/tot_share;

% Index Plot
index_historical = readtable("Index_historical.csv");

figure(1)
plot(market_cap, 'LineWidth', 2)
title('Network-based Index')

figure(2)
plot(index_historical.DIA, 'LineWidth', 2)      % DowJones
hold on
plot(index_historical.QQQ, 'LineWidth', 2)      % Nasqad
hold on
plot(index_historical.SPY, 'LineWidth', 2)      % S&P500
title("Commond Indexes")
legend('DowJones', 'Nasqad',  'S&P500')

%% Hypothesis testing

% Perform Spearman's rank correlation test (very similar to the normal correlation test)
[corr_dowjones, p_dowjones] = corr(market_cap, index_historical.DIA, 'Type', 'Spearman');
[corr_sp500,    p_sp500]    = corr(market_cap, index_historical.SPY, 'Type', 'Spearman');
[corr_nasdaq,   p_nasdaq]   = corr(market_cap, index_historical.QQQ, 'Type', 'Spearman');

% Set significance level
alpha = 0.001;

% Check if null hypothesis is rejected
reject_dowjones = p_dowjones < alpha;
reject_sp500    = p_sp500 < alpha;
reject_nasdaq   = p_nasdaq < alpha;

% Display results
disp('Spearman''s Correlation with Dow Jones:');
disp(['Correlation Coefficient: ', num2str(corr_dowjones)]);
disp(['p-value: ', num2str(p_dowjones)]);
disp(['Null Hypothesis Rejected: ', num2str(reject_dowjones)]);

disp('Spearman''s Correlation with Standard & Poor''s 500:');
disp(['Correlation Coefficient: ', num2str(corr_sp500)]);
disp(['p-value: ', num2str(p_sp500)]);
disp(['Null Hypothesis Rejected: ', num2str(reject_sp500)]);

disp('Spearman''s Correlation with Nasdaq:');
disp(['Correlation Coefficient: ', num2str(corr_nasdaq)]);
disp(['p-value: ', num2str(p_nasdaq)]);
disp(['Null Hypothesis Rejected: ', num2str(reject_nasdaq)]);

% It looks like the Spearman's rank correlation coefficients between the 
% new degree-based indexes and the existing indexes (Dow Jones, 
% Standard&Poor's 500, and Nasdaq) are quite high, indicating a strong 
% monotonic relationship between the variables. Additionally, the p-values 
% are extremely small, well below the significance level of 0.001, 
% leading to the rejection of the null hypothesis.

% In statistical terms, this suggests that there is a significant and 
% strong correlation between the time series of the new degree-based 
% indexes and the mentioned existing indexes. The rejection of the null 
% hypothesis implies that the correlation observed is unlikely to be due 
% to random chance.

%These results provide evidence that there is a meaningful relationship 
% between the new degree-based indexes and the existing financial indexes 
% you examined.

%% Index composition

name_sectors =  {'Financial Services', 'Technology', 'Real Estate', 'Healthcare', ...
                'Industrials', 'Consumer Cyclical', 'Basic Materials', ...
                'Communication Services', 'Consumer Defensive', 'Utilities'};

val_sectors = [];
for i = 1:numel(name_sectors)
    val_sectors(i) = sum(strcmp(market_data_table.Sector(:), name_sectors{i}));
end


total_companies = numel(market_data_table.Sector);
percentages = (val_sectors / total_companies) * 100;

figure(3)
bar(percentages);
xticks(1:numel(name_sectors));
xticklabels(name_sectors);
xlabel('Sectors');
ylabel('Percentage of Companies');
title('Index composition');


% NASDAQ
perc_nasqad = [5.19, 48.39, 1.21, 10.04, 6.14, 20.35, 0.5, 4.18, 2.5, 1];
perc_nasqad_norm = perc_nasqad / sum(perc_nasqad);

% S&P 500 
perc_sp500 = [12.9, 26.1, 2.5, 14.5, 8.6, 9.9, 2.6, 8.2, 7.4, 2.9];
perc_sp500_norm = perc_sp500 / sum(perc_sp500);

% Your Index
my_perc = [29.2222, 11.7460, 6.9841, 12.3651, 9.5238, 8.5714, 5.3968, 4.7619, 3.8095, 3.4921];
my_perc_norm = my_perc / sum(my_perc);

% Create a bar plot in the order: Your Index, S&P 500, NASDAQ
figure;
bar([my_perc_norm(:), perc_sp500_norm(:), perc_nasqad_norm(:)], 'barWidth', 1);
% Add sector labels
xticks(1:numel(name_sectors));
xticklabels(name_sectors);
xtickangle(45);         % Rotate labels for better visibility

% Add labels and title
xlabel('Sectors');
ylabel('Weight');
title('Comparison of Index Composition');

% Add legend
legend('Network Index', 'S&P 500', 'NASDAQ');

% Display the figure
grid on;
