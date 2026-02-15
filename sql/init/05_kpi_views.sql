-- ============================================
-- Script 05: Vues métier pour KPIs
-- ============================================

SET search_path TO dw;

-- Vue: Dashboard Synthèse Mensuelle
CREATE OR REPLACE VIEW v_synthese_mensuelle AS
SELECT 
    t.annee,
    t.mois,
    t.nom_mois,
    s.zone_geo,
    s.ville,
    COUNT(DISTINCT f.releve_key) as nb_releves,
    ROUND(AVG(f.temperature_celsius)::NUMERIC, 2) as temp_moyenne,
    ROUND(MIN(f.temperature_celsius)::NUMERIC, 2) as temp_min,
    ROUND(MAX(f.temperature_celsius)::NUMERIC, 2) as temp_max,
    ROUND(AVG(f.humidite_pct)::NUMERIC, 2) as humidite_moyenne,
    ROUND(AVG(f.vitesse_vent_kmh)::NUMERIC, 2) as vent_moyen,
    SUM(CASE WHEN f.est_anomalie_temp THEN 1 ELSE 0 END) as nb_anomalies
FROM fait_releves_meteo f
JOIN dim_temps t ON f.temps_key = t.temps_key
JOIN dim_station s ON f.station_key = s.station_key
GROUP BY t.annee, t.mois, t.nom_mois, s.zone_geo, s.ville;

-- Vue: Alertes par Sévérité
CREATE OR REPLACE VIEW v_alertes_severite AS
SELECT 
    t.annee,
    t.trimestre,
    t.mois,
    s.zone_geo,
    sv.code_severite,
    sv.libelle as niveau_severite,
    COUNT(*) as nb_alertes,
    SUM(p.quantite_mm) as precipitation_totale_mm
FROM fait_precipitations p
JOIN dim_temps t ON p.temps_key = t.temps_key
JOIN dim_station s ON p.station_key = s.station_key
JOIN dim_severite sv ON p.severite_key = sv.severite_key
GROUP BY t.annee, t.trimestre, t.mois, s.zone_geo, sv.code_severite, sv.libelle;

-- Vue: Analyse Risque Irrigation (Déficit Hydrique)
CREATE OR REPLACE VIEW v_risque_irrigation AS
SELECT 
    t.annee,
    t.mois,
    t.nom_mois,
    s.zone_geo,
    s.ville,
    s.nom_station,
    ROUND(AVG(f.temperature_celsius)::NUMERIC, 2) as temp_moyenne,
    ROUND(AVG(f.humidite_pct)::NUMERIC, 2) as humidite_moyenne,
    COALESCE(ROUND(SUM(p.quantite_mm)::NUMERIC, 2), 0) as precip_totale_mm,
    -- Indice de déficit hydrique simplifié
    CASE 
        WHEN COALESCE(SUM(p.quantite_mm), 0) < 20 AND AVG(f.temperature_celsius) > 30 
            THEN 'CRITIQUE'
        WHEN COALESCE(SUM(p.quantite_mm), 0) < 50 AND AVG(f.temperature_celsius) > 25 
            THEN 'ÉLEVÉ'
        WHEN COALESCE(SUM(p.quantite_mm), 0) < 80 
            THEN 'MODÉRÉ'
        ELSE 'FAIBLE'
    END as niveau_risque_irrigation
FROM fait_releves_meteo f
JOIN dim_temps t ON f.temps_key = t.temps_key
JOIN dim_station s ON f.station_key = s.station_key
LEFT JOIN fait_precipitations p ON p.station_key = s.station_key 
    AND p.temps_key = t.temps_key
GROUP BY t.annee, t.mois, t.nom_mois, s.zone_geo, s.ville, s.nom_station;

\echo 'Vues KPI créées avec succès !'
