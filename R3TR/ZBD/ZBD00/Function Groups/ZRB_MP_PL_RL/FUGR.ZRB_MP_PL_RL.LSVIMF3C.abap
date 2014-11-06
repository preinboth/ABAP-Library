*---------------------------------------------------------------------*
*       FORM LISTE_ZURUECKHOLEN                                       *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM LISTE_ZURUECKHOLEN.
  DATA: IX TYPE I.
* IF STATUS-ACTION NE AENDERN OR STATUS-DELETE NE GELOESCHT.
*   MESSAGE I001(SV).
*   EXIT.
* ENDIF.
  COUNTER = 0.
  LOOP AT EXTRACT.
    CHECK <XMARK> EQ MARKIERT.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      IX = SY-TABIX.
      PERFORM MOVE_EXTRACT_TO_VIEW_WA.
      PERFORM TEMPORAL_DELIMITATION.
    ENDIF.
    COUNTER = COUNTER + 1.
    READ TABLE TOTAL WITH KEY <VIM_xEXTRACT_KEY> BINARY SEARCH."#EC *
    PERFORM LOGICAL_UNDELETE_TOTAL USING SY-TABIX.
    MARK_TOTAL  = MARK_TOTAL - 1.
    MARK_EXTRACT = MARK_EXTRACT - 1.
    IF REPLACE_MODE NE SPACE AND VIM_EXTERNAL_MODE EQ SPACE.
      <XACT> = <ACTION>. <XMARK> = NICHT_MARKIERT.
      MODIFY EXTRACT.                  "no deletion in upgrade mode
    ELSE.
      IF TEMPORAL_DELIMITATION_HAPPENED NE SPACE.
        CLEAR VIM_DELIM_ENTRIES.
        VIM_DELIM_ENTRIES-INDEX3 = IX.
        APPEND VIM_DELIM_ENTRIES.
      ELSE.
        DELETE EXTRACT.
      ENDIF.
    ENDIF.
  ENDLOOP.
  IF TEMPORAL_DELIMITATION_HAPPENED NE SPACE.
    PERFORM AFTER_TEMPORAL_DELIMITATION.
    CLEAR TEMPORAL_DELIMITATION_HAPPENED.
  ENDIF.
  CHECK REPLACE_MODE EQ SPACE.
  DESCRIBE TABLE EXTRACT LINES MAXLINES.
  IF IGNORED_ENTRIES_EXIST EQ SPACE.
    MESSAGE S002(SV) WITH COUNTER.
  ELSE.
    MESSAGE W002(SV) WITH COUNTER.
  ENDIF.
  IF MAXLINES EQ 0.
    TITLE-ACTION = AENDERN.
    STATUS-DELETE = NICHT_GELOESCHT.
  ENDIF.
ENDFORM.