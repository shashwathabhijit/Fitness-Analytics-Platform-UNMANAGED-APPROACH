//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Fitness Profile Interface'
//define root view entity ZI_FIT_PROF_H_157 as select from zfit_prof_h_157
//composition [0..*] of ZI_FIT_ACT_I_157 as _Activities
//{
//  key user_id as UserId,
//  full_name as FullName,
//  fitness_goal as FitnessGoal,
//  health_status as HealthStatus,
//  
//  case health_status
//    when 'EXCELLENT' then 3  /* Green */
//    when 'ACTIVE'    then 2  /* Orange */
//    when 'AT RISK'   then 1  /* Red */
//    else 0
//  end as StatusCrit,
//
//  @Semantics.quantity.unitOfMeasure: 'Unit'
//  target_weight as TargetWeight,
//  @Semantics.quantity.unitOfMeasure: 'Unit'
//  current_weight as CurrentWeight,
//  unit as Unit,
//
//  @Semantics.systemDateTime.localInstanceLastChangedAt: true
//  loc_last_chg_at as LocLastChgAt,
//  @Semantics.systemDateTime.lastChangedAt: true
//  last_changed_at as LastChangedAt,
//  
//  _Activities
//}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fitness Profile Interface'
define root view entity ZI_FIT_PROF_H_157 as select from zfit_prof_h_157
composition [0..*] of ZI_FIT_ACT_I_157 as _Activities
{
  key user_id as UserId,
  full_name as FullName,
  fitness_goal as FitnessGoal,
  health_status as HealthStatus,
  case health_status
    when 'GOOD'               then 3  
    when 'CAN BE CONTROLLED'  then 2  
    when 'SHOULD BE IMPROVED' then 1  
    else 0                            
  end as StatusCrit,

  @Semantics.quantity.unitOfMeasure: 'Unit'
  target_weight as TargetWeight,
  
  @Semantics.quantity.unitOfMeasure: 'Unit'
  current_weight as CurrentWeight,
  case 
    when current_weight > 90 then 1                            
    when current_weight >= 60 and current_weight <= 90 then 2  
    when current_weight > 0 and current_weight < 60 then 5     
    else 0
  end as WeightCrit,

  unit as Unit,

  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  loc_last_chg_at as LocLastChgAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  
  _Activities
}
