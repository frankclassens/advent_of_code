class zcl_fc_aoc_2023_p071 definition
  public
  inheriting from zcl_fc_aoc_puzzle_solver final
  create public.

  public section.
    methods zif_fc_aoc_puzzle_solver~solve redefinition.

  private section.
    types:
      begin of enum camel_type,
        high_card,
        one_pair,
        two_pair,
        three_of_a_kind,
        full_hous,
        four_of_a_kind,
        five_of_a_kind,
      end of enum camel_type.
    types: begin of gty_card,
             id       type c length 1,
             strength type i,
           end of gty_card,
           gtt_card type standard table of gty_card with empty key.
    types: begin of gty_hand,
             cards    type c length 5,
             t_card   type gtt_card,
             bid      type int4,
             type     type camel_type,
             strength type int4,
             ranking  type int4,
             value    type int4,
           end of gty_hand.
    types gtt_hand type standard table of gty_hand with empty key.

    methods to_hand importing iv_string       type string
                    returning value(r_result) type gty_hand.

    methods determine_strength importing it_card         type zcl_fc_aoc_2023_p071=>gtt_card
                               returning value(r_result) type int4.

    methods determine_type importing it_card         type zcl_fc_aoc_2023_p071=>gtt_card
                           returning value(r_result) type camel_type.

    methods to_hands importing it_string       type string_table
                     returning value(r_return) type gtt_hand.

    methods get_card_strength importing iv_card         type string
                              returning value(r_result) type i.

    methods to_int importing iv_card         type string
                   returning value(r_result) type int4.

endclass.


class zcl_fc_aoc_2023_p071 implementation.
  method zif_fc_aoc_puzzle_solver~solve.
    data(lt_string) = split_string_at_new_line( iv_puzzleinput ).

    " Create hands
    data(lt_hand) = to_hands( lt_string ).
    sort lt_hand by type
                    strength.

    data(lv_total) = 0.
    loop at lt_hand assigning field-symbol(<ls_hand>).
      <ls_hand>-ranking = sy-tabix.
      <ls_hand>-value =  <ls_hand>-ranking * <ls_hand>-bid.
      lv_total = lv_total + <ls_hand>-value.
    endloop.

    r_result = lv_total.
  endmethod.

  method to_hands.
    loop at it_string assigning field-symbol(<ls_string>).
      append to_hand( <ls_string> ) to r_return.
    endloop.
  endmethod.

  method to_hand.
    data(lt_card) = value gtt_card( ).
    data(lv_offset) = 0.
    do 5 times.
      data(lv_card) = substring( val = iv_string
                                 off = lv_offset
                                 len = 1 ).
      data(lv_card_strength) = get_card_strength( lv_card ).
      append value #( id       = lv_card
                      strength = lv_card_strength ) to lt_card.
      lv_offset += 1.
    enddo.
    data(lv_len) = strlen( iv_string ) - 6.
    data(lv_bid) = conv int4( substring( val = iv_string
                                         off = 6
                                         len = lv_len ) ).
    data(lv_type) = determine_type( lt_card ).
    data(lv_hand_strength) = determine_strength( lt_card ).

    r_result = value #( cards    = substring( val = iv_string
                                              len = 5 )
                        t_card   = lt_card
                        type     = lv_type
                        strength = lv_hand_strength
                        bid      = lv_bid ).
  endmethod.

  method get_card_strength.
    r_result = switch #( iv_card
                         when 'T' then 10
                         when 'J' then 11
                         when 'Q' then 12
                         when 'K' then 13
                         when 'A' then 14
                         else          to_int( iv_card ) ).
  endmethod.

  method to_int.
    r_result = conv int4( iv_card ).
  endmethod.

  method determine_type.
    types: begin of lty_cnt,
             card type c length 1,
             cnt  type i,
           end of lty_cnt.
    types ltt_cnt type standard table of lty_cnt with empty key.
    data lt_cnt     type ltt_cnt.
    data lt_cnt_sub type ltt_cnt.

    lt_cnt = value ltt_cnt( ).
    loop at it_card assigning field-symbol(<ls_card>).
      if line_exists( lt_cnt[ card = <ls_card>-id ] ).
        lt_cnt[ card = <ls_card>-id ]-cnt += 1.
      else.
        append value #( card = <ls_card>-id
                        cnt  = 1 ) to lt_cnt.
      endif.
    endloop.

    " Check 5 of a kind
    lt_cnt_sub = value ltt_cnt( for ls_cnt in lt_cnt where ( cnt = 5 )
                                ( ls_cnt ) ).
    if lines( lt_cnt_sub ) > 0.
      r_result = zcl_fc_aoc_2023_p071=>five_of_a_kind.
      return.
    endif.

    " Check 4 of a kind
    lt_cnt_sub = value ltt_cnt( for ls_cnt in lt_cnt where ( cnt = 4 )
                                ( ls_cnt ) ).
    if lines( lt_cnt_sub ) > 0.
      r_result = zcl_fc_aoc_2023_p071=>four_of_a_kind.
      return.
    endif.

    " Check 3 of a kind / full house
    lt_cnt_sub = value ltt_cnt( for ls_cnt in lt_cnt where ( cnt = 3 )
                                ( ls_cnt ) ).
    if lines( lt_cnt_sub ) > 0.
      r_result = zcl_fc_aoc_2023_p071=>three_of_a_kind.
      " Check if it is a full house
      lt_cnt_sub = value ltt_cnt( for ls_cnt in lt_cnt where ( cnt = 2 )
                                  ( ls_cnt ) ).
      if lines( lt_cnt_sub ) > 0.
        r_result = zcl_fc_aoc_2023_p071=>full_hous.
      else.
        r_result = zcl_fc_aoc_2023_p071=>three_of_a_kind.
      endif.
      return.
    endif.

    " Check pairs
    lt_cnt_sub = value ltt_cnt( for ls_cnt in lt_cnt where ( cnt = 2 )
                                ( ls_cnt ) ).
    r_result = switch #( lines( lt_cnt_sub )
                         when 2 then zcl_fc_aoc_2023_p071=>two_pair
                         when 1 then zcl_fc_aoc_2023_p071=>one_pair
                         else        zcl_fc_aoc_2023_p071=>high_card ).
  endmethod.

  method determine_strength.
    data(lv_factor) = 14 * 14 * 14 * 14.
    loop at it_card assigning field-symbol(<ls_card>).
      r_result += <ls_card>-strength * lv_factor.
      lv_factor /= 14.
    endloop.
  endmethod.
endclass.
