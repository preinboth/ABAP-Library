method read_object.

  data
  : ld_s__ujfdoc            type ujf_doc
  , lr_x__call_module_error type ref to zcx_vcs__call_module_error
  , ld_v__docname           type uj_docname
  , ld_s__xltp              type ty_s__xltp
  .

  ld_v__docname = i_s__tadir-obj_name.

  concatenate `\ROOT\WEBFOLDERS\` i_s__tadir-appset
                              `\` i_s__tadir-application
                              `\` `EEXCEL`
                              `\` i_s__tadir-obj_name into ld_v__docname.


  select single *
    from ujf_doc
    into corresponding fields of ld_s__xltp
    where appset  = i_s__tadir-appset
      and docname = ld_v__docname.

  ld_s__xltp-filename = ld_v__docname.

  select single *
    from ujf_doctree
    into corresponding fields of ld_s__xltp-doc_tree
    where appset  = i_s__tadir-appset
     and docname = ld_v__docname.

*  append ld_s__xltp-doc_content to ld_s__xltp-doc_contentt.


*  data str type string.
*  data str1 type string.
*  data ss type x length 255.
*  data st like standard table of ss.
*  data cnt type i.
*
*str1 = ld_s__xltp-doc_content+0.
*
*  do.
*    if cnt > strlen( str1 ).
*      exit.
*    endif.
*
*    ss = ld_s__xltp-doc_content+0.
*    append ss to st.
*    add 256 to cnt.
*
*  enddo.
*
*  ss = ld_s__xltp-doc_content.
*  append ss to st.
*
*  append ld_s__xltp-doc_content to st.
*
*  str = `c:\test\sdf.xlt`.
*  call method cl_gui_frontend_services=>gui_download
*    exporting
**      bin_filesize = l_xml_size
*      filename     = str
*      filetype     = 'BIN'
*    changing
*      data_tab     = st "l_xml_table
*    exceptions
*      others       = 24.

*      data    lt_data type standard table of x255.
*
*
*  call function 'SCMS_XSTRING_TO_BINARY'
*    exporting
*      buffer        = ld_s__xltp-doc_content
**    importing
**      output_length = lv_file_length
*    tables
*      binary_tab    = lt_data.
*
*
*  call method cl_gui_frontend_services=>gui_download
*    exporting
**      bin_filesize = l_xml_size
*      filename     = `c:\test\1.xlt`
*      filetype     = 'BIN'
*    changing
*      data_tab     =  lt_data "l_xml_table
*    exceptions
*      others       = 24.


  clear ld_s__xltp-doc_content.

  try.
*      call method zcl_vcs_bpc___tech=>zfm_get_bpc_lgf
*        exporting
*          i_appset      = i_s__tadir-appset
*          i_application = i_s__tadir-application
*          i_filename    = ld_v__docname
*        importing
*          e_doc         = ld_s__ujfdoc
*          et_lgf        = ld_s__sclo-source.

*      move-corresponding ld_s__ujfdoc to ld_s__sclo.
*      ld_s__sclo-application = i_s__tadir-application.

**********************************************************************
* Save TXT
**********************************************************************
      data ld_s__txtsource type zvcst_s__source_path.

      ld_s__txtsource-pathnode = `/DOC_CONTENTT`.
      append  ld_s__txtsource to e_t__txtsource.

*      ld_s__txtsource-pathnode = `/DOC_CONTENT_DB`.
*      append  ld_s__txtsource to e_t__txtsource.


*      data ld_s__txtsource type zvcst_s__source_path.
*
*      ld_s__txtsource-pathnode = `/SOURCE`.
**      ld_s__txtsource-pathname = `/METHODS/item/CMPKEY/CMPNAME`.
*      append  ld_s__txtsource to e_t__txtsource.

*      e_s__source = ld_s__sclo.
      e_s__source = ld_s__xltp.



    catch zcx_vcs__call_module_error into lr_x__call_module_error.
      raise exception type zcx_vcs_objects_read__bpc
        exporting
          previous       = lr_x__call_module_error
          object         = i_s__tadir-object
          obj_name       = i_s__tadir-obj_name
          appset_id      = i_s__tadir-appset
          application_id = i_s__tadir-application.
  endtry.

endmethod.
