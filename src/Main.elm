module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Color exposing (Color)
import Date exposing (Date, hour, minute, second)
import Task
import Time exposing (Time)
import Window exposing (Size)
import AppTypes exposing (..)
import ClockRenderer


main : Program Never Model Msg
main =
  Html.program
    { view = view
    , update = update
    , subscriptions = subscriptions
    , init = init
    }


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
  div []
    [ ClockRenderer.render model
    ]


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
  Model (Date.fromString "0000-01-01T00:00:00") (Size 0 0) Color.white


initCmd : Cmd Msg
initCmd =
  Cmd.batch
    [ Task.perform UpdateDate Date.now
    , Task.perform WinResize Window.size
    ]


init : (Model, Cmd Msg)
init =
  (initModel, initCmd)
