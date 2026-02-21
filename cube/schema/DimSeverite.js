cube(`DimSeverite`, {
  sql: `SELECT * FROM dw.dim_severite`,
  
  dimensions: {
    severiteKey: {
      sql: `severite_key`,
      type: `number`,
      primaryKey: true
    },
    
    codeSeverite: {
      sql: `code_severite`,
      type: `string`
    },
    
    libelle: {
      sql: `libelle`,
      type: `string`
    },
    
    niveauNumerique: {
      sql: `niveau_numerique`,
      type: `number`
    },
    
    couleurHex: {
      sql: `couleur_hex`,
      type: `string`
    }
  }
});
