module AppTypes exposing (..)
import Color exposing (Color)
import Date exposing (Date)
import Result
import Time exposing (Time)
import Window exposing (Size)


type alias Model =
  { now : Result String Date
  , winSize : Size
  , bgColor : Color
  }


type Msg
  = Tick Time
  | UpdateDate Date
  | WinResize Size


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
