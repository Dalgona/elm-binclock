module SettingsUI exposing (render)
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (onClick, onInput)
import AppTypes exposing (..)


render : Model -> Html Msg
render model =
  div [ id "settings-container" ]
    [ settingsPane model
    , div [] [ settingsButton model ]
    ]


settingsButton : Model -> Html Msg
settingsButton model =
  let
    btnClassEx =
      if model.settingsOpen then " on" else ""

  in
    button
      [ onClick ToggleSettings
      , class <| "settings-button" ++ btnClassEx
      ]
      []


settingsPane : Model -> Html Msg
settingsPane model =
  let
    row = sliderRow 0 360

  in
    if model.settingsOpen
      then
        div [ class "settings-pane" ]
          [ table []
              [ row Hue model.bgColor.hue
              , row Saturation model.bgColor.saturation
              , row Lightness model.bgColor.lightness
              ]
          ]

      else
        div [] []


colorSlider : Int -> Int -> ColorComponent -> Int -> Html Msg
colorSlider min_ max_ comp val =
  input
    [ Attr.type_ "range"
    , Attr.min <| toString min_
    , Attr.max <| toString max_
    , Attr.value <| toString val
    , onInput <| ChangeBG comp
    ] []


sliderRow : Int -> Int -> ColorComponent -> Int -> Html Msg
sliderRow min_ max_ comp val =
  tr []
    [ th [] [ text <| toString comp ]
    , td [] [ colorSlider min_ max_ comp val ]
    ]
