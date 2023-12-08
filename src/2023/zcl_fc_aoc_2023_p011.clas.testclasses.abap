class ltcl_test definition deferred.
class ZCL_FC_AOC_2023_P011 definition local friends ltcl_test.
class ltcl_test definition final
  for testing risk level harmless duration short.

  private section.
    methods test_online_example for testing raising cx_static_check.
endclass.


class ltcl_test implementation.
  method test_online_example.
    data(lo_cut) = new zcl_fc_aoc_2023_p011( ).

    data(lv_test) = '1abc2' && cl_abap_char_utilities=>newline
    && 'pqr3stu8vwx' && cl_abap_char_utilities=>newline
    && 'a1b2c3d4e5f' && cl_abap_char_utilities=>newline
    && 'treb7uchet' && cl_abap_char_utilities=>newline.
    cl_abap_unit_assert=>assert_equals(
        exp = 142
        act = lo_cut->zif_fc_aoc_puzzle_solver~solve( lv_test ) ).
  endmethod.
endclass.
