class zcl_fc_aoc_2023_p011 definition
  public
  inheriting from zcl_fc_aoc_puzzle_solver final
  create public.

  public section.
    methods zif_fc_aoc_puzzle_solver~solve redefinition.

  private section.

endclass.


class zcl_fc_aoc_2023_p011 implementation.
  method zif_fc_aoc_puzzle_solver~solve.
    data(lt_string) = split_string_at_new_line( iv_puzzleinput ).

    data(lv_total) = 0.
    loop at lt_string assigning field-symbol(<ls_string>).
      " Find first digit
      data(lv_offset_first) = find_any_of( val = <ls_string>
                                           sub = '0123456789' ).
      data(lv_first_digit) = conv int1( substring( val = <ls_string>
                                                   off = lv_offset_first
                                                   len = 1 ) ).

      " Find last digit
      data(lv_current_offset) = 0.
      do 10 times.
        lv_current_offset = find_any_of( val = <ls_string>
                                         sub = '0123456789'
                                         off = lv_current_offset ).
        if lv_current_offset = -1.
          exit.
        endif.
        data(lv_last_digit) = conv int1( substring( val = <ls_string>
                                                    off = lv_current_offset
                                                    len = 1 ) ).
        lv_current_offset += 1.
      enddo.

      lv_total += ( lv_first_digit * 10 ) + lv_last_digit.
    endloop.

    r_result = lv_total.
  endmethod.
endclass.
