% Owners:
% Zanotti Paolo         1074166
% De Duro Federico      1073477
% Ciullo Roberto        1074568
% Bouchemal Saif        1074800

load('G08.mat')

%% Ispezione del dataset
summary(t)

%% Statistiche descrittive per PM10
% (comprensione/descrizione dei fenomeni)
media = mean(t.PM10)
std = std(t.PM10)
maxPM10 = max(t.PM10)
minPM10 = min(t.PM10)

mediaPM102016 = mean(t.PM10(1:12))
mediaPM102017 = mean(t.PM10(13:24))
mediaPM102018 = mean(t.PM10(25:36))
mediaPM102019 = mean(t.PM10(37:48))
mediaPM102020 = mean(t.PM10(49:60))
mediaParzialePM102021 = mean(t.PM10(61:66))

grpstats(t,'ARPA_ID_staz',{'mean','std','min','max'},'DataVars',{'PM10'})

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

% lm senza O3
lm_overfitting = fitlm(dati_unici,'ResponseVar','PM10', 'PredictorVars', ...
    {'Pioggia', 'NOx', 'Gasolio_risc'})

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
yline(0,'r','LineWidth',3)
yline(mean(resm6), 'Color', 'b', 'LineWidth', 2)
title('Grafico dei residui - PM10')

nexttile % Grafico 2
histfit(resm6)
title('Residui come una normale - PM10')
% I residui si distribuiscono come una normale

qqplot(resm6)
title('Distribuzione Quantili teorici - Quantili residui standardizzati')

% Varianza dei residui
plotResiduals(lm6, 'fitted', 'Marker','o')

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

% Outliers
residui_studentizzati = lm6.Residuals.Studentized
residui_studentizzati(22)
t.PM10(22) % Valore dell'outliers
scatter(lm6.Fitted, residui_studentizzati)
yline(2, '--b')
yline(-2, '--b')

stackedplot(t, {"PM10"}, 'XVariable', 'Data')


%% Ossidi di Azoto (NOx)

% Statistiche per la comprensione del fenomeno
std_NOx = std(t.NOx)
massimo_NOx = max(t.NOx)
minimo_NOx = min(t.NOx)
media_NOx = mean(t.NOx)
media_NOx_2016 = mean(t.NOx(1:12))
media_NOx_2017 = mean(t.NOx(13:24))
media_NOx_2018 = mean(t.NOx(25:36))
media_NOx_2019 = mean(t.NOx(37:48))
media_NOx_2020 = mean(t.NOx(49:60))
media_NOx_2021 = mean(t.NOx(61:66))

