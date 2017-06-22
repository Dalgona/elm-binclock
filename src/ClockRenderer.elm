module ClockRenderer exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, style)
import AppTypes exposing (..)
import Convert exposing (toBits, ChunkedList, Chunk)


render : Model -> Html Msg
render model =
  let
    digits = Convert.convertTime model.now

    unitSize = toFloat (min model.winSize.width model.winSize.height)

    contSize = unitSize * 0.6

    ledSize = unitSize * 0.08

  in
    div
      [ class "led-container"
      , style [ ("width", toString contSize ++ "px") ]
      ] (renderPart ledSize digits)


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

    temp = Convert.toBits [] num
    
    bits = temp ++ (List.repeat (count - List.length temp) 0)

  in
    List.map led bits
