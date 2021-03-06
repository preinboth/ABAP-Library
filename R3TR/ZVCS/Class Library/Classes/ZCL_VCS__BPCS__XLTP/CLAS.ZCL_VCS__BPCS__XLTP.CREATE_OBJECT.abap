method create_object.

  data
  : ld_s__ujf_doc         type ujf_doc
  , ld_s__ujf_doctree     type ujf_doctree
  , gd_v__tmstp           type tzntstmpl
  , gd_v__time            type string
  , gd_v__date            type string
  , ld_v__line            type i
  , ld_v__offset          type i
  , ld_s__doc_content     type ty_s__content
  .

  field-symbols
  : <ls_s__xltp>     type ty_s__xltp
  .

  loop at gd_t__xltp assigning <ls_s__xltp>.

    clear
    : ld_s__ujf_doc
    , ld_s__ujf_doctree
    .

    move-corresponding <ls_s__xltp>          to ld_s__ujf_doc.
    move-corresponding <ls_s__xltp>-doc_tree to ld_s__ujf_doctree.

    ld_s__ujf_doctree-appset  = <ls_s__xltp>-appset.
    ld_s__ujf_doctree-docname = <ls_s__xltp>-docname.
    ld_s__ujf_doctree-docdesc = <ls_s__xltp>-docdesc.

    if cd_v__appset_id is not initial.
      replace all occurrences of <ls_s__xltp>-appset in
      : ld_s__ujf_doc-appset  with cd_v__appset_id
      , ld_s__ujf_doc-docname with cd_v__appset_id
      , ld_s__ujf_doc-docdesc with cd_v__appset_id
      .

      replace all occurrences of <ls_s__xltp>-appset in
      : ld_s__ujf_doctree-appset    with cd_v__appset_id
      , ld_s__ujf_doctree-docname   with cd_v__appset_id
      , ld_s__ujf_doctree-docdesc   with cd_v__appset_id
      , ld_s__ujf_doctree-parentdoc with cd_v__appset_id
      .
    endif.

    call method cl_gui_frontend_services=>gui_upload
      exporting
        filename   = <ls_s__xltp>-content
        filetype   = 'BIN'
      importing
        filelength = ld_s__doc_content-file_length
      changing
        data_tab   = ld_s__doc_content-content
      exceptions
        others     = 24.

    call function 'SCMS_BINARY_TO_XSTRING'
      exporting
        input_length = ld_s__doc_content-file_length
      importing
        buffer       = ld_s__ujf_doc-doc_content
      tables
        binary_tab   = ld_s__doc_content-content.


    modify ujf_doc     from ld_s__ujf_doc.
    modify ujf_doctree from ld_s__ujf_doctree.

  endloop.

endmethod.
