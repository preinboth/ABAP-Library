*&---------------------------------------------------------------------*
*& Report  ZBW_DEP_INFO_FM
*&
*&---------------------------------------------------------------------*
*& This report returns dependency information as a simple list
*& of a Function module where to be used in a Transformation
*& as part of start, field- or endroutine or in a filter routine
*& of a DTP
*& Click on the line in the list opens the respective object in display mode
*&
*&---------------------------------------------------------------------*

REPORT  ZBW_DEP_INFO_FM NO STANDARD PAGE HEADING.
TYPES: BEGIN OF G_TY_DTP_OUTPUT,
DTP TYPE RSBKDTP-DTP,
OBJVERS TYPE RSBKDTP-OBJVERS,
SOURCE TYPE RSBKDTP-SRC,
TARGET TYPE RSBKDTP-TGT,
LINE TYPE RSAABAP-LINE,
END OF G_TY_DTP_OUTPUT.

TYPES: BEGIN OF G_TY_TRFN_OUTPUT,
TRANID TYPE RSTRAN-TRANID,
OBJVERS TYPE RSTRAN-OBJVERS,
SOURCE TYPE RSTRAN-SOURCENAME,
TARGET TYPE RSTRAN-TARGETNAME,
LINE TYPE RSAABAP-LINE,
END OF G_TY_TRFN_OUTPUT.



DATA: LT_RSAABAP TYPE TABLE OF RSAABAP.
DATA: LS_ABAP TYPE RSAABAP.
DATA: L_FM_NAME TYPE CHAR80.
DATA: LT_TRAN TYPE TABLE OF RSTRAN.
DATA: LS_TRAN TYPE RSTRAN.
DATA: LS_KURZTEXT TYPE RSTRANT-TXTLG.
DATA: LS_TRANROUT TYPE RSTRANSTEPROUT.
DATA: L_OK TYPE I.
DATA: L_R_RSBK_DTP TYPE REF TO CL_RSBK_DTP.
DATA: L_R_RSBC_FILTER TYPE REF TO CL_RSBC_FILTER.
DATA: LT_DTPRULE TYPE MCH_T_SOURCECODE.
DATA: LS_DTPRULE TYPE MCH_S_SOURCECODE.

DATA: LT_DTPS TYPE TABLE OF RSBKDTP.
DATA: LT_DTP_OUT TYPE TABLE OF G_TY_DTP_OUTPUT.
DATA: LS_DTP_OUT TYPE G_TY_DTP_OUTPUT.
DATA: LS_TRAN_OUT TYPE G_TY_TRFN_OUTPUT.
DATA: LT_TRAN_OUT TYPE TABLE OF G_TY_TRFN_OUTPUT.
DATA: LS_DTP TYPE RSBKDTP.
DATA: LT_SELS TYPE TABLE OF TAB512.
DATA: LT_RULES TYPE TABLE OF TAB512.
DATA: LT_VARS TYPE TABLE OF TAB512.
DATA: LS_RULE TYPE TAB512.

PARAMETERS: FM_NAME TYPE CHAR32.

END-OF-SELECTION.
  TRY.
      L_OK = 0.
      CALL FUNCTION FM_NAME.
*     successfull call, fm returns parameters only
    CATCH CX_SY_DYN_CALL_ILLEGAL_FUNC.
      WRITE: 'FM  not found! Chosse another name!'.
      L_OK = 1.
    CATCH CX_SY_DYN_CALL_ILLEGAL_TYPE
    CX_SY_DYN_CALL_PARAM_NOT_FOUND
    CX_SY_DYN_CALL_PARAM_MISSING.
* FM exists but wrong parameters, that'S ok!
* check call in transformations and DTP.
  ENDTRY.
  IF L_OK = 0.
    CONCATENATE '%' FM_NAME '%' INTO L_FM_NAME.
    SELECT * FROM RSAABAP
    INTO TABLE LT_RSAABAP
    WHERE LINE LIKE L_FM_NAME
    AND OBJVERS = 'A'.
    IF SY-SUBRC = 0.
      WRITE: 'FM ', FM_NAME, ' found in following transformations:'.
      NEW-LINE.
      WRITE: AT 1 'Transformation', AT 55 'A/M', AT 60 'Position', AT 100 'Source -> Target'.
      ULINE.
      NEW-LINE.
      LOOP AT LT_RSAABAP INTO LS_ABAP.
        REFRESH LT_TRAN.
        SELECT * FROM RSTRAN
        INTO TABLE LT_TRAN
        WHERE STARTROUTINE = LS_ABAP-CODEID
        OR EXPERT = LS_ABAP-CODEID
        OR ENDROUTINE = LS_ABAP-CODEID.
