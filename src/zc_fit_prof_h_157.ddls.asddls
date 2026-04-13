//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Fitness Profile Projection'
//@Metadata.allowExtensions: true
//@Search.searchable: true
//define root view entity ZC_FIT_PROF_H_157
//  provider contract transactional_query
//  as projection on ZI_FIT_PROF_H_157
//{
//  key UserId,
//  
//  @Search.defaultSearchElement: true
//  @Search.fuzzinessThreshold: 0.8
//  FullName,
//  
//  @Search.defaultSearchElement: true
//  FitnessGoal,
//  
//  HealthStatus,
//  
//  /* Passing the Criticality Color to the UI */
//  StatusCrit,
//  
//  TargetWeight,
//  CurrentWeight,
//  Unit,
//  LocLastChgAt,
//  LastChangedAt,
//  
//  /* CRITICAL: Redirecting the association to the new UI Item View */
//  _Activities : redirected to composition child ZC_FIT_ACT_I_157
//}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fitness Profile Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_FIT_PROF_H_157
  provider contract transactional_query
  as projection on ZI_FIT_PROF_H_157
{
  key UserId,
  
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  FullName,
  
  @Search.defaultSearchElement: true
  FitnessGoal,
  
  HealthStatus,
  StatusCrit,
  
  TargetWeight,
  CurrentWeight,
  WeightCrit,    /* NEW: Passing Weight Color to UI */
  
  Unit,
  LocLastChgAt,
  LastChangedAt,
  
  _Activities : redirected to composition child ZC_FIT_ACT_I_157
}
