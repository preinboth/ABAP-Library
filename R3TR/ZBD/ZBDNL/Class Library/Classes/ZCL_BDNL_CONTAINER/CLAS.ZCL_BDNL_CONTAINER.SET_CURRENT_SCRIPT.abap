method set_current_script.

  cd_v__short_script = script.

  add 1 to cd_v__n_script.

  concatenate appset_id `/` appl_id `/` script into cd_v__current_script.

endmethod.
