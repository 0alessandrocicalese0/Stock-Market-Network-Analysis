clear
clc
close all

%% Leggo i dati
table = readtable("US_stock_22-23.csv");
N = size(table, 2);
matrice = table2array(table(2:end, :));

%% Lavoro col grafo

% Calcolo le correlazioni
corr = corrcoef(matrice);

ro = 0.95;                           % Threshold
A = zeros(N);                        % Prealloco A

% Creo la matrice di incidenza
for j = 1:N 
    for i = 1:j-1         
        if( abs(corr(i,j)) >= ro )
            A(i,j) = 1;              
        end
    end 
end
clear i j table

A = A + A';

% Plotto il grafo
grafo = graph(A);

figure (1)
h = plot(grafo);

%% Studio la Degree distribution

% Calcolo la distribuzione
D = degree(grafo);

p = zeros(N,1);
for k = 1:N
    p(k) = sum(D == k);
end
p = p/N;

% Plotto la distribuzione
figure (2)
loglog(0:N-1, p, '*')
xlabel('Degree (k)')
ylabel('Probability (p_k)')
title('Degree distribution')

%% Miglioro la rete

nodiDaplottare = D > (mean(D) + std(D));
new_graph = graph(A(nodiDaplottare, nodiDaplottare));

% Identifica le sottoreti più dense
sottoreti = conncomp(new_graph, 'Type', 'weak');
num_nodi  = numnodes(new_graph);

% Imposta una soglia per la dimensione della sottorete da evidenziare
soglia_dimensione = 1000;

% Evidenzia le sottoreti sopra la soglia
figure;
h = plot(new_graph);

for i = 1:max(sottoreti)
    disp(['Sottorete ', num2str(i), ', Numero di nodi: ', num2str(sum(sottoreti == i))]);
    if sum(sottoreti == i) > soglia_dimensione
        nodi_sottorete = find(sottoreti == i);
        highlight(h, nodi_sottorete, 'NodeColor', 'r', 'MarkerSize', 5);
    end
end

title('Stock Network');
legend('Most Connected Nodes');


%% Stimo la power-law distribution

% Pulisco i dati
x = 30;
g = log10(p(4:x));

% Regressione Lineare 
PHI = [log10(4:x)' ones(x-3,1)];
theta_ls = PHI\g;
y_hat = PHI*theta_ls;

figure(3)
plot(log10(4:x), y_hat, '--', 'LineWidth', 2, 'Color', 'r')
hold on
plot(log10(4:x), g, '*', 'Color', 'b')

PHI_pred = [log10(1:N)' ones(N,1)];
y_hat_pred = PHI_2*theta_ls;

% Plotto 
figure(4)
    plot(log10(1:N), y_hat_pred, 'LineWidth', 3, 'Color', 'r')
    hold on
    plot(log10(1:N), log10(p), '*', 'Color', 'b')
    legend('Regression Line', 'Degree Distribution')
    xlabel('Degree (k)')
    ylabel('Probability (p_k)')
    title(sprintf('Scale-Free Network (Gamma = %0.2f)', -theta_ls(1)));

% Calcolo della Somma dei Quadrati degli Errori (SSE)
sse = sum((10.^(y_hat_2) - p).^2);
fprintf('La somma dei quadrati degli errori (SSE) è: %d\n', sse);

% Calcolo dell'Errore Medio Assoluto (MAE)
mae = mean(abs(10.^(y_hat_2) - p));
fprintf('L''errore medio assoluto (MAE) è: %d\n', mae);

%% Top stocks
% Ottengo gli indici del top 10%
[D_sorted, indici] = sort(D, 'descend');
top_percentage = 0.1;
top_indices = indici(1:round(top_percentage * N));
top_indices_sorted = sort(top_indices);

% Esporto gli indici
top_indices_filename = '../Index/Indici_top.txt';
dlmwrite(top_indices_filename, top_indices_sorted);
