method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MODULE = MODULE .
me->ERROR_MESSAGE = ERROR_MESSAGE .
me->EXCEPTION = EXCEPTION .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_VCS__CALL_MODULE_ERROR .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
