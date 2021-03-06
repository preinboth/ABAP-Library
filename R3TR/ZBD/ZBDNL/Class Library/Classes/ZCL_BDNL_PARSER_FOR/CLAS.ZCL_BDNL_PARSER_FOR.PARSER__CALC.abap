method parser__calc.

  constants
  : cs_for_found     type string value `FOR\sFOUND`
  , cs_for_not_found type string value `FOR\sNOT\sFOUND`
  .

  " имя таблицы для присвоения
  e_v__tablename = gr_o__cursor->get_token( esc = abap_true ).

  zcl_bdnl_container=>check_table( e_v__tablename ).

  e_f__found = abap_true.
  if gr_o__cursor->check_tokens( q = 2 regex = cs_for_found ) = abap_true.
    gr_o__cursor->get_token( esc = abap_true trn = 2 ).
    e_f__found = abap_true.
  elseif gr_o__cursor->check_tokens( q = 3 regex = cs_for_not_found ) = abap_true.
    gr_o__cursor->get_token( esc = abap_true trn = 3 ).
    e_f__found = abap_false.
  endif.

  if gr_o__cursor->get_token( esc = abap_true ) ne zblnc_keyword-dot.
    raise exception type zcx_bdnl_syntax_error
          exporting textid = zcx_bdnl_syntax_error=>zcx_expected
                    token  = zblnc_keyword-dot
                    index  = gr_o__cursor->gd_v__index .
  endif.

endmethod.
