method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
PGMID = PGMID
OBJECT = OBJECT
OBJ_NAME = OBJ_NAME
.
me->SYSTEM = SYSTEM .
me->APPSET_ID = APPSET_ID .
me->APPLICATION_ID = APPLICATION_ID .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_VCS_OBJECTS_READ__BPC .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
