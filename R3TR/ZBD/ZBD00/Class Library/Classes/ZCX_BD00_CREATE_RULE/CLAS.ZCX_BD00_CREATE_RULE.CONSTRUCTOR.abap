method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->LINE = LINE .
me->MESSAGE = MESSAGE .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_BD00_CREATE_RULE .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.