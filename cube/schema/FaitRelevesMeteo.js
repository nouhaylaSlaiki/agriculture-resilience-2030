cube(`FaitRelevesMeteo`, {
  sql: `SELECT * FROM dw.fait_releves_meteo`,
  
  joins: {
    DimTemps: {
      sql: `${CUBE}.temps_key = ${DimTemps}.temps_key`,
      relationship: `belongsTo`
    },
    
    DimStation: {
      sql: `${CUBE}.station_key = ${DimStation}.station_key`,
      relationship: `belongsTo`
    }
  },
  
  measures: {
    count: {
      type: `count`
    },
    
    temperatureMoyenne: {
      sql: `temperature_celsius`,
      type: `avg`
    },
    
    temperatureMin: {
      sql: `temperature_celsius`,
      type: `min`
    },
    
    temperatureMax: {
      sql: `temperature_celsius`,
      type: `max`
    },
    
    humiditeMoyenne: {
      sql: `humidite_pct`,
      type: `avg`
    },
    
    ventMoyen: {
      sql: `vitesse_vent_kmh`,
      type: `avg`
    },
    
    nbAnomalies: {
      sql: `CASE WHEN est_anomalie_temp THEN 1 ELSE 0 END`,
      type: `sum`
    }
  },
  
  dimensions: {
    releveKey: {
      sql: `releve_key`,
      type: `number`,
      primaryKey: true
    },
    
    temperatureCelsius: {
      sql: `temperature_celsius`,
      type: `number`
    },
    
    humiditePct: {
      sql: `humidite_pct`,
      type: `number`
    },
    
    estAnomalieTemp: {
      sql: `est_anomalie_temp`,
      type: `boolean`
    },
    
    timestampOriginal: {
      sql: `timestamp_original`,
      type: `time`
    }
  }
});
