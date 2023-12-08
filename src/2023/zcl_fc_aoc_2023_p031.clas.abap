class zcl_fc_aoc_2023_p031 definition
  public
  inheriting from zcl_fc_aoc_puzzle_solver final
  create public.

  public section.
    methods zif_fc_aoc_puzzle_solver~solve redefinition.

  private section.
    methods get_horizontal_line_chars importing is_match           type match_result
                                                is_horizontal_line type string
                                      returning value(r_result)    type string.

    methods has_special_char importing iv_string       type string
                             returning value(r_result) type abap_boolean.
endclass.


class zcl_fc_aoc_2023_p031 implementation.
  method zif_fc_aoc_puzzle_solver~solve.
    data lt_match type match_result_tab.

    data(lt_string) = split_string_at_new_line( iv_puzzleinput ).

    data(lv_total) = 0.
    loop at lt_string assigning field-symbol(<ls_line>).
      data(lv_my_line_index) = sy-tabix.
      find all occurrences of pcre '\d+' in <ls_line> ignoring case results lt_match.
      loop at lt_match assigning field-symbol(<ls_match>).
        data(lv_number) = conv int4( substring( val = <ls_line>
                                                off = <ls_match>-offset
                                                len = <ls_match>-length ) ).

        data(lv_surrounding_chars) = conv string( '' ).

        " Create a string of all surrounding characters
        if lv_my_line_index > 1.
          data(ls_line_above) = lt_string[ lv_my_line_index - 1 ].
          data(lv_above) = get_horizontal_line_chars( is_match           = <ls_match>
                                                      is_horizontal_line = ls_line_above ).
          lv_surrounding_chars = lv_surrounding_chars && lv_above.
        endif.
        if lv_my_line_index < lines( lt_string ).
          data(ls_line_below) = lt_string[ lv_my_line_index + 1 ].
          data(lv_below) = get_horizontal_line_chars( is_match           = <ls_match>
                                                      is_horizontal_line = ls_line_below ).
          lv_surrounding_chars = lv_surrounding_chars && lv_below.
        endif.
        if <ls_match>-offset > 0.
          data(lv_prec) = substring( val = <ls_line>
                                     off = <ls_match>-offset - 1
                                     len = 1 ).
          lv_surrounding_chars = lv_surrounding_chars && lv_prec.
        endif.
        if <ls_match>-offset + <ls_match>-length < strlen( <ls_line> ).
          data(lv_subseq) = substring( val = <ls_line>
                                       off = <ls_match>-offset + <ls_match>-length
                                       len = 1 ).
          lv_surrounding_chars = lv_surrounding_chars && lv_subseq.
        endif.

        " Check if one of the chars is a special one.
        if has_special_char( lv_surrounding_chars ).
          lv_total += lv_number.
        endif.
      endloop.
    endloop.

    r_result = lv_total.
  endmethod.

  method get_horizontal_line_chars.
    data(lv_offset) = is_match-offset - 1.
    data(lv_length) = is_match-length + 2.
    if is_match-offset = 0.
      lv_offset = 0.
      lv_length -= 1.
    endif.
    if is_match-offset + is_match-length >= strlen( is_horizontal_line ).
      lv_length -= 1.
    endif.
    r_result = substring( val = is_horizontal_line
                          off = lv_offset
                          len = lv_length ).
  endmethod.

  method has_special_char.
    data(lv_allowed_chars) = '0123456789.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
    data(lv_offset) = find_any_not_of( val = iv_string
                                       sub = lv_allowed_chars ).
    if lv_offset >= 0.
      r_result = abap_true.
    endif.
  endmethod.
endclass.
