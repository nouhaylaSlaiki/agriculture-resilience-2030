cube(`FaitPrecipitations`, {
  sql: `SELECT * FROM dw.fait_precipitations`,
  
  joins: {
    DimTemps: {
      sql: `${CUBE}.temps_key = ${DimTemps}.temps_key`,
      relationship: `belongsTo`
    },
    
    DimStation: {
      sql: `${CUBE}.station_key = ${DimStation}.station_key`,
      relationship: `belongsTo`
    },
    
    DimSeverite: {
      sql: `${CUBE}.severite_key = ${DimSeverite}.severite_key`,
      relationship: `belongsTo`
    }
  },
  
  measures: {
    count: {
      type: `count`
    },
    
    quantiteTotaleMm: {
      sql: `quantite_mm`,
      type: `sum`
    },
    
    quantiteMoyenneMm: {
      sql: `quantite_mm`,
      type: `avg`
    },
    
    quantiteMaxMm: {
      sql: `quantite_mm`,
      type: `max`
    }
  },
  
  dimensions: {
    precipKey: {
      sql: `precip_key`,
      type: `number`,
      primaryKey: true
    },
    
    quantiteMm: {
      sql: `quantite_mm`,
      type: `number`
    },
    
    messageAlerte: {
      sql: `message_alerte`,
      type: `string`
    },
    
    dateEvenement: {
      sql: `date_evenement`,
      type: `time`
    }
  }
});
