method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
PGMID = PGMID
OBJECT = OBJECT
OBJ_NAME = OBJ_NAME
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_VCS_OBJECTS_CREATE__R3TR .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
