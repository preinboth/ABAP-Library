method select_statements.

  data
  : ld_v__index         type i
  , ld_s__stack	        type zbnlt_s__stack_container
  .

  clear ld_s__stack.

  " обязательные парметры
  ld_v__index = gr_o__cursor->gd_v__index.

*--------------------------------------------------------------------*
* $FROM
*--------------------------------------------------------------------*
  if gr_o__cursor->set_cursor( word = zblnc_keyword-from escape = zblnc_keyword-dot fesc = abap_true ) eq err_index.
    raise exception type zcx_bdnl_syntax_error
          exporting textid = zcx_bdnl_syntax_error=>zcx_after_select
                    expected = `$FROM ...`
                    index  = gr_o__cursor->gd_v__cindex.
  endif.

  call method cmd_from
    importing
      e_appset_id = ld_s__stack-appset_id
      e_appl_id   = ld_s__stack-appl_id
      e_dim_name  = ld_s__stack-dim_name
      e_appl_obj  = ld_s__stack-appl_obj
      e_dist      = ld_s__stack-destination.

  gr_o__cursor->set_token_pos( ld_v__index ).

*--------------------------------------------------------------------*
* $INTO
*--------------------------------------------------------------------*
  call method select_param_into
    importing
      e_v__type_table = ld_s__stack-type_table
      e_v__tablename  = ld_s__stack-tablename.

  e_v__tablename = ld_s__stack-tablename.
  gr_o__cursor->set_token_pos( ld_v__index ).

*--------------------------------------------------------------------*
* $SELECT
*--------------------------------------------------------------------*
  call method select_param_fields
    exporting
      i_appset_id          = ld_s__stack-appset_id
      i_appl_id            = ld_s__stack-appl_id
      i_v__type_table      = ld_s__stack-type_table
      i_appl_obj           = ld_s__stack-appl_obj
    importing
      e_t__alias           = ld_s__stack-alias
      e_t__dimlist         = ld_s__stack-dim_list
      e_t__key_list        = ld_s__stack-kyf_list
      e_v__tech_type_table = ld_s__stack-tech_type_table
      e_t__dimension       = ld_s__stack-dimension
      e_f__write           = ld_s__stack-f_write.

*--------------------------------------------------------------------*
* $WHERE - не обязательный параметр
*--------------------------------------------------------------------*
  if gr_o__cursor->get_token( ) = zblnc_keyword-where. " WHERE
    gr_o__cursor->get_token( esc = abap_true ).
    call method select_param_where
      exporting
        i_appset_id = ld_s__stack-appset_id
        i_appl_id   = ld_s__stack-appl_id
        i_appl_obj  = ld_s__stack-appl_obj
      importing
        e_t__range  = ld_s__stack-range.
  endif.

*--------------------------------------------------------------------*
* $NOTSUPRESS
*--------------------------------------------------------------------*
  if gr_o__cursor->get_token( ) = zblnc_keyword-notsupress.
    gr_o__cursor->get_token( esc = abap_true ).
    if gr_o__cursor->get_token( esc = abap_true ) = zblnc_keyword-zero.
      ld_s__stack-notsupresszero = abap_true.
    else.
      raise exception type zcx_bdnl_syntax_error
      exporting textid    = zcx_bdnl_syntax_error=>zcx_expected
                expected  = zblnc_keyword-zero
                index     = gr_o__cursor->gd_v__cindex .
    endif.
  endif.


  if gr_o__cursor->get_token( esc = abap_true ) ne zblnc_keyword-dot.
    raise exception type zcx_bdnl_syntax_error
          exporting textid    = zcx_bdnl_syntax_error=>zcx_expected
                    expected  = zblnc_keyword-dot
                    index     = gr_o__cursor->gd_v__cindex .
  endif.

  e_o__container = zcl_bdnl_container=>get_table( ld_s__stack ).

endmethod.
