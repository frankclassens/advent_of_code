class ltcl_test definition deferred.
class ZCL_FC_AOC_2023_P031 definition local friends ltcl_test.
class ltcl_test definition final
  for testing risk level harmless duration short.

  private section.
    methods test_online_example for testing raising cx_static_check.
endclass.


class ltcl_test implementation.
  method test_online_example.
    data(lo_cut) = new zcl_fc_aoc_2023_p031( ).

    data(lv_test) = '467..114..' && cl_abap_char_utilities=>newline
                 && '...*......' && cl_abap_char_utilities=>newline
                 && '..35..633.' && cl_abap_char_utilities=>newline
                 && '......#...' && cl_abap_char_utilities=>newline
                 && '617*......' && cl_abap_char_utilities=>newline
                 && '.....+.58.' && cl_abap_char_utilities=>newline
                 && '..592.....' && cl_abap_char_utilities=>newline
                 && '......755.' && cl_abap_char_utilities=>newline
                 && '...$.*....' && cl_abap_char_utilities=>newline
                 && '.664.598..' && cl_abap_char_utilities=>newline.
    cl_abap_unit_assert=>assert_equals(
        exp = 4361
        act = lo_cut->zif_fc_aoc_puzzle_solver~solve( lv_test ) ).


    data(lv_test2) = '467..114..' && cl_abap_char_utilities=>newline
                  && '...*...123' && cl_abap_char_utilities=>newline
                  && '..35..633.' && cl_abap_char_utilities=>newline.
    cl_abap_unit_assert=>assert_equals(
        exp = 502
        act = lo_cut->zif_fc_aoc_puzzle_solver~solve( lv_test2 ) ).
  endmethod.
endclass.
