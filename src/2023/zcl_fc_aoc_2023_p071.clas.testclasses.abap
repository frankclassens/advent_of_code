class ltcl_test definition deferred.
class zcl_fc_aoc_2023_p071 definition local friends ltcl_test.
class ltcl_test definition final
  for testing risk level harmless duration short.

  private section.
    methods test_online_example for testing raising cx_static_check.
endclass.


class ltcl_test implementation.
  method test_online_example.
    data(lo_cut) = new zcl_fc_aoc_2023_p071( ).

    data(lv_test) = '32T3K 765' && cl_abap_char_utilities=>newline
                 && 'T55J5 684' && cl_abap_char_utilities=>newline
                 && 'KK677 28 ' && cl_abap_char_utilities=>newline
                 && 'KTJJT 220' && cl_abap_char_utilities=>newline
                 && 'QQQJA 483' && cl_abap_char_utilities=>newline.
    cl_abap_unit_assert=>assert_equals( exp = 6440
                                        act = lo_cut->zif_fc_aoc_puzzle_solver~solve( lv_test ) ).
  endmethod.
endclass.
