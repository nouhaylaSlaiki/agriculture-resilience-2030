cube(`DimStation`, {
  sql: `SELECT * FROM dw.dim_station WHERE est_actif = true`,
  
  dimensions: {
    stationKey: {
      sql: `station_key`,
      type: `number`,
      primaryKey: true
    },
    
    idStation: {
      sql: `id_station`,
      type: `string`
    },
    
    nomStation: {
      sql: `nom_station`,
      type: `string`
    },
    
    ville: {
      sql: `ville`,
      type: `string`
    },
    
    altitude: {
      sql: `altitude`,
      type: `number`
    },
    
    zoneGeo: {
      sql: `zone_geo`,
      type: `string`
    },
    
    capteurType: {
      sql: `capteur_type`,
      type: `string`
    }
  }
});
