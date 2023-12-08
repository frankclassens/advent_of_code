@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZFC_R_PUZ'
@ObjectModel.semanticKey: [ 'PuzzleID' ]
define root view entity ZFC_C_PUZ
  provider contract transactional_query
  as projection on ZFC_R_PUZ
{
  key PuzzleID,
  PuzzleInput,
  PuzzleResult,
  LocalLastChangedAt
  
}
