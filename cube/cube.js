module.exports = {
  schemaPath: 'schema',
  dbType: 'postgres',
  
  contextToAppId: ({ securityContext }) => 
    `CUBE_${securityContext.userId || 'anonymous'}`,
  
  scheduledRefreshContexts: async () => [
    { securityContext: {} }
  ],
  
  preAggregationsSchema: 'dw_pre_agg'
};
