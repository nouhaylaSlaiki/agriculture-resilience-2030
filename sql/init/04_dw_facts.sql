-- ============================================
-- Script 04: Tables de Faits
-- ============================================

SET search_path TO dw;

-- Table de faits: Relevés Météorologiques
DROP TABLE IF EXISTS fait_releves_meteo CASCADE;
CREATE TABLE fait_releves_meteo (
    releve_key BIGSERIAL PRIMARY KEY,
    temps_key INT NOT NULL REFERENCES dim_temps(temps_key),
    station_key INT NOT NULL REFERENCES dim_station(station_key),
    
    -- Mesures
    temperature_celsius DECIMAL(5,2),
    humidite_pct DECIMAL(5,2),
    vitesse_vent_kmh DECIMAL(5,2),
    
    -- Indicateurs calculés
    indice_chaleur DECIMAL(5,2),
    point_rosee DECIMAL(5,2),
    est_anomalie_temp BOOLEAN DEFAULT FALSE,
    
    -- Métadonnées
    timestamp_original TIMESTAMP,
    date_chargement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_fait_releves_temps ON fait_releves_meteo(temps_key);
CREATE INDEX idx_fait_releves_station ON fait_releves_meteo(station_key);
CREATE INDEX idx_fait_releves_date ON fait_releves_meteo(timestamp_original);

-- Table de faits: Précipitations et Alertes
DROP TABLE IF EXISTS fait_precipitations CASCADE;
CREATE TABLE fait_precipitations (
    precip_key BIGSERIAL PRIMARY KEY,
    temps_key INT NOT NULL REFERENCES dim_temps(temps_key),
    station_key INT NOT NULL REFERENCES dim_station(station_key),
    type_precip_key INT REFERENCES dim_type_precip(type_precip_key),
    severite_key INT REFERENCES dim_severite(severite_key),
    
    -- Mesures
    quantite_mm DECIMAL(8,2),
    duree_heures DECIMAL(5,2),
    
    -- Alertes
    message_alerte TEXT,
    
    -- Métadonnées
    date_evenement DATE,
    date_chargement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_fait_precip_temps ON fait_precipitations(temps_key);
CREATE INDEX idx_fait_precip_station ON fait_precipitations(station_key);
CREATE INDEX idx_fait_precip_severite ON fait_precipitations(severite_key);

\echo 'Tables de faits créées avec succès !'
