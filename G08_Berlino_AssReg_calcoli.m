% Owners:
% Zanotti Paolo
% De Duro Federico      1073477
% Ciullo Roberto        1074568
% Bouchemal Saif        1074800

load('G08.mat')

dati_unici = t(:,{'Nome_staz','PM10','Temperatura', 'Pioggia_cum','Umidita_relativa','O3','NOx','NO2', 'Benzina_vendita_rete_ord', 'Gasolio_motori_rete_ord', 'Gasolio_riscaldamento'});
dati_unici.Properties.VariableNames = {'Stazione','PM10', 'Temperatura','Pioggia','Umidita','O3','NOx','NO2', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'};

stat = grpstats(dati_unici,'Stazione',{'mean','std','min','max'}, 'DataVars',{'PM10'}) % Statistiche per PM10

% Matrice di correlazione tra le variabili
corr_matrix_t = corr(dati_unici{:,2:end});
matrice_rho_t = array2table(corr_matrix_tG1, 'VariableNames' ,{'PM10', 'Temperatura','Pioggia','Umidita','O3','NOx','NO2', 'Benzina', 'Gasolio_motori', 'Gasolio_risc'}, ...
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