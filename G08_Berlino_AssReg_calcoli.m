% Owners:
% Zanotti Paolo
% De Duro Federico      1073477
% Ciullo Roberto        1074568
% Bouchemal Saif        1074800

load('G08.mat')

dati_unici = t(:,{'Nome_staz','PM10','Temperatura', 'Pioggia_cum','Umidita_relativa','NOx','NO2', 'O3', 'Benzina_vendita_rete_ord', 'Gasolio_motori_rete_ord', 'Gasolio_riscaldamento'});
dati_unici.Properties.VariableNames = {'Stazione','PM10', 'Temperatura','Pioggia','Umidita', 'NOx', 'NO2', 'O3', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'};

stat = grpstats(dati_unici,'Stazione',{'mean','std','min','max'}, 'DataVars',{'PM10'}) % Statistiche per PM10

% Matrice di correlazione tra le variabili
corr_matrix_t = corr(dati_unici{:,2:end});
matrice_rho_t = array2table(corr_matrix_t, 'VariableNames' ,{'PM10', 'Temperatura','Pioggia','Umidita','O3','NOx','NO2', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'}, ...
                              'RowNames', {'PM10','Temperatura','Pioggia','Umidita','O3','NOx','NO2', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'})


[S,AX,BigAx,H,HAx] = plotmatrix(dati_unici{:,2:end});
title 'Matrice Grafici Per Analisi Correlazione Stazione Unica';
AX(1,1).YLabel.String = 'PM10'; 
AX(2,1).YLabel.String = 'Temperatura'; 
AX(3,1).YLabel.String = 'Pioggia'; 
AX(4,1).YLabel.String = 'Umidità'; 
AX(5,1).YLabel.String = 'O3'; 
AX(6,1).YLabel.String = 'NOx';
AX(7,1).YLabel.String = 'NO2';
AX(8,1).YLabel.String = 'Benzina';
AX(9,1).YLabel.String = 'Gasolio_motori';
AX(10,1).YLabel.String = 'Gasolio_risc';

AX(10,1).XLabel.String = 'PM10'; 
AX(10,2).XLabel.String = 'Temperatura'; 
AX(10,3).XLabel.String = 'Pioggia'; 
AX(10,4).XLabel.String = 'Umidità'; 
AX(10,5).XLabel.String = 'O3'; 
AX(10,6).XLabel.String = 'NOx';
AX(10,7).XLabel.String = 'NO2';
AX(10,8).XLabel.String = 'Benzina';
AX(10,9).XLabel.String = 'Gasolio motori';
AX(10,10).XLabel.String = 'Gasolio risc';

S(1,2).Color = 'r';
S(1,3).Color = 'r';
S(1,4).Color = 'r';
S(1,5).Color = 'r';
S(1,6).Color = 'r';
S(1,7).Color = 'r';
S(1,8).Color = 'r';
S(1,9).Color = 'r';
S(1,10).Color = 'r';

S(6,7).Color = 'r';
S(7,6).Color = 'r';

% Backward per PM10 con alpha = 5%

% lm Completo
lm1 = fitlm(dati_unici,'ResponseVar','PM10', 'PredictorVars',{'Temperatura',...
    'Pioggia','Umidita', 'NOx','NO2', 'O3', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'});

% lm senza Temperatura
lm2 = fitlm(dati_unici,'ResponseVar','PM10', 'PredictorVars', ...
    {'Pioggia','Umidita', 'NOx','NO2', 'O3', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'});

% lm senza Umidità
lm3 = fitlm(dati_unici,'ResponseVar','PM10', 'PredictorVars', ...
    {'Pioggia', 'NOx','NO2', 'O3', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'});

% lm senza Benzina
lm4 = fitlm(dati_unici,'ResponseVar','PM10', 'PredictorVars', ...
    {'Pioggia', 'NOx','NO2', 'O3', 'Gasolio_motori', 'Gasolio_risc'});

% lm senza Gasolio_motori
lm5 = fitlm(dati_unici,'ResponseVar','PM10', 'PredictorVars', ...
    {'Pioggia', 'NOx','NO2', 'O3', 'Gasolio_risc'});

% lm senza NO2
lm6 = fitlm(dati_unici,'ResponseVar','PM10', 'PredictorVars', ...
    {'Pioggia', 'NOx', 'O3', 'Gasolio_risc'})

% Grafico del modello
plot(lm6)
title('fitlm per PM10')

% Stepwise per verifica risultati
stepwise_linear = stepwiselm(dati_unici,'Upper','linear', 'ResponseVar','PM10','PEnter', 0.05)
% Regressori significativi = regressori 5° studio.
% Regressori significativi per PM10 = PM10 + Pioggia + NOx + Gasolio per riscaldamento

% RESIDUI
resm6 = lm6.Residuals.Raw;

nexttile % Grafico 1
plot(resm6)
ylabel('Residuo')
xlabel('Osservazione n°')
yline(mean(resm6), 'Color', 'b', 'LineWidth', 2)
title('Grafico dei residui - PM10')

nexttile % Grafico 2
histfit(resm6)
title('Residui come una normale - PM10')
% I residui si distribuiscono come una normale

qqplot(resm6)
title('Distribuzione Quantili teorici - Quantili residui standardizzati')

% le variabili indipendenti sono correlate con i residui?
[S,AX,BigAx,H,HAx] = plotmatrix(dati_unici{:,{'Pioggia','NOx','O3', 'Gasolio_risc'}}, resm6)
title 'Correlazione Residui-Regressori'
AX(1,1).YLabel.String = 'Residui'
AX(1,1).XLabel.String = 'Pioggia'
AX(1,2).XLabel.String = 'NOx'
AX(1,3).XLabel.String = 'O3'
AX(1,4).XLabel.String = 'Gasolio_risc'

% conferma della assenza di correlazione tra residui e variabili
% indipendenti
mat_corr_residui = corrcoef([resm6, dati_unici.Pioggia,...
    dati_unici.NOx, dati_unici.O3, dati_unici.Gasolio_risc])
matrice_corr_residui = array2table(mat_corr_residui, 'VariableNames' ,...
    {'Residuals','Pioggia','NOx','O3', 'Gasolio_risc'}, ...
    'RowNames',{'Residuals','Pioggia','NOx','O3', 'Gasolio_risc'})