class zcl_fc_aoc_puzzle_solver definition public abstract.
  public section.
    interfaces zif_fc_aoc_puzzle_solver.

  protected section.
    methods split_string_at_new_line importing iv_puzzleinput   type zfc_de_puzzle_input
                                     returning value(rt_string) type string_table
                                     raising   zcx_fc_aoc.

  private section.
endclass.


class zcl_fc_aoc_puzzle_solver implementation.
  method split_string_at_new_line.
    split iv_puzzleinput at cl_abap_char_utilities=>newline into table rt_string in character mode.
  endmethod.

  method zif_fc_aoc_puzzle_solver~solve.
    raise exception type zcx_fc_aoc message e001(zfc_aoc).
  endmethod.
endclass.
