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


