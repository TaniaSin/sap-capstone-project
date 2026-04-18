*&---------------------------------------------------------------------*
*& Program     : ZHR_EMPLOYEE_ALV_REPORT
*& Title       : Custom ALV Report – Employee Master Data
*& Author      : KIIT SAP Capstone Project
*& Description : Displays Employee Master Data using SAP ALV Grid Control
*&               with selection screen filters, field catalog, and layout.
*&---------------------------------------------------------------------*

REPORT zhr_employee_alv_report
  LINE-SIZE 200
  LINE-COUNT 65
  NO STANDARD PAGE HEADING
  MESSAGE-ID z_hr_msg.

*----------------------------------------------------------------------*
* TYPE DECLARATIONS
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_employee,
         pernr TYPE pa0001-pernr,    " Employee ID
         ename TYPE pa0001-ename,    " Employee Name
         werks TYPE pa0001-werks,    " Personnel Area (Plant)
         btrtl TYPE pa0001-btrtl,    " Personnel Subarea
         kostl TYPE pa0001-kostl,    " Cost Center
         stell TYPE pa0001-stell,    " Job Key
         begda TYPE pa0001-begda,    " Start Date
         endda TYPE pa0001-endda,    " End Date
         persg TYPE pa0001-persg,    " Employee Group
         persk TYPE pa0001-persk,    " Employee Subgroup
       END OF ty_employee.

*----------------------------------------------------------------------*
* INTERNAL TABLES & WORK AREAS
*----------------------------------------------------------------------*
DATA: gt_employee  TYPE STANDARD TABLE OF ty_employee,
      gs_employee  TYPE ty_employee,
      gt_fieldcat  TYPE slis_t_fieldcat_alv,
      gs_fieldcat  TYPE slis_fieldcat_alv,
      gs_layout    TYPE slis_layout_alv,
      gs_variant   TYPE disvariant,
      gt_sort      TYPE slis_t_sortinfo_alv,
      gs_sort      TYPE slis_sortinfo_alv.

*----------------------------------------------------------------------*
* SELECTION SCREEN
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_pernr FOR gs_employee-pernr,   " Employee ID
                  s_werks FOR gs_employee-werks,   " Plant
                  s_kostl FOR gs_employee-kostl,   " Cost Center
                  s_begda FOR gs_employee-begda.   " Start Date
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_maxrec TYPE i DEFAULT 1000,        " Max records
              p_active AS CHECKBOX DEFAULT 'X'.    " Active employees only
SELECTION-SCREEN END OF BLOCK b2.

*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.
  " Set default date range: current year
  s_begda-low  = sy-datum - 365.
  s_begda-high = sy-datum.
  s_begda-sign = 'I'.
  s_begda-option = 'BT'.
  APPEND s_begda TO s_begda.
  CLEAR s_begda.

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM fetch_employee_data.

  IF gt_employee IS INITIAL.
    MESSAGE 'No records found for the given selection criteria.' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  PERFORM build_field_catalog.
  PERFORM set_layout.
  PERFORM set_sort.
  PERFORM display_alv_report.

*----------------------------------------------------------------------*
* FORM: FETCH_EMPLOYEE_DATA
*----------------------------------------------------------------------*
FORM fetch_employee_data.

  DATA: lv_endda TYPE pa0001-endda.

  IF p_active = 'X'.
    lv_endda = '99991231'.  " Active records have end date 9999-12-31
  ENDIF.

  SELECT pernr
         ename
         werks
         btrtl
         kostl
         stell
         begda
         endda
         persg
         persk
    INTO TABLE gt_employee
    FROM pa0001
    WHERE pernr IN s_pernr
      AND werks IN s_werks
      AND kostl IN s_kostl
      AND begda IN s_begda
      AND ( endda = lv_endda OR p_active = ' ' )
    UP TO p_maxrec ROWS.

  IF sy-subrc <> 0.
    CLEAR gt_employee.
  ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: BUILD_FIELD_CATALOG
