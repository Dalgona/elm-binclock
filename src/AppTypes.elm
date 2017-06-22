module AppTypes exposing (..)
import Color exposing (Color)
import Date exposing (Date)
import Result
import Time exposing (Time)
import Window exposing (Size)


type alias Model =
  { now : Result String Date
  , winSize : Size
  , bgColor : HSLColor
  , settingsOpen : Bool
  }


type Msg
  = Tick Time
  | UpdateDate Date
  | WinResize Size
  | ToggleSettings
  | ChangeBG ColorComponent String


type ColorComponent
  = Hue
  | Saturation
  | Lightness


type alias HSLColor =
  { hue : Float
  , saturation : Float
  , lightness : Float
  , alpha : Float
  }


type alias DenormalHSLColor =
  { hue : Int
  , saturation : Int
  , lightness : Int
  , alpha : Int
  }


normalizeHsl : DenormalHSLColor -> HSLColor
normalizeHsl dhsl =
  { hue = dhsl.hue |> toFloat |> degrees
  , saturation = toFloat dhsl.saturation / 360
  , lightness = toFloat dhsl.lightness / 360
  , alpha = toFloat dhsl.alpha / 360
  }


denormalizeHsl : HSLColor -> DenormalHSLColor
denormalizeHsl hsl =
  let
    hue = if isNaN hsl.hue then 0 else hsl.hue

    sat = if isNaN hsl.saturation then 0 else hsl.saturation

  in
    { hue = round <| hue * 180.0 / pi
    , saturation = round <| sat * 360
    , lightness = round <| hsl.lightness * 360
    , alpha = round <| hsl.alpha * 360
    }
