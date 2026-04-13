*CLASS zcl_fit_utl_157 DEFINITION PUBLIC FINAL CREATE PRIVATE.
*  PUBLIC SECTION.
*    TYPES: BEGIN OF ty_prof, user_id TYPE n LENGTH 10, END OF ty_prof,
*           BEGIN OF ty_act, user_id TYPE n LENGTH 10, activity_id TYPE int2, END OF ty_act.
*    TYPES: tt_prof TYPE STANDARD TABLE OF ty_prof,
*           tt_act TYPE STANDARD TABLE OF ty_act.
*
*    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_fit_utl_157.
*    METHODS:
*      set_hdr_value IMPORTING im_hdr TYPE zfit_prof_h_157,
*      get_hdr_value EXPORTING ex_hdr TYPE zfit_prof_h_157,
*      set_itm_value IMPORTING im_itm TYPE zfit_act_i_157,
*      get_itm_value EXPORTING ex_itm TYPE zfit_act_i_157,
*      set_hdr_deletion IMPORTING im_hdr_doc TYPE ty_prof,
*      set_itm_deletion IMPORTING im_itm_doc TYPE ty_act,
*      get_deletions EXPORTING ex_hdr_del TYPE tt_prof ex_itm_del TYPE tt_act,
*      cleanup_buffer.
*
*  PRIVATE SECTION.
*    CLASS-DATA: mo_instance TYPE REF TO zcl_fit_utl_157,
*                gs_hdr_buff TYPE zfit_prof_h_157,
*                gs_itm_buff TYPE zfit_act_i_157,
*                gt_hdr_del TYPE tt_prof,
*                gt_itm_del TYPE tt_act.
*ENDCLASS.
*
*CLASS zcl_fit_utl_157 IMPLEMENTATION.
*  METHOD get_instance. IF mo_instance IS INITIAL. CREATE OBJECT mo_instance. ENDIF. ro_instance = mo_instance. ENDMETHOD.
*  METHOD set_hdr_value. gs_hdr_buff = im_hdr. ENDMETHOD.
*  METHOD get_hdr_value. ex_hdr = gs_hdr_buff. ENDMETHOD.
*  METHOD set_itm_value. gs_itm_buff = im_itm. ENDMETHOD.
*  METHOD get_itm_value. ex_itm = gs_itm_buff. ENDMETHOD.
*  METHOD set_hdr_deletion. APPEND im_hdr_doc TO gt_hdr_del. ENDMETHOD.
*  METHOD set_itm_deletion. APPEND im_itm_doc TO gt_itm_del. ENDMETHOD.
*  METHOD get_deletions. ex_hdr_del = gt_hdr_del. ex_itm_del = gt_itm_del. ENDMETHOD.
*  METHOD cleanup_buffer. CLEAR: gs_hdr_buff, gs_itm_buff, gt_hdr_del, gt_itm_del. ENDMETHOD.
*ENDCLASS.
CLASS zcl_fit_utl_157 DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_prof, user_id TYPE n LENGTH 10, END OF ty_prof,
           BEGIN OF ty_act, user_id TYPE n LENGTH 10, activity_id TYPE int2, END OF ty_act.

    TYPES: tt_prof TYPE STANDARD TABLE OF ty_prof,
           tt_act  TYPE STANDARD TABLE OF ty_act,
           " --- UPGRADE: Table Types for Data Buffering ---
           tt_hdr_data TYPE STANDARD TABLE OF ZFIT_PROF_H_157,
           tt_itm_data TYPE STANDARD TABLE OF ZFIT_ACT_I_157.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO ZCL_FIT_UTL_157.

    METHODS:
      set_hdr_value IMPORTING im_hdr TYPE ZFIT_PROF_H_157,
      get_hdr_value EXPORTING ex_hdr TYPE tt_hdr_data,  " Now exports a table
      set_itm_value IMPORTING im_itm TYPE ZFIT_ACT_I_157,
      get_itm_value EXPORTING ex_itm TYPE tt_itm_data,  " Now exports a table
      set_hdr_deletion IMPORTING im_hdr_doc TYPE ty_prof,
      set_itm_deletion IMPORTING im_itm_doc TYPE ty_act,
      get_deletions EXPORTING ex_hdr_del TYPE tt_prof ex_itm_del TYPE tt_act,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: mo_instance TYPE REF TO ZCL_FIT_UTL_157,
                " --- UPGRADE: Internal Tables instead of single structures ---
                gt_hdr_buff TYPE tt_hdr_data,
                gt_itm_buff TYPE tt_itm_data,
                gt_hdr_del  TYPE tt_prof,
                gt_itm_del  TYPE tt_act.
ENDCLASS.

CLASS zcl_fit_utl_157 IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL. CREATE OBJECT mo_instance. ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    " Check if it exists, update it. If not, append it.
    READ TABLE gt_hdr_buff ASSIGNING FIELD-SYMBOL(<fs_hdr>) WITH KEY user_id = im_hdr-user_id.
    IF sy-subrc = 0. <fs_hdr> = im_hdr. ELSE. APPEND im_hdr TO gt_hdr_buff. ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value. ex_hdr = gt_hdr_buff. ENDMETHOD.

  METHOD set_itm_value.
    READ TABLE gt_itm_buff ASSIGNING FIELD-SYMBOL(<fs_itm>) WITH KEY user_id = im_itm-user_id activity_id = im_itm-activity_id.
    IF sy-subrc = 0. <fs_itm> = im_itm. ELSE. APPEND im_itm TO gt_itm_buff. ENDIF.
  ENDMETHOD.

  METHOD get_itm_value. ex_itm = gt_itm_buff. ENDMETHOD.

  METHOD set_hdr_deletion. APPEND im_hdr_doc TO gt_hdr_del. ENDMETHOD.
  METHOD set_itm_deletion. APPEND im_itm_doc TO gt_itm_del. ENDMETHOD.
  METHOD get_deletions. ex_hdr_del = gt_hdr_del. ex_itm_del = gt_itm_del. ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gt_hdr_buff, gt_itm_buff, gt_hdr_del, gt_itm_del.
  ENDMETHOD.
ENDCLASS.
