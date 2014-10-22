method prim.

  constants
  : cs_dimension            type string value `^(([A-Z0-9\_]+)\>|\/(CPMB)\/([A-Z0-9\_]+)\>)`
  , cs_dimwattr             type string value `^\~\<([A-Z0-9\_]+)\>`
  , cs_func                 type string value `^([A-Z0-9\_]+)\>\s\(`
  .

  data
  : ld_v__token             type string
  , ld_s__container         type zbnlt_s__stack_container
  , ld_s__container_tg      type zbnlt_s__stack_container
  , ld_s__custlink          type zbnlt_s__cust_link
  , ld_t__custlink          type zbnlt_t__cust_link
  , ld_v__string            type string
  , ld_f__dimension         type rs_bool
  , ld_f__signeddata        type rs_bool
  , ld_t__check             type zbnlt_t__stack_check
  , ld_v__turn              type i
  .

  gd_s__assign-tablename = gd_v__tablename.

*  read table gd_t__containers
*       with key tablename = gd_s__assign-tablename
*       into ld_s__container_tg.

  ld_s__container_tg = zcl_bdnl_container=>check_table( gd_s__assign-tablename ).

*  if sy-subrc ne 0.
*    raise exception type zcx_bdnl_syntax_error
*            exporting textid = zcx_bdnl_syntax_error=>zcx_table_not_defined
*                      token  = gd_s__assign-tablename
*                      index  = gr_o__cursor->gd_v__index .
*  endif.

  while gr_o__cursor->gd_f__end ne abap_true.

    if gr_o__cursor->get_token( ) = zblnc_keyword-check.
      add 1 to ld_v__turn.
*      break-point.
      gr_o__cursor->get_token( esc = abap_true ).
      check_expr( get = abap_false i_v__turn = ld_v__turn ).
      append lines of gd_t__check to gd_s__assign-check.
      clear gd_t__check.
      continue.
    endif.

    if gr_o__cursor->get_token( ) = zblnc_keyword-calc.
      gr_o__cursor->get_token( esc = abap_true ).
      if gr_o__cursor->get_token(  ) = zblnc_keyword-end.
        gr_o__cursor->get_token( esc = abap_true ).
        if gr_o__cursor->get_token(  ) = zblnc_keyword-dot.
          gr_o__cursor->get_token( esc = abap_true ).
          exit.
        else.
          raise exception type zcx_bdnl_syntax_error
                exporting textid    = zcx_bdnl_syntax_error=>zcx_expected
                          expected  = zblnc_keyword-dot
                          index     = gr_o__cursor->gd_v__index .
        endif.
      else.
        raise exception type zcx_bdnl_syntax_error
              exporting textid    = zcx_bdnl_syntax_error=>zcx_after_filters
                        expected  = zblnc_keyword-end
                        index     = gr_o__cursor->gd_v__index .
      endif.
    endif.

    clear
    : ld_s__custlink
    , ld_f__dimension
    , ld_f__signeddata
    .

    if gr_o__cursor->check_tokens( q = 1 regex = cs_dimension ) = abap_true.

      if ld_s__container_tg-tablename = gd_v__for_table.
        if ld_s__container_tg-type_table = zblnc_keyword-hashed.
          raise exception type zcx_bdnl_syntax_error
                 exporting textid = zcx_bdnl_syntax_error=>zcx_hashed_not_change
                           tablename = ld_s__container-tablename
                           index  = gr_o__cursor->gd_v__index .
        endif.
      endif.


      ld_f__dimension = abap_true.
      ld_s__custlink-tg-dimension = gr_o__cursor->get_token( esc = abap_true ).

      if gr_o__cursor->check_tokens( q = 2 regex = cs_dimwattr ) = abap_true.
        ld_s__custlink-tg-attribute = gr_o__cursor->get_token( esc = abap_true trn = 2 ).

        "check dimension and attribute
        read table ld_s__container_tg-dimension
             with key dimension = ld_s__custlink-tg-dimension
                      attribute = ld_s__custlink-tg-attribute
                      transporting no fields.

        if sy-subrc ne 0.
          concatenate ld_s__custlink-tg-dimension `~` ld_s__custlink-tg-attribute
                  into ld_v__string.
          raise exception type zcx_bdnl_syntax_error
                exporting textid = zcx_bdnl_syntax_error=>zcx_no_component_exists
                          token  = ld_v__string
                          tablename = gd_s__assign-tablename
                          index  = gr_o__cursor->gd_v__index .
        endif.
      else.
        "check dimension
        read table ld_s__container_tg-dimension
             with key dimension = ld_s__custlink-tg-dimension
             transporting no fields.

        if sy-subrc ne 0.
          ld_v__string = ld_s__custlink-tg-dimension.
          raise exception type zcx_bdnl_syntax_error
                exporting textid = zcx_bdnl_syntax_error=>zcx_no_component_exists
                          token  = ld_v__string
                          tablename = gd_s__assign-tablename
                          index  = gr_o__cursor->gd_v__index .
        endif.
      endif.
    elseif gr_o__cursor->get_token( ) = zblnc_keyword-signeddata.
      gr_o__cursor->get_token( esc = abap_true ).

      ld_f__signeddata = abap_true.
    else.
      ld_v__token = gr_o__cursor->get_token( ).
      raise exception type zcx_bdnl_syntax_error
            exporting textid = zcx_bdnl_syntax_error=>zcx_unable_interpret
                      token  = ld_v__token
                      index  = gr_o__cursor->gd_v__index .
    endif.

    if gr_o__cursor->get_token( esc = abap_true ) = zblnc_keyword-equal.

      case abap_true.
        when ld_f__dimension.
          if gr_o__cursor->check_tokens( q = 2 regex = cs_func ) = abap_true. " Если функция
            call method process_function
              importing
                e_v__funcname = ld_s__custlink-func_name
                e_t__param    = ld_s__custlink-param
                e_r__data     = ld_s__custlink-data.
          else.
            if gr_o__cursor->check_letter( )   = abap_true or
               gr_o__cursor->check_variable( ) = abap_true.
              ld_s__custlink-const = gr_o__cursor->get_token( esc = abap_true ).
            elseif gr_o__cursor->get_token( ) = zblnc_keyword-cspace.
              gr_o__cursor->get_token( esc = abap_true ).
              ld_s__custlink-clear = abap_true.
            else.
              ld_s__custlink-tablename = gr_o__cursor->get_token( esc = abap_true ).
              ld_s__container = zcl_bdnl_container=>check_table( ld_s__custlink-tablename ).

