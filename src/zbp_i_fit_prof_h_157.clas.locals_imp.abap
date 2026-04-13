CLASS lhc_Profile DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR Profile RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION IMPORTING REQUEST requested_authorizations FOR Profile RESULT result.
    METHODS create FOR MODIFY IMPORTING entities FOR CREATE Profile.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Profile.
    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE Profile.
    METHODS read FOR READ IMPORTING keys FOR READ Profile RESULT result.
    METHODS lock FOR LOCK IMPORTING keys FOR LOCK Profile.
    METHODS cba_Activities FOR MODIFY IMPORTING entities_cba FOR CREATE Profile\_Activities.
ENDCLASS.

CLASS lhc_Profile IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on. result-%create = if_abap_behv=>auth-allowed. ENDIF.
  ENDMETHOD.
  METHOD lock. ENDMETHOD.

  METHOD create.
    DATA ls_hdr TYPE zfit_prof_h_157.
    LOOP AT entities INTO DATA(ls_entities).
      ls_hdr-user_id        = ls_entities-UserId.
      ls_hdr-full_name      = ls_entities-FullName.
      ls_hdr-fitness_goal   = ls_entities-FitnessGoal.
      ls_hdr-health_status  = ls_entities-HealthStatus.
      ls_hdr-target_weight  = ls_entities-TargetWeight.
      ls_hdr-current_weight = ls_entities-CurrentWeight.
      ls_hdr-unit           = ls_entities-Unit.

      zcl_fit_utl_157=>get_instance( )->set_hdr_value( ls_hdr ).
      APPEND VALUE #( %cid = ls_entities-%cid userid = ls_hdr-user_id ) TO mapped-profile.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA ls_hdr TYPE zfit_prof_h_157.
    LOOP AT entities INTO DATA(ls_entities).
      SELECT SINGLE * FROM zfit_prof_h_157 WHERE user_id = @ls_entities-UserId INTO @ls_hdr.

      IF ls_entities-%control-FullName = if_abap_behv=>mk-on. ls_hdr-full_name = ls_entities-FullName. ENDIF.
      IF ls_entities-%control-FitnessGoal = if_abap_behv=>mk-on. ls_hdr-fitness_goal = ls_entities-FitnessGoal. ENDIF.
      IF ls_entities-%control-HealthStatus = if_abap_behv=>mk-on. ls_hdr-health_status = ls_entities-HealthStatus. ENDIF.
      IF ls_entities-%control-CurrentWeight = if_abap_behv=>mk-on. ls_hdr-current_weight = ls_entities-CurrentWeight. ENDIF.
      IF ls_entities-%control-TargetWeight = if_abap_behv=>mk-on. ls_hdr-target_weight = ls_entities-TargetWeight. ENDIF.

      zcl_fit_utl_157=>get_instance( )->set_hdr_value( ls_hdr ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA ls_del TYPE zcl_fit_utl_157=>ty_prof.
    LOOP AT keys INTO DATA(ls_key).
      ls_del-user_id = ls_key-UserId.
      zcl_fit_utl_157=>get_instance( )->set_hdr_deletion( ls_del ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    DATA ls_result LIKE LINE OF result.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zfit_prof_h_157 FIELDS * WHERE user_id = @ls_key-UserId INTO @DATA(ls_db).
      IF sy-subrc = 0.
        ls_result-UserId        = ls_db-user_id.
        ls_result-FullName      = ls_db-full_name.
        ls_result-FitnessGoal   = ls_db-fitness_goal.
        ls_result-HealthStatus  = ls_db-health_status.
        ls_result-CurrentWeight = ls_db-current_weight.
        ls_result-TargetWeight  = ls_db-target_weight.
        ls_result-Unit          = ls_db-unit.
        ls_result-%tky = ls_key-%tky.
        APPEND ls_result TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Activities.
    DATA ls_itm TYPE zfit_act_i_157.
    LOOP AT entities_cba INTO DATA(ls_entities_cba).
      LOOP AT ls_entities_cba-%target INTO DATA(ls_target).
        ls_itm-user_id         = ls_entities_cba-UserId.
        ls_itm-activity_id     = ls_target-ActivityId.
        ls_itm-act_type        = ls_target-ActType.
        ls_itm-duration_mins   = ls_target-DurationMins.
        ls_itm-calories_burned = ls_target-CaloriesBurned.
        ls_itm-avg_heart_rate  = ls_target-AvgHeartRate.

        zcl_fit_utl_157=>get_instance( )->set_itm_value( ls_itm ).
        APPEND VALUE #( %cid = ls_target-%cid userid = ls_itm-user_id activityid = ls_itm-activity_id ) TO mapped-activities.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lsc_ZI_FIT_PROF_H_157 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
ENDCLASS.

CLASS lsc_ZI_FIT_PROF_H_157 IMPLEMENTATION.
  METHOD save.
    DATA(lo_util) = ZCL_FIT_UTL_157=>get_instance( ).
    " Now pulling full internal tables instead of single rows
    lo_util->get_hdr_value( IMPORTING ex_hdr = DATA(lt_hdr) ).
    lo_util->get_itm_value( IMPORTING ex_itm = DATA(lt_itm) ).
    lo_util->get_deletions( IMPORTING ex_hdr_del = DATA(lt_hdr_del) ex_itm_del = DATA(lt_itm_del) ).

    " --- UPGRADE: Bulk Modify from Tables ---
    IF lt_hdr IS NOT INITIAL. MODIFY ZFIT_PROF_H_157 FROM TABLE @lt_hdr. ENDIF.
    IF lt_itm IS NOT INITIAL. MODIFY ZFIT_ACT_I_157 FROM TABLE @lt_itm. ENDIF.

    LOOP AT lt_hdr_del INTO DATA(ls_del_h). DELETE FROM ZFIT_PROF_H_157 WHERE user_id = @ls_del_h-user_id. ENDLOOP.
    LOOP AT lt_itm_del INTO DATA(ls_del_i). DELETE FROM ZFIT_ACT_I_157 WHERE user_id = @ls_del_i-user_id AND activity_id = @ls_del_i-activity_id. ENDLOOP.
  ENDMETHOD.

  METHOD cleanup.
    ZCL_FIT_UTL_157=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.
ENDCLASS.
