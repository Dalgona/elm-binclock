module Convert exposing (convertTime, toBits, Chunk, ChunkedList)
import Date exposing (Date, hour, minute, second)


type alias Chunk = List (Int, Int)
type alias ChunkedList = List Chunk


convertTime : Result a Date -> ChunkedList
convertTime =
  chunkList [] << transformTime << extractTime


extractTime : Result a Date -> List Int
extractTime dateResult =
  case dateResult of
    Ok date ->
      [ hour date, minute date, second date ]

    Err _ ->
      [ 0, 0, 0 ]


transformTime : List Int -> List (Int, Int)
transformTime extractedTime =
  extractedTime
    |> List.concatMap (\x -> [ x // 10, rem x 10 ])
    |> List.map2 (,) [ 2, 4, 3, 4, 3, 4 ]


chunkList : ChunkedList -> Chunk -> ChunkedList
chunkList acc transformedTime =
  case transformedTime of
    [] ->
      List.reverse acc

    list ->
      chunkList ((List.take 2 list) :: acc) (List.drop 2 list)


toBits : List Int -> Int -> List Int
toBits acc num =
  case (acc, num) of
    ([], 0) ->
      [ 0 ]

    (acc, 0) ->
      List.reverse acc

    (acc, n) ->
      toBits (rem num 2 :: acc) (num // 2)
