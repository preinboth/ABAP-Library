method prim.

  data
  : lr_o__container   type ref to zcl_bdnl_container
  , ld_s__stack       type zbnlt_s__container
  .

  while gr_o__cursor->gd_f__end ne abap_true.

    case gr_o__cursor->get_token( esc = abap_true ).

*--------------------------------------------------------------------*
* $SELECT
*--------------------------------------------------------------------*
      when zblnc_keyword-select. " SELECT

        call method select_statements
          importing
            e_o__container = lr_o__container
            e_v__tablename = ld_s__stack-tablename.

        lr_o__container->set_command( zblnc_keyword-select ).
        ld_s__stack-container = lr_o__container.
        append ld_s__stack to gd_t__stack.

*--------------------------------------------------------------------*
* $CLEAR
*--------------------------------------------------------------------*
      when zblnc_keyword-clear.

        call method clear_statements
          importing
            e_v__tablename = ld_s__stack-tablename
            e_o__container = lr_o__container.

        lr_o__container->set_command( zblnc_keyword-clear ).
        ld_s__stack-container = lr_o__container.
        append ld_s__stack to gd_t__stack.

*--------------------------------------------------------------------*
* $TABLE
*--------------------------------------------------------------------*
      when zblnc_keyword-ctable.

        call method table_statements
          importing
*            e_s__stack     = ld_s__stack
            e_o__container = lr_o__container
            e_v__tablename = ld_s__stack-tablename.

        ld_s__stack-container = lr_o__container.
        append ld_s__stack to gd_t__stack.

      when zblnc_keyword-containers.
        if gr_o__cursor->get_token( esc = abap_true ) = zblnc_keyword-end.
          if gr_o__cursor->get_token( esc = abap_true  ) = zblnc_keyword-dot.
            exit.
          else.
            raise exception type zcx_bdnl_syntax_error
                  exporting textid    = zcx_bdnl_syntax_error=>zcx_expected
                            expected  = zblnc_keyword-dot
                            index     = gr_o__cursor->gd_v__cindex .
          endif.
        else.
          raise exception type zcx_bdnl_syntax_error
                exporting textid    = zcx_bdnl_syntax_error=>zcx_after_containers
                          expected  = zblnc_keyword-end
                          index     = gr_o__cursor->gd_v__cindex .
        endif.

*--------------------------------------------------------------------*
* OTHERS - ERROR
*--------------------------------------------------------------------*
      when others.
        raise exception type zcx_bdnl_syntax_error
              exporting textid = zcx_bdnl_syntax_error=>zcx_unable_interpret
                        token  = gr_o__cursor->gd_v__ctoken
                        index  = gr_o__cursor->gd_v__cindex .
    endcase.
  endwhile.

endmethod.
