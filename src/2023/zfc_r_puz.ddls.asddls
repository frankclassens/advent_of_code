@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED #'
define root view entity ZFC_R_PUZ
  as select from zfc_aoc_a_puz as Puzzle
{
  key puzzle_id             as PuzzleID,
      puzzle_input          as PuzzleInput,
      puzzle_result         as PuzzleResult,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt

}
