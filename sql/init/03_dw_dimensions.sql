-- ============================================
-- Script 03: Tables de Dimensions
-- ============================================

SET search_path TO dw;

-- Dimension Temps (Date/Heure)
DROP TABLE IF EXISTS dim_temps CASCADE;
CREATE TABLE dim_temps (
    temps_key SERIAL PRIMARY KEY,
    date_complete DATE NOT NULL,
    annee INT NOT NULL,
    trimestre INT NOT NULL,
    mois INT NOT NULL,
    nom_mois VARCHAR(20),
    semaine INT NOT NULL,
    jour_mois INT NOT NULL,
    jour_semaine INT NOT NULL,
    nom_jour VARCHAR(20),
    heure INT,
    est_weekend BOOLEAN,
    saison VARCHAR(20),
    UNIQUE(date_complete, heure)
);

CREATE INDEX idx_dim_temps_date ON dim_temps(date_complete);
CREATE INDEX idx_dim_temps_annee_mois ON dim_temps(annee, mois);

-- Dimension Station
DROP TABLE IF EXISTS dim_station CASCADE;
CREATE TABLE dim_station (
    station_key SERIAL PRIMARY KEY,
    id_station VARCHAR(20) UNIQUE NOT NULL,
    nom_station VARCHAR(100),
    ville VARCHAR(50),
    altitude INT,
    zone_geo VARCHAR(50),
    capteur_type VARCHAR(20),
    date_debut_validite DATE DEFAULT CURRENT_DATE,
    date_fin_validite DATE DEFAULT '9999-12-31',
    est_actif BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_dim_station_zone ON dim_station(zone_geo);
CREATE INDEX idx_dim_station_ville ON dim_station(ville);

-- Dimension Type de Précipitation
DROP TABLE IF EXISTS dim_type_precip CASCADE;
CREATE TABLE dim_type_precip (
    type_precip_key SERIAL PRIMARY KEY,
    type_precip VARCHAR(20) UNIQUE NOT NULL,
    description TEXT,
    niveau_risque VARCHAR(20)
);

-- Données de référence
INSERT INTO dim_type_precip (type_precip, description, niveau_risque) VALUES
('Pluie', 'Précipitations liquides normales', 'Faible'),
('Grêle', 'Précipitations solides dangereuses pour cultures', 'Élevé'),
('Neige', 'Précipitations neigeuses rares', 'Modéré'),
('Aucune', 'Pas de précipitation', 'Aucun');

-- Dimension Sévérité
DROP TABLE IF EXISTS dim_severite CASCADE;
CREATE TABLE dim_severite (
    severite_key SERIAL PRIMARY KEY,
    code_severite VARCHAR(10) UNIQUE NOT NULL,
    libelle VARCHAR(50),
    niveau_numerique INT,
    couleur_hex VARCHAR(7),
    action_recommandee TEXT
);

-- Données de référence
INSERT INTO dim_severite (code_severite, libelle, niveau_numerique, couleur_hex, action_recommandee) VALUES
('RAS', 'Rien à Signaler', 0, '#00FF00', 'Surveillance normale'),
('Jaune', 'Vigilance', 1, '#FFFF00', 'Attention accrue recommandée'),
('Orange', 'Alerte', 2, '#FFA500', 'Mesures préventives urgentes'),
('Rouge', 'Alerte Maximale', 3, '#FF0000', 'Action immédiate requise');

\echo 'Tables de dimensions créées avec succès !'
