method SET_PC_TYPE.
  CALL METHOD CL_UJD_CUSTOM_TYPE=>SET_PC_TYPE
  EXPORTING
    I_TYPE = 'ZBDTECHSRV'.
endmethod.
