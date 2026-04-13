@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity Log Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_FIT_ACT_I_157
  as projection on ZI_FIT_ACT_I_157
{
  @Search.defaultSearchElement: true
  key UserId,
  key ActivityId,
  
  @Search.defaultSearchElement: true
  ActType,
  
  /* Passing the Criticality Color to the UI */
  TypeCrit,
  
  DurationMins,
  CaloriesBurned,
  AvgHeartRate,
  LocLastChgAt,
  
  /* CRITICAL: Redirecting the association back to the new UI Header View */
  _Profile : redirected to parent ZC_FIT_PROF_H_157
}
