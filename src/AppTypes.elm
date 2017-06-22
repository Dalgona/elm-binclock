module AppTypes exposing (..)
import Result
import Date exposing (Date)
import Time exposing (Time)
import Window exposing (Size)


type alias Model =
  { now : Result String Date
  , winSize : Size
  }


type Msg
  = Tick Time
  | UpdateDate Date
  | WinResize Size
