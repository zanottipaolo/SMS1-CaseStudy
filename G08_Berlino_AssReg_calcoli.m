% Owners:
% Zanotti Paolo
% De Duro Federico      1073477
% Ciullo Roberto        1074568
% Bouchemal Saif        1074800

load('G08.mat')

% Grafico per concentrazioni
stackedplot(t, {'NO2', 'NOx', 'PM10', 'O3'}, "XVariable","Data")
matrice_di_correlazione_gas = corrcoef(t{:, {'NO2', 'NOx', 'PM10', 'O3'}})

% Grafico per eventi climatici
stackedplot(t, {'Temperatura', 'Umidita_relativa', 'Pioggia_cum'}, "XVariable","Data")
matrice_di_correlazione_clima = corrcoef(t{:, {'Temperatura', 'Umidita_relativa', 'Pioggia_cum'}})

% Grafico per carburanti
stackedplot(t, {'Benzina_vendita_rete_ord', 'Gasolio_motori_rete_ord', 'Gasolio_riscaldamento'}, "XVariable","Data")
matrice_di_correlazione_carburanti = corrcoef(t{:, {'Benzina_vendita_rete_ord', 'Gasolio_motori_rete_ord', 'Gasolio_riscaldamento'}})

% Stats
stackedplot(t, {'NO2', 'Benzina_vendita_rete_ord'}, "XVariable","Data")
scatter(t.Benzina_vendita_rete_ord, t.NO2)
lsline

% Dipendenze con NO2
vn = t.Properties.VariableNames'
fitlm(t(:, [vn(end-8:end); vn(end-9)]))
corrcoef(t{:, vn(end-8:end)})


% GRAFICI PM10 %
y = t.PM10;

% Umidità - PM10
x = t.Umidita_relativa;
scatter(x,y,'filled')
title('Umidità e PM10')
xlabel('Umidità: %')
ylabel('PM10: mug/m^3')
lsline
M = corrcoef(x,y);
indice_di_correlazione = M(1, 2)

% Temperatura - PM10
x = t.Temperatura;
scatter(x,y,'filled')
title('Temperatura e PM10')
xlabel('Temperatura: °')
ylabel('PM10: mug/m^3')
lsline
M = corrcoef(x,y);
indice_di_correlazione = M(1, 2)

% Pioggia - PM10
x = t.Pioggia_cum;
scatter(x,y,'filled')
title('Pioggia e PM10')
xlabel('Pioggia: nm')
ylabel('PM10: mug/m^3')
lsline
M = corrcoef(x,y);
indice_di_correlazione = M(1, 2)

% Ozono
x = t.O3;
scatter(x,y,'filled')
title('O3 e PM10')
xlabel('O3: mug/m^3')
ylabel('PM10: mug/m^3')
lsline
M = corrcoef(x,y);
indice_di_correlazione = M(1, 2)

% Ossidi Azoto
x = t.NOx;
scatter(x,y,'filled')
title('NOx e PM10')
xlabel('NOx: mug/m^3')
ylabel('PM10: mug/m^3')
lsline
M = corrcoef(x,y);
indice_di_correlazione = M(1, 2)

% Biossido di azoto
x = t.NO2
scatter(x,y,'filled')
title('NO2 e PM10')
xlabel('NO2: mug/m^3')
ylabel('PM10: mug/m^3')
lsline
M = corrcoef(x,y);
indice_di_correlazione = M(1, 2)
