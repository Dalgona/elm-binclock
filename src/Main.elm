module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, id, style)
import Date exposing (Date, hour, minute, second)
import Task
import Time exposing (Time)
import Window exposing (Size)
import AppTypes exposing (..)
import ClockRenderer
import SettingsUI


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

    ToggleSettings ->
      ({ model | settingsOpen = not model.settingsOpen }, Cmd.none)

    ChangeBG comp val ->
      handleChangeBG model comp val


handleChangeBG : Model -> ColorComponent -> String -> (Model, Cmd Msg)
handleChangeBG model comp val =
  let
    intval = Result.withDefault 0 <| String.toInt val

    hsl = model.bgColor

    newHsl =
      case comp of
        Hue ->
          { hsl | hue = intval }

        Saturation ->
          { hsl | saturation = intval }

        Lightness ->
          { hsl | lightness = intval }

  in
    ({ model | bgColor = newHsl }, Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  let
    cssH = toString model.bgColor.hue
    cssS = toString (toFloat model.bgColor.saturation / 360 * 100) ++ "%"
    cssL = toString (toFloat model.bgColor.lightness / 360 * 100) ++ "%"
    cssBg = "hsl(" ++ cssH ++ ", " ++ cssS ++ ", " ++ cssL ++ ")"

  in
    div [ id "app-container", style [ ("background-color", cssBg) ] ]
      [ ClockRenderer.render model
      , SettingsUI.render model
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
  Model
    (Date.fromString "0000-01-01T00:00:00")
    (Size 0 0)
    (HSLColor 0 0 180)
    False


initCmd : Cmd Msg
initCmd =
  Cmd.batch
    [ Task.perform UpdateDate Date.now
    , Task.perform WinResize Window.size
    ]


init : (Model, Cmd Msg)
init =
  (initModel, initCmd)
