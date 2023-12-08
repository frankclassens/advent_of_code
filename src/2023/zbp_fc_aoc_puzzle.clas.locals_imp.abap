class lcl_handler definition inheriting from cl_abap_behavior_handler.
  private section.
    methods get_global_authorizations for global authorization
      importing
                 request requested_authorizations for puzzle
              result result.

    methods solve for modify
      importing keys for action puzzle~solve result result.

    methods get_puzzle_solver importing iv_puzzle_id    type zfc_de_puzzle_id
                              returning value(r_result) type ref to zif_fc_aoc_puzzle_solver
                              raising   zcx_fc_aoc.
endclass.


class lcl_handler implementation.
  method get_global_authorizations.
  endmethod.

  method solve.
    try.
        read entities of zfc_r_puz in local mode
             entity puzzle
             all fields with
             corresponding #( keys )
             result data(puzzles_in).

        modify entities of zfc_r_puz in local mode
               entity puzzle
               update set fields with value #(
                   for ls_puzzle_in in puzzles_in
                   ( %key         = ls_puzzle_in-%key
                     %is_draft    = ls_puzzle_in-%is_draft
                     puzzleresult = get_puzzle_solver( ls_puzzle_in-puzzleid )->solve( ls_puzzle_in-puzzleinput ) ) )
               failed failed
               reported reported.

        " Read changed data for action result
        read entities of zfc_r_puz in local mode
             entity puzzle
             all fields with
             corresponding #( keys )
             result data(puzzle_out).

        result = value #( for ls_puzzle_out in puzzle_out
                          ( %tky   = ls_puzzle_out-%tky
                            %param = ls_puzzle_out ) ).
      catch zcx_fc_aoc into data(lx_solve).
        data(ls_symsg) = cl_message_helper=>get_t100_for_object(
                             cl_message_helper=>get_latest_t100_exception( lx_solve ) ).

        failed-puzzle = value #( for ls_failed_key in keys
                                 ( %key     = ls_failed_key-%key
                                   puzzleid = ls_failed_key-puzzleid ) ).
        reported-puzzle = value #( for ls_reported_key in keys
                                   ( %key = ls_reported_key-%key
                                     %msg = new_message( id       = ls_symsg-msgid
                                                         number   = ls_symsg-msgno
                                                         severity = if_abap_behv_message=>severity-error
                                                         v1       = ls_symsg-msgv1
                                                         v2       = ls_symsg-msgv2
                                                         v3       = ls_symsg-msgv3
                                                         v4       = ls_symsg-msgv4 ) ) ).

    endtry.
  endmethod.

  method get_puzzle_solver.
    data lv_char3 type c length 3.

    try.
        lv_char3 = iv_puzzle_id.
        data(lv_puzzle_id) = |{ lv_char3 alpha = in }|.
        data(lv_classname) = |ZCL_FC_AOC_2023_P{ lv_puzzle_id }|.
        create object r_result type (lv_classname).
      catch cx_sy_create_object_error.
        raise exception type zcx_fc_aoc message e002(zfc_aoc) with lv_classname.
    endtry.
  endmethod.
endclass.
