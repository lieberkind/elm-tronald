module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, img, input, p, text)
import Html.Attributes as Attr exposing (class, href, src, type_)
import Html.Events as E
import Http
import Json.Decode as Decode exposing (Decoder)



---- MODEL ----


type alias Model =
    { quotes : List Quote
    }


type alias Quote =
    { quote : String
    , sourceUrl : String
    }


hardcodedQuotes : List Quote
hardcodedQuotes =
    [ Quote "Hardcoded quote 1" "http://www.google.com"
    , Quote "Hardcoded quote 2" "http://www.google.com"
    ]


init : ( Model, Cmd Msg )
init =
    let
        initialModel =
            { quotes = hardcodedQuotes }

        initialCmd =
            Cmd.none
    in
    ( initialModel, initialCmd )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
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
            (List.map viewQuote model.quotes)
        ]


viewQuote : Quote -> Html Msg
viewQuote quote =
    div [ class "quote" ]
        [ p [] [ text quote.quote ]
        , a [ href quote.sourceUrl ] [ text quote.sourceUrl ]
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