*              read table gd_t__containers
*                   with key tablename = ld_s__custlink-tablename
*                   into ld_s__container.
*
*              if sy-subrc ne 0.
*                raise exception type zcx_bdnl_syntax_error
*                        exporting textid = zcx_bdnl_syntax_error=>zcx_table_not_defined
*                                  token  = ld_s__custlink-tablename
*                                  index  = gr_o__cursor->gd_v__index .
*              endif.
*
*              gr_o__cursor->get_token( esc = abap_true ).

              if gr_o__cursor->get_token( ) = zblnc_keyword-tilde.
                gr_o__cursor->get_token( esc = abap_true ).

                if gr_o__cursor->check_tokens( q = 1 regex = cs_dimension ) = abap_true.
                  ld_s__custlink-sc-dimension = gr_o__cursor->get_token( esc = abap_true ).

                  if gr_o__cursor->check_tokens( q = 2 regex = cs_dimwattr ) = abap_true.
                    ld_s__custlink-sc-attribute = gr_o__cursor->get_token( esc = abap_true trn = 2 ).

                    "check dimension and attribute
                    read table ld_s__container-dimension
                         with key dimension = ld_s__custlink-sc-dimension
                                  attribute = ld_s__custlink-sc-attribute
                                  transporting no fields.

                    if sy-subrc ne 0.
                      concatenate ld_s__custlink-sc-dimension `~` ld_s__custlink-sc-attribute
                              into ld_v__string.
                      raise exception type zcx_bdnl_syntax_error
                            exporting textid = zcx_bdnl_syntax_error=>zcx_no_component_exists
                                      token  = ld_v__string
                                      tablename = ld_s__custlink-tablename
                                      index  = gr_o__cursor->gd_v__index .
                    endif.
                  else.
                    "check dimension
                    read table ld_s__container-dimension
                         with key dimension = ld_s__custlink-sc-dimension
                                  attribute = space
                         transporting no fields.

                    if sy-subrc ne 0.
                      ld_v__string = ld_s__custlink-sc-dimension.
                      raise exception type zcx_bdnl_syntax_error
                            exporting textid = zcx_bdnl_syntax_error=>zcx_no_component_exists
                                      token  = ld_v__string
                                      tablename = ld_s__custlink-tablename
                                      index  = gr_o__cursor->gd_v__index .
                    endif.
                  endif.
                else.
                  ld_v__token = gr_o__cursor->get_token( ).
                  raise exception type zcx_bdnl_syntax_error
                        exporting textid = zcx_bdnl_syntax_error=>zcx_unable_interpret
                                  token  = ld_v__token
                                  index  = gr_o__cursor->gd_v__index .
                endif.
              else.
                raise exception type zcx_bdnl_syntax_error
                      exporting textid = zcx_bdnl_syntax_error=>zcx_expected
                                token  = zblnc_keyword-equal
                                index  = gr_o__cursor->gd_v__index .
              endif.
            endif.

          endif.

          append ld_s__custlink to ld_t__custlink.
          clear ld_s__custlink.

        when ld_f__signeddata.
          call method math
            importing
              e_t__varible = gd_s__assign-variables
              e_v__exp     = gd_s__assign-exp.
      endcase.

    else.
      raise exception type zcx_bdnl_syntax_error
        exporting textid    = zcx_bdnl_syntax_error=>zcx_expected
                  expected  = zblnc_keyword-equal
                  index     = gr_o__cursor->gd_v__index .
    endif.

    if gr_o__cursor->get_token( esc = abap_true ) ne zblnc_keyword-dot.
      raise exception type zcx_bdnl_syntax_error
            exporting textid    = zcx_bdnl_syntax_error=>zcx_expected
                      expected  = zblnc_keyword-dot
                      index     = gr_o__cursor->gd_v__index .
    endif.
  endwhile.

  gd_s__assign-link = ld_t__custlink.

endmethod.
