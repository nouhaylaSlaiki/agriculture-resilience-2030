-- ============================================
-- Script 01: Création des schémas
-- ============================================

-- Schéma pour les tables de staging
CREATE SCHEMA IF NOT EXISTS staging;
COMMENT ON SCHEMA staging IS 'Zone de transit pour données brutes';

-- Schéma pour le Data Warehouse
CREATE SCHEMA IF NOT EXISTS dw;
COMMENT ON SCHEMA dw IS 'Data Warehouse multidimensionnel';

-- Schéma pour Metabase
CREATE DATABASE metabase;

-- Donner les permissions
GRANT ALL PRIVILEGES ON SCHEMA staging TO bi_user;
GRANT ALL PRIVILEGES ON SCHEMA dw TO bi_user;
GRANT ALL ON DATABASE metabase TO bi_user;

\echo 'Schémas créés avec succès !'