*              AND objvers = 'A'.
        IF SY-SUBRC = 0.
          LOOP AT LT_TRAN INTO LS_TRAN.
*              select single txtlg into ls_kurztext
*                from rstrant
*                where tranid = ls_tran-tranid
*                  and langu = 'E'
*                 and objvers = ls_tran-objvers.
            LS_TRAN_OUT-TRANID = LS_TRAN-TRANID.
            LS_TRAN_OUT-OBJVERS = LS_TRAN-OBJVERS.
            LS_TRAN_OUT-TARGET = LS_TRAN-TARGETNAME.
            LS_TRAN_OUT-SOURCE = LS_TRAN-SOURCENAME.
            IF LS_TRAN-EXPERT = LS_ABAP-CODEID.
              WRITE: AT 1 LS_TRAN-TRANID, AT 55 LS_TRAN-OBJVERS, AT 60 'Expertroutine', AT 100 LS_TRAN-SOURCENAME(10), '-->', LS_TRAN-TARGETNAME(10).
              LS_TRAN_OUT-LINE = 'Expertenroutine'.
            ELSEIF LS_TRAN-STARTROUTINE = LS_ABAP-CODEID.
              WRITE: LS_TRAN-TRANID, AT 55 LS_TRAN-OBJVERS, AT 60 'Startroutine', AT 100  LS_TRAN-SOURCENAME(10), '-->', LS_TRAN-TARGETNAME(10).
              LS_TRAN_OUT-LINE = 'Expertenroutine'.
            ELSEIF LS_TRAN-ENDROUTINE = LS_ABAP-CODEID.
              WRITE: LS_TRAN-TRANID, AT 55 LS_TRAN-OBJVERS, AT 60 'Endroutine', AT 100  LS_TRAN-SOURCENAME(10), '-->', LS_TRAN-TARGETNAME(10).
              LS_TRAN_OUT-LINE = 'Expertenroutine'.
            ENDIF.
            APPEND LS_TRAN_OUT TO LT_TRAN_OUT.
            NEW-LINE.
          ENDLOOP.
        ELSE.
*         search in field routines of transformation:
          SELECT TRANID FROM RSTRANSTEPROUT
          INTO LS_TRANROUT
          WHERE CODEID = LS_ABAP-CODEID.
            SELECT * FROM RSTRAN
            INTO TABLE LT_TRAN
            WHERE TRANID = LS_TRANROUT-TRANID.
            LOOP AT LT_TRAN INTO LS_TRAN.
              LS_TRAN_OUT-TRANID = LS_TRAN-TRANID.
              LS_TRAN_OUT-OBJVERS = LS_TRAN-OBJVERS.
              LS_TRAN_OUT-TARGET = LS_TRAN-TARGETNAME.
              LS_TRAN_OUT-SOURCE = LS_TRAN-SOURCENAME.
              LS_TRAN_OUT-LINE = 'Fieldroutine'.
              WRITE: AT 1 LS_TRAN-TRANID, AT 55 LS_TRAN-OBJVERS, AT 60 'Fieldroutine', AT 100 LS_TRAN-SOURCENAME(10), '->', LS_TRAN-TARGETNAME(10).
              APPEND LS_TRAN_OUT TO LT_TRAN_OUT.
              NEW-LINE.
            ENDLOOP.
          ENDSELECT.
        ENDIF.
      ENDLOOP.
      IF SY-SUBRC <> 0.
        WRITE: 'FM not found in any transforamation!'.
      ENDIF.
    ENDIF.
