import Html exposing (..)
import Html.Attributes exposing (class, style)
import Date exposing (Date, hour, minute, second)
import Result
import Task
import Time exposing (Time)
import Window exposing (Size)


main =
  Html.program
    { view = view
    , update = update
    , subscriptions = subscriptions
    , init = init
    }


-- MODEL

type alias Model =
  { now : Result String Date
  , winSize : Size
  }


-- UPDATE

type Msg
  = Tick Time
  | UpdateDate Date
  | WinResize Size


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick _ ->
      (model, Task.perform UpdateDate Date.now)

    UpdateDate newDate ->
      ({ model | now = Ok newDate }, Cmd.none)

    WinResize newSize ->
      ({ model | winSize = newSize }, Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  let
    digits =
      model.now
        |> extractTime
        |> transformTime
        |> chunkList []

    unitSize = toFloat (min model.winSize.width model.winSize.height)

    contSize = unitSize * 0.6

    ledSize = unitSize * 0.08

  in
    div []
      [ text (toString digits)
      , div
          [ class "led-container"
          , style [ ("width", toString contSize ++ "px") ]
          ] (renderPart ledSize digits)
      ]


renderPart : Float -> ChunkedList -> List (Html Msg)
renderPart size digits =
  List.map (\x -> div [ class "time-part" ] (renderDigit size x)) digits


renderDigit : Float -> Chunk -> List (Html Msg)
renderDigit size chunk =
  List.map (\x -> div [ class "digit" ] (renderLEDs size x) ) chunk


renderLEDs : Float -> (Int, Int) -> List (Html Msg)
renderLEDs size (count, num) =
  let
    borderSize = size * 0.1

    ledStyle =
      style
        [ ( "width", toString size ++ "px" )
        , ( "height", toString size ++ "px" )
        , ( "border-width", toString borderSize ++ "px" )
        ]

    led = \bit -> div [ class ("led led-" ++ toString bit) , ledStyle ] []

    temp = toBits [] num
    
    bits = temp ++ (List.repeat (count - List.length temp) 0)

  in
    List.map led bits


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


type alias Chunk = List (Int, Int)

type alias ChunkedList = List Chunk

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


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Time.every Time.second Tick
    , Window.resizes WinResize
    ]


-- INIT

initModel : Model
initModel =
  Model (Date.fromString "0000-01-01T00:00:00") (Size 0 0)


initCmd : Cmd Msg
initCmd =
  Cmd.batch
    [ Task.perform UpdateDate Date.now
    , Task.perform WinResize Window.size
    ]


init : (Model, Cmd Msg)
init =
  (initModel, initCmd)
