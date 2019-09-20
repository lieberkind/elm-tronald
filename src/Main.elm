module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, img, input, p, text)
import Html.Attributes as Attr exposing (class, href, src, type_)
import Html.Events as E
import Http
import Json.Decode as Decode exposing (Decoder)



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ div [ class "logo" ]
            [ img [ src "logo.png" ] [] ]
        , div [ class "form" ]
            [ input [ type_ "text" ] []
            , button
                [ type_ "button" ]
                [ text "Search..." ]
            ]
        , div [ class "quotes" ]
            [ div [ class "quote" ]
                [ p [] [ text "This quote is hardcoded" ]
                , a [ href "#" ] [ text "http://sourceofthequote.com" ]
                ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
