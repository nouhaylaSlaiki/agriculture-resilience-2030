-- ============================================
-- Script 02: Tables de Staging (Zone de transit)
-- ============================================

SET search_path TO staging;

-- Table de staging pour relevés météo
DROP TABLE IF EXISTS stg_releves_meteo CASCADE;
CREATE TABLE stg_releves_meteo (
    id SERIAL PRIMARY KEY,
    timestamp_raw TEXT,
    st_id TEXT,
    temp_c_raw TEXT,
    hum_pct_raw TEXT,
    wind_speed_raw TEXT,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de staging pour notifications
DROP TABLE IF EXISTS stg_notifications CASCADE;
CREATE TABLE stg_notifications (
    id SERIAL PRIMARY KEY,
    date_raw TEXT,
    station_code TEXT,
    precip_mm_raw TEXT,
    type_precip TEXT,
    severity_index TEXT,
    alert_msg TEXT,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de staging pour stations
DROP TABLE IF EXISTS stg_stations CASCADE;
CREATE TABLE stg_stations (
    id SERIAL PRIMARY KEY,
    id_station TEXT,
    nom_station TEXT,
    ville TEXT,
    altitude_raw TEXT,
    zone_geo TEXT,
    capteur_type TEXT,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

\echo 'Tables de staging créées avec succès !'