* Filter for DTPs:

    SKIP.
    SKIP.
    SKIP.
    WRITE: 'FM ', FM_NAME, ' found in following DTPs as filter:'.
    NEW-LINE.
    WRITE: AT 1 'DTP', AT 55 'A/M', AT 60 'Source -> Target', AT 100 'Characteristic'.
    ULINE.
    NEW-LINE.

    SELECT DTP OBJVERS SRC TGT FROM RSBKDTP
    INTO CORRESPONDING FIELDS OF TABLE LT_DTPS
    WHERE OBJVERS = 'A'
    OR  OBJVERS = 'M'.
    LOOP AT LT_DTPS INTO LS_DTP.

      REFRESH: LT_SELS, LT_RULES, LT_VARS.


      L_R_RSBK_DTP = CL_RSBK_DTP=>FACTORY( LS_DTP-DTP ).
      L_R_RSBC_FILTER = L_R_RSBK_DTP->IF_RSBK_DTP_DISPLAY~GET_OBJ_REF_FILTER( ).
      LT_DTPRULE[] = L_R_RSBC_FILTER->N_T_DTPRULE[].
      LOOP AT LT_DTPRULE INTO LS_DTPRULE.
        IF LS_DTPRULE-LINE CS FM_NAME.
          LS_DTP_OUT-DTP = LS_DTP-DTP.
          LS_DTP_OUT-OBJVERS = LS_DTP-OBJVERS.
          LS_DTP_OUT-TARGET = LS_DTP-TGT.
          LS_DTP_OUT-SOURCE = LS_DTP-SRC.
          CONCATENATE LS_DTP-SRC '->' LS_DTP-TGT INTO LS_DTP_OUT-LINE.
          WRITE: AT 1 LS_DTP-DTP, AT 55 LS_DTP-OBJVERS, AT 60 LS_DTP-SRC(15), '->', LS_DTP-TGT(15), AT 100 LS_DTPRULE-FIELD.
          APPEND LS_DTP_OUT TO LT_DTP_OUT.
          NEW-LINE.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDIF.

AT LINE-SELECTION.
  TYPE-POOLS: RSBC.
  DATA: LS_TRAN_LINES TYPE I.
  DATA: LS_TRAN_LINES2 TYPE I.
  DATA: LS_DTP_LINES TYPE I.
  DATA: LS_DTP_LINES2 TYPE I.
  DATA: LS_DTP_LINES3 TYPE I.
  DATA: LS_DTP_IND TYPE SY-TABIX.
  DATA: LS_TRAN_IND TYPE SY-TABIX.
  DATA: L_S_NAVIGATOR TYPE REF TO CL_RSAWBN_AWB.

  DESCRIBE TABLE LT_TRAN_OUT LINES LS_TRAN_LINES.
  DESCRIBE TABLE LT_DTP_OUT LINES LS_DTP_LINES.
  LS_TRAN_LINES2 = LS_TRAN_LINES + 3.
  LS_DTP_LINES2 = LS_TRAN_LINES2 + 6.
  LS_DTP_LINES3 = LS_DTP_LINES2 + LS_DTP_LINES.
  IF SY-CUROW > 3 AND SY-CUROW <= LS_TRAN_LINES2.
    CLEAR LS_TRAN_OUT.
    LS_TRAN_IND = SY-CUROW - 3.
    READ TABLE LT_TRAN_OUT INTO LS_TRAN_OUT INDEX LS_TRAN_IND.
    IF SY-SUBRC = 0.
*    create object l_s_navigator.
*    cl_rsawbn_awb=>start( i_view = 'M' ).
      CL_RSTRAN_GUI=>START( EXPORTING I_TRANID      = LS_TRAN_OUT-TRANID
      I_R_NAVIGATOR = L_S_NAVIGATOR
      I_FCODE       = 'DISPLAY'
      EXCEPTIONS OTHERS = 1 ).
    ENDIF.
  ELSEIF SY-CUROW > LS_DTP_LINES2 AND SY-CUROW <= LS_DTP_LINES3.
    CLEAR LS_TRAN_OUT.
    LS_DTP_IND = SY-CUROW - LS_DTP_LINES2.
    READ TABLE LT_DTP_OUT INTO LS_DTP_OUT INDEX LS_DTP_IND.
    IF SY-SUBRC = 0.
      CALL FUNCTION 'RSBK_DTP_MAINTAIN'
        EXPORTING
          I_DTP  = LS_DTP_OUT-DTP
          I_MODE = RSBC_C_MODE-DISPLAY.
    ENDIF.
  ENDIF.
