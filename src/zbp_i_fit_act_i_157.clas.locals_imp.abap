CLASS lhc_Activities DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Activities.
    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE Activities.
    METHODS read FOR READ IMPORTING keys FOR READ Activities RESULT result.
    METHODS rba_Profile FOR READ IMPORTING keys_rba FOR READ Activities\_Profile FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_Activities IMPLEMENTATION.
  METHOD update.
    DATA ls_itm TYPE zfit_act_i_157.
    LOOP AT entities INTO DATA(ls_entities).
      SELECT SINGLE * FROM zfit_act_i_157 WHERE user_id = @ls_entities-UserId AND activity_id = @ls_entities-ActivityId INTO @ls_itm.

      IF ls_entities-%control-ActType = if_abap_behv=>mk-on. ls_itm-act_type = ls_entities-ActType. ENDIF.
      IF ls_entities-%control-DurationMins = if_abap_behv=>mk-on. ls_itm-duration_mins = ls_entities-DurationMins. ENDIF.
      IF ls_entities-%control-CaloriesBurned = if_abap_behv=>mk-on. ls_itm-calories_burned = ls_entities-CaloriesBurned. ENDIF.
      IF ls_entities-%control-AvgHeartRate = if_abap_behv=>mk-on. ls_itm-avg_heart_rate = ls_entities-AvgHeartRate. ENDIF.

      zcl_fit_utl_157=>get_instance( )->set_itm_value( ls_itm ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA ls_del TYPE zcl_fit_utl_157=>ty_act.
    LOOP AT keys INTO DATA(ls_key).
      ls_del-user_id = ls_key-UserId.
      ls_del-activity_id = ls_key-ActivityId.
      zcl_fit_utl_157=>get_instance( )->set_itm_deletion( ls_del ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    DATA ls_result LIKE LINE OF result.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zfit_act_i_157 FIELDS * WHERE user_id = @ls_key-UserId AND activity_id = @ls_key-ActivityId INTO @DATA(ls_db).
      IF sy-subrc = 0.
        ls_result-UserId         = ls_db-user_id.
        ls_result-ActivityId     = ls_db-activity_id.
        ls_result-ActType        = ls_db-act_type.
        ls_result-DurationMins   = ls_db-duration_mins.
        ls_result-CaloriesBurned = ls_db-calories_burned.
        ls_result-AvgHeartRate   = ls_db-avg_heart_rate.
        ls_result-%tky = ls_key-%tky.
        APPEND ls_result TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Profile.
    DATA ls_result LIKE LINE OF result.
    LOOP AT keys_rba INTO DATA(ls_key).
      INSERT VALUE #( source-%tky = ls_key-%tky target-UserId = ls_key-UserId ) INTO TABLE association_links.
      IF result_requested = abap_true.
        SELECT SINGLE FROM zfit_prof_h_157 FIELDS * WHERE user_id = @ls_key-UserId INTO @DATA(ls_hdr).
        IF sy-subrc = 0.
          ls_result-UserId = ls_hdr-user_id.
          APPEND ls_result TO result.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
