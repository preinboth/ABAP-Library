method read_objects_choose.

  types: begin of ty_s__ujf_doc.
  include type ujf_doc.
  types: application type uj_appl_id.
  types: filename    type uj_docname.
  types: index type i.
  types: end of ty_s__ujf_doc.

  data
  : ld_t__application type zvcst_t__application
  , ld_s__appl        type line of zvcst_t__application
  , ld_t__docs        type standard table of ty_s__ujf_doc with non-unique default key
  , ld_s__choose      type ty_s__checkobj_sclo
  , ld_t__choose      type standard table of ty_s__checkobj_sclo
  , ld_t__splitdoc    type table of string
  , ld_v__string      type  string
  , ld_s_function     type svalp
  , ld_t__functions   type standard table of svalp
  , ld_v__index       type i
  , ld_s__sclo       type ty_s__sclo
  .

  field-symbols
  : <ld_s__docs>      type ty_s__ujf_doc
  , <ld_s__choose>    type ty_s__checkobj_sclo
  .

  check CD_F__LGF = abap_true.

  select *
    into  corresponding fields of table ld_t__docs
         from ujf_doc
         where appset       in cd_r__appset_id
           and doctype      eq `LGF`
           and compression  ne `X`.

  loop at ld_t__docs assigning <ld_s__docs>.

    ld_s__choose-index = <ld_s__docs>-index = sy-tabix.
    ld_s__choose-type            = zvcsc_bpc_type-sclo.
    ld_s__choose-component       = zvcsc_bpc.
    ld_s__choose-appset          = <ld_s__docs>-appset.

    clear ld_t__splitdoc.
    split <ld_s__docs>-docname at `\` into table ld_t__splitdoc.

    read table ld_t__splitdoc index 6 into ld_s__choose-application.
    <ld_s__docs>-application = ld_s__choose-application.


    if not ld_s__choose-application in  cd_r__appl_id.
      delete ld_t__docs.
      continue.
    endif.

    read table ld_t__splitdoc index 7 into ld_s__choose-template.
    <ld_s__docs>-filename = ld_s__choose-template.

    append ld_s__choose to ld_t__choose.
  endloop.

  check lines( ld_t__choose ) > 0.

  move
  : 'OK'            to ld_s_function-func_name
  , sy-cprog        to ld_s_function-prog_name
  , i_v__form_name  to ld_s_function-form_name.

  append ld_s_function to ld_t__functions.

  call function 'POPUP_GET_SELECTION_FROM_LIST'
    exporting
      display_only                 = 'X'
      table_name                   = `ZVCS_ST__BPCSSCLO`
      title_bar                    = 'Selection'
    tables
      list                         = ld_t__choose
      functions                    = ld_t__functions
    exceptions
      no_tablefields_in_dictionary = 1
      no_table_structure           = 2
      no_title_bar                 = 3
      others                       = 4.

  if sy-subrc <> 0.
    message id sy-msgid type 'E' number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

  loop at ld_t__choose assigning <ld_s__choose>.

    check <ld_s__choose>-checkbox <> abap_true.
    ld_v__index = <ld_s__choose>-index.
    delete ld_t__docs where index = ld_v__index.

  endloop.

  loop at ld_t__docs assigning <ld_s__docs>.

    move-corresponding <ld_s__docs> to ld_s__sclo.
    append ld_s__sclo to gd_t__sclo.

  endloop.

endmethod.
