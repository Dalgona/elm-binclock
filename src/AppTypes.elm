module AppTypes exposing (..)
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
  { hue : Int
  , saturation : Int
  , lightness : Int
  }
