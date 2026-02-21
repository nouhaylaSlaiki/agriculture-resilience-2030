cube(`DimTemps`, {
  sql: `SELECT * FROM dw.dim_temps`,
  
  dimensions: {
    tempsKey: {
      sql: `temps_key`,
      type: `number`,
      primaryKey: true
    },
    
    dateComplete: {
      sql: `date_complete`,
      type: `time`
    },
    
    annee: {
      sql: `annee`,
      type: `number`
    },
    
    mois: {
      sql: `mois`,
      type: `number`
    },
    
    nomMois: {
      sql: `nom_mois`,
      type: `string`
    },
    
    trimestre: {
      sql: `trimestre`,
      type: `number`
    },
    
    saison: {
      sql: `saison`,
      type: `string`
    },
    
    estWeekend: {
      sql: `est_weekend`,
      type: `boolean`
    }
  }
});
