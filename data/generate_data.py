import pandas as pd
import numpy as np
import json
from datetime import datetime, timedelta
import random

# Configuration
np.random.seed(42)
random.seed(42)

# ========== 1. STATIONS_MASTER.XLSX ==========
print("Génération de stations_master.xlsx...")

stations_data = {
    'ID_Station': [f'ST_{i:03d}' for i in range(1, 21)],
    'Nom_Station': [
        'Agdal', 'Menara', 'Ménara Nord', 'Atlas View', 'Souss Point',
        'Gharb Central', 'Saïss Hub', 'Oued Tensift', 'Haouz Est',
        'Doukkala Pivot', 'Tadla Station', 'Loukkos Beta', 'Rif Alpha',
        'Moulouya Track', 'Oriental Gate', 'Sahara Edge', 'Anti-Atlas',
        'Drâa Monitor', 'Oasis Sentinel', 'Côtier Essaouira'
    ],
    'Ville': [
        'Marrakech', 'Marrakech', 'Marrakech', 'Marrakech', 'Agadir',
        'Kenitra', 'Meknes', 'Marrakech', 'Marrakech', 'El Jadida',
        'Beni Mellal', 'Larache', 'Chefchaouen', 'Oujda', 'Oujda',
        'Errachidia', 'Taroudant', 'Zagora', 'Ouarzazate', 'Essaouira'
    ],
    'Altitude': [
        466, 466, 470, 520, 30, 15, 552, 450, 500, 56,
        508, 40, 610, 470, 480, 1045, 230, 730, 1151, 120
    ],
    'Zone_Geo': [
        'Haouz', 'Haouz', 'Haouz', 'Haouz', 'Souss-Massa',
        'Gharb', 'Saïss', 'Haouz', 'Haouz', 'Doukkala',
        'Tadla', 'Loukkos', 'Rif', 'Oriental', 'Oriental',
        'Sahara', 'Souss-Massa', 'Sahara', 'Sahara', 'Atlantique'
    ],
    'Capteur_Type': np.random.choice(['Digital', 'Analogique'], 20, p=[0.7, 0.3])
}

df_stations = pd.DataFrame(stations_data)
df_stations.to_excel('data/raw/stations_master.xlsx', index=False, sheet_name='Stations')

# ========== 2. RELEVES_METEO.CSV ==========
print("Génération de relevés_meteo.csv...")

start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 12, 31)
# CORRECTION: Utiliser 'h' minuscule au lieu de 'H' majuscule (Pandas 2.x)
date_range = pd.date_range(start_date, end_date, freq='4h')

meteo_records = []

for station_id in stations_data['ID_Station']:
    idx = stations_data['ID_Station'].index(station_id)
    zone = stations_data['Zone_Geo'][idx]
    
    # Profils climatiques par zone
    if zone in ['Sahara']:
        temp_base, temp_var = 32, 12
        hum_base, hum_var = 25, 15
        wind_base, wind_var = 15, 8
    elif zone in ['Atlantique', 'Gharb']:
        temp_base, temp_var = 20, 8
        hum_base, hum_var = 70, 20
        wind_base, wind_var = 20, 10
    else:  # Continental
        temp_base, temp_var = 22, 10
        hum_base, hum_var = 50, 25
        wind_base, wind_var = 12, 6
    
    for dt in date_range:
        # Variation saisonnière
        day_of_year = dt.timetuple().tm_yday
        seasonal_factor = np.sin(2 * np.pi * day_of_year / 365)
        
        # Température avec anomalies
        temp = temp_base + temp_var * seasonal_factor + np.random.normal(0, 3)
        
        # Injection d'anomalies (2% de chance)
        if random.random() < 0.02:
            temp = random.choice([temp * 1.5, -5, 75, None])  # Anomalies
        
        # Humidité
        humidity = max(0, min(100, hum_base - hum_var * seasonal_factor + np.random.normal(0, 10)))
        
        # Vent
        wind = max(0, wind_base + wind_var * np.random.random())
        
        meteo_records.append({
            'timestamp': dt.strftime('%Y-%m-%d %H:%M:%S'),
            'st_id': station_id,
            'temp_c': round(temp, 1) if temp is not None else None,
            'hum_pct': round(humidity, 1),
            'wind_speed': round(wind, 1)
        })

df_meteo = pd.DataFrame(meteo_records)
df_meteo.to_csv('data/raw/releves_meteo.csv', index=False)

# ========== 3. NOTIFICATIONS.JSON ==========
print("Génération de notifications.json...")

# CORRECTION: Utiliser 'd' minuscule au lieu de 'D' majuscule
date_range_daily = pd.date_range(start_date, end_date, freq='d')
notifications = []

severity_levels = ['RAS', 'Jaune', 'Orange', 'Rouge']
precip_types = ['Pluie', 'Grêle', 'Neige']

for dt in date_range_daily:
    # Pas tous les jours, seulement 40% du temps
    if random.random() < 0.4:
        num_stations = random.randint(1, 5)
        selected_stations = random.sample(stations_data['ID_Station'], num_stations)
        
        for station_id in selected_stations:
            idx = stations_data['ID_Station'].index(station_id)
            zone = stations_data['Zone_Geo'][idx]
            
            # Probabilités selon zones
            if zone == 'Sahara':
                precip_amt = np.random.exponential(2)
                severity = np.random.choice(severity_levels, p=[0.7, 0.2, 0.08, 0.02])
                precip_type = 'Pluie'
            elif zone in ['Gharb', 'Atlantique']:
                precip_amt = np.random.exponential(15)
                severity = np.random.choice(severity_levels, p=[0.4, 0.3, 0.2, 0.1])
                precip_type = np.random.choice(precip_types, p=[0.85, 0.1, 0.05])
            else:
                precip_amt = np.random.exponential(8)
                severity = np.random.choice(severity_levels, p=[0.5, 0.3, 0.15, 0.05])
                precip_type = np.random.choice(precip_types, p=[0.8, 0.15, 0.05])
            
            # Messages d'alerte
            if severity == 'Rouge':
                alert_msg = f"ALERTE ROUGE: Conditions extrêmes - {precip_type} intense"
            elif severity == 'Orange':
                alert_msg = f"Vigilance Orange: {precip_type} modérée à forte"
            elif severity == 'Jaune':
                alert_msg = f"Attention: {precip_type} légère attendue"
            else:
                alert_msg = "Conditions normales"
            
            notifications.append({
                'date': dt.strftime('%Y-%m-%d'),
                'station_code': station_id,
                'precip_mm': round(precip_amt, 1),
                'type_precip': precip_type,
                'severity_index': severity,
                'alert_msg': alert_msg
            })

with open('data/raw/notifications.json', 'w', encoding='utf-8') as f:
    json.dump(notifications, f, ensure_ascii=False, indent=2)

print(f"\n✅ Génération terminée:")
print(f"   - {len(df_stations)} stations")
print(f"   - {len(df_meteo)} relevés météo")
print(f"   - {len(notifications)} notifications")
