interface zif_fc_aoc_puzzle_solver public.
  methods solve importing iv_puzzleinput  type zfc_de_puzzle_input
                returning value(r_result) type zfc_de_puzzle_result
                raising   zcx_fc_aoc.
endinterface.