% Statistiche complete per NOx
dati_unici_NOx = t(:,{'Nome_staz','NOx','Temperatura', 'Pioggia_cum','Umidita_relativa','PM10','NO2', 'O3', 'Benzina_vendita_rete_ord', 'Gasolio_motori_rete_ord', 'Gasolio_riscaldamento'})
dati_unici_NOx.Properties.VariableNames = {'Stazione','NOx', 'Temperatura','Pioggia','Umidita', 'PM10', 'NO2', 'O3', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'};

statistiche_NOx = grpstats(dati_unici_NOx,'Stazione',{'mean','std','min','max'}, 'DataVars',{'NOx'});

% Matrice di correlazione per l'inquinante NOx
matrice_correlazione_t = corr(dati_unici_NOx{:,2:end});
matrice_rho_t_NOx = array2table(matrice_correlazione_t, 'VariableNames' ,{'NOx', 'Temperatura','Pioggia','Umidita','O3','PM10','NO2', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'}, ...
                              'RowNames', {'NOx','Temperatura','Pioggia','Umidita','O3','PM10','NO2', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'})


% Grafici di correlazione

% Temperatura - NOx
x = t.NOx;
y = t.Temperatura;
sx = 50;
scatter(x,y,sx,"green")
title('Temperatura e NOx')
xlabel('NOx (μg/m3)')
ylabel('Temperatura (°C)')
lsline

% O3 - NOx
x = t.NOx;
y = t.O3;
sx = 50;
scatter(x,y,sx,"green")
title('O3 e NOx')
xlabel('NOx (μg/m3)')
ylabel('O3 (μg/m3)')
lsline

% PM10 - NOx
x = t.NOx;
y = t.PM10;
sx = 50;
scatter(x,y,sx,"green")
title('PM10 e NOx')
xlabel('NOx (μg/m3)')
ylabel('PM10 (μg/m3)')
lsline

% NO2 - NOx
x = t.NOx;
y = t.NO2;
sx = 50;
scatter(x,y,sx,"green")
title('NO2 e NOx')
xlabel('NOx (μg/m3)')
ylabel('NO2 (μg/m3)')
lsline


% Stepwise Backward Elimination per gli Ossidi di Azoto con alpha = 5%

% Linear Model Completo
lm_completo_NOx = fitlm(dati_unici_NOx,'ResponseVar','NOx', 'PredictorVars',{'Temperatura',...
    'Pioggia','Umidita', 'PM10','NO2', 'O3', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'});

% Linear Model senza la Temperatura
lm_1_NOx = fitlm(dati_unici_NOx,'ResponseVar','NOx', 'PredictorVars',{...
    'Pioggia','Umidita', 'PM10','NO2', 'O3', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'});

% Linear Model senza la Pioggia
lm_2_NOx = fitlm(dati_unici_NOx,'ResponseVar','NOx', 'PredictorVars',{'Umidita', ...
    'PM10','NO2', 'O3', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'});

% Linear Model senza O3
lm_3_NOx = fitlm(dati_unici_NOx,'ResponseVar','NOx', 'PredictorVars',{'Umidita', ...
    'PM10','NO2', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'});

% Linear Model senza Gasolio Riscaldamento
% (Modello utilizzato)
lm_4_NOx = fitlm(dati_unici_NOx,'ResponseVar','NOx', 'PredictorVars',{'Umidita', ...
    'PM10','NO2', 'Benzina', 'Gasolio_motori'});


% Verifica del modello

% Primo metodo
check1_model_NOx= stepwiselm(dati_unici_NOx,'Upper','linear', 'ResponseVar','NOx','PEnter', 0.05);

% Secondo metodo
check2_model_NOx = [t.Pioggia_cum, t.Umidita_relativa, t.Temperatura, t.O3, t.PM10, t.NO2]
stepwisefit(check2_model_NOx,t.NOx);


% Analisi dei residui

residui_NOx = lm_4_NOx.Residuals.Raw;

% 1, Grafico dei residui (media uguale a 0)
nexttile
plot(residui_NOx)
ylabel('Residui')
xlabel('Osservazioni')
yline(0,'r','LineWidth',3)
yline(mean(residui_NOx), 'Color', 'b', 'LineWidth', 2)
title('Grafico dei residui - NOx')

% 2. Distribuzione (Normale)
nexttile
histfit(residui_NOx)
title('Residui come una normale - NOx')

% 3. Andamento dei Percentili
qqplot(residui_NOx)
title('Distribuzione Quantili teorici - Quantili residui standardizzati')

% 4. Incorrelazione dei regressori con i residui
[S,AX,BigAx,H,HAx] = plotmatrix(dati_unici_NOx{:,{'Umidita','PM10','NO2', 'Benzina', 'Gasolio_motori'}}, residui_NOx)
title 'Correlazione Residui-Regressori'
AX(1,1).YLabel.String = 'Residui'
AX(1,1).XLabel.String = 'Umidità'
AX(1,2).XLabel.String = 'PM10'
AX(1,3).XLabel.String = 'NO2'
AX(1,4).XLabel.String = 'Benzina'
AX(1,5).XLabel.String = 'Gasolio Motori'

% Verifica incorrelazione tra residui e variabili indipendenti
correlazione_residui_NOx_temp = corrcoef([residui_NOx, dati_unici_NOx.Umidita,...
    dati_unici_NOx.PM10, dati_unici_NOx.NO2, dati_unici_NOx.Benzina, dati_unici_NOx.Gasolio_motori])

correlazione_residui_NOx = array2table(correlazione_residui_NOx_temp, 'VariableNames' ,...
    {'Residuals','Umidita','PM10','NO2', 'Benzina', 'Gasolio_motori'}, ...
    'RowNames',{'Residuals','Umidita','PM10', 'NO2','Benzina', 'Gasolio_motori'})

% 5. Varianza omogenea dei residui
plotResiduals(lm_4_NOx, 'fitted', 'Marker','x')

% 6. Ricerca degli Outliers