*----------------------------------------------------------------------*
FORM build_field_catalog.

  CLEAR gt_fieldcat.

  " Employee ID
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'PERNR'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Employee ID'.
  gs_fieldcat-outputlen   = 10.
  gs_fieldcat-key         = 'X'.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Employee Name
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'ENAME'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Employee Name'.
  gs_fieldcat-outputlen   = 30.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Personnel Area
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'WERKS'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Pers. Area'.
  gs_fieldcat-outputlen   = 10.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Personnel Subarea
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'BTRTL'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Subarea'.
  gs_fieldcat-outputlen   = 10.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Cost Center
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'KOSTL'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Cost Center'.
  gs_fieldcat-outputlen   = 12.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Job Key
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'STELL'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Job Key'.
  gs_fieldcat-outputlen   = 10.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Start Date
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'BEGDA'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Start Date'.
  gs_fieldcat-outputlen   = 12.
  gs_fieldcat-datatype    = 'DATS'.
  APPEND gs_fieldcat TO gt_fieldcat.

  " End Date
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'ENDDA'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'End Date'.
  gs_fieldcat-outputlen   = 12.
  gs_fieldcat-datatype    = 'DATS'.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Employee Group
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'PERSG'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Emp. Group'.
  gs_fieldcat-outputlen   = 10.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Employee Subgroup
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'PERSK'.
  gs_fieldcat-tabname     = 'GT_EMPLOYEE'.
  gs_fieldcat-seltext_m   = 'Emp. Subgroup'.
  gs_fieldcat-outputlen   = 12.
  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: SET_LAYOUT
*----------------------------------------------------------------------*
FORM set_layout.

  CLEAR gs_layout.
  gs_layout-zebra             = 'X'.   " Alternating row colors
  gs_layout-colwidth_optimize = 'X'.   " Auto column widths
  gs_layout-detail_popup      = 'X'.   " Popup for row detail
  gs_layout-get_selinfos      = 'X'.   " Show selection info
  gs_layout-box_fieldname     = ' '.   " No checkbox column

  " Variant settings
  gs_variant-report  = sy-repid.
  gs_variant-variant = '/DEFAULT'.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: SET_SORT
*----------------------------------------------------------------------*
FORM set_sort.

  CLEAR gt_sort.

  " Sort by Personnel Area, then Employee Name
  CLEAR gs_sort.
  gs_sort-fieldname = 'WERKS'.
  gs_sort-tabname   = 'GT_EMPLOYEE'.
  gs_sort-up        = 'X'.
  gs_sort-spos      = 1.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'ENAME'.
  gs_sort-tabname   = 'GT_EMPLOYEE'.
  gs_sort-up        = 'X'.
  gs_sort-spos      = 2.
  APPEND gs_sort TO gt_sort.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: DISPLAY_ALV_REPORT
*----------------------------------------------------------------------*
FORM display_alv_report.

  DATA: lv_repid TYPE sy-repid.
  lv_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = lv_repid
      i_callback_top_of_page  = 'TOP_OF_PAGE'
      i_callback_user_command = 'USER_COMMAND'
      it_fieldcat             = gt_fieldcat
      i_save                  = 'A'
      is_variant              = gs_variant
      is_layout               = gs_layout
      it_sort                 = gt_sort
    TABLES
      t_outtab                = gt_employee
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Error displaying ALV report.' TYPE 'E'.
  ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: TOP_OF_PAGE
*----------------------------------------------------------------------*
FORM top_of_page.

  DATA: lt_listheader TYPE slis_t_listheader,
        ls_listheader TYPE slis_listheader.

  " Title
  CLEAR ls_listheader.
  ls_listheader-typ  = 'H'.
  ls_listheader-info = 'Employee Master Data Report'.
  APPEND ls_listheader TO lt_listheader.

  " Date and Time
  CLEAR ls_listheader.
  ls_listheader-typ  = 'S'.
  ls_listheader-key  = 'Generated On:'.
  WRITE sy-datum TO ls_listheader-info DD/MM/YYYY.
  APPEND ls_listheader TO lt_listheader.

  CLEAR ls_listheader.
  ls_listheader-typ  = 'S'.
  ls_listheader-key  = 'Generated By:'.
  ls_listheader-info = sy-uname.
  APPEND ls_listheader TO lt_listheader.

  " Record Count
  CLEAR ls_listheader.
  ls_listheader-typ  = 'S'.
  ls_listheader-key  = 'Total Records:'.
  ls_listheader-info = lines( gt_employee ).
  APPEND ls_listheader TO lt_listheader.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_listheader.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: USER_COMMAND — Handle toolbar button clicks
*----------------------------------------------------------------------*
FORM user_command USING r_ucomm     TYPE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  CASE r_ucomm.
    WHEN '&IC1'.   " Double-click on row
      READ TABLE gt_employee INTO gs_employee INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.
        MESSAGE |Employee: { gs_employee-ename } | Cost Center: { gs_employee-kostl }|
          TYPE 'I'.
      ENDIF.
    WHEN OTHERS.
      " No action for other commands
  ENDCASE.

ENDFORM.
