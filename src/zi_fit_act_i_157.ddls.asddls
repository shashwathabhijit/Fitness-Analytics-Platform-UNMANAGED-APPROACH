@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity Log Interface'
define view entity ZI_FIT_ACT_I_157 as select from zfit_act_i_157
association to parent ZI_FIT_PROF_H_157 as _Profile
  on $projection.UserId = _Profile.UserId
{
  key user_id as UserId,
  key activity_id as ActivityId,
  act_type as ActType,
  
  case act_type
    when 'CARDIO'   then 1 /* Red Heart */
    when 'STRENGTH' then 3 /* Green Muscle */
    when 'YOGA'     then 2 /* Orange Zen */
    else 0
  end as TypeCrit,

  duration_mins as DurationMins,
  calories_burned as CaloriesBurned,
  avg_heart_rate as AvgHeartRate,
  
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  loc_last_chg_at as LocLastChgAt,
  
  _Profile
}
