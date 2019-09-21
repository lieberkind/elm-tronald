module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, img, input, p, text)
import Html.Attributes as Attr exposing (class, href, src, type_)
import Html.Events as E
import Http
import Json.Decode as Decode exposing (Decoder)
import SearchTerm exposing (SearchTerm)



---- MODEL ----


type WebData a
    = NotRequested
    | Loading
    | Success a
    | Failure String


type alias Quote =
    { quote : String
    , source : String
    }


type alias Model =
    { searchString : String
    , quotes : WebData (List Quote)
    }


init : ( Model, Cmd Msg )
init =
    ( { searchString = "", quotes = NotRequested }, Cmd.none )



---- UPDATE ----


type Msg
    = SearchStringChanged String
    | SearchClicked
    | GotQuotes (Result Http.Error (List Quote))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchStringChanged str ->
            ( { model | searchString = str }, Cmd.none )

        SearchClicked ->
            let
                newModel =
                    { model | quotes = Loading }

                cmd =
                    case SearchTerm.fromString model.searchString of
                        Just searchTerm ->
                            requestQuotes searchTerm

                        Nothing ->
                            Cmd.none
            in
            ( newModel, cmd )

        GotQuotes (Ok quotes) ->
            let
                newModel =
                    { model | quotes = Success quotes }
            in
            ( newModel, Cmd.none )

        GotQuotes (Err err) ->
            let
                newModel =
                    { model | quotes = Failure (Debug.toString err) }
            in
            ( newModel, Cmd.none )



---- HTTP ----


requestQuotes : SearchTerm -> Cmd Msg
requestQuotes searchTerm =
    Http.get
        { url = "http://localhost:3001/search/quote?query=" ++ SearchTerm.toString searchTerm
        , expect = Http.expectJson GotQuotes quotesDecoder
        }


quotesDecoder : Decoder (List Quote)
quotesDecoder =
    Decode.oneOf
        [ Decode.at [ "_embedded", "quotes" ] (Decode.list quoteDecoder)
        , Decode.succeed []
        ]


quoteDecoder : Decoder Quote
quoteDecoder =
    Decode.map2 Quote
        (Decode.field "value" Decode.string)
        (Decode.at [ "_embedded", "source", "0", "url" ] Decode.string)



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ div [ class "logo" ]
            [ img [ src "logo.png" ] [] ]
        , div [ class "form" ]
            [ input [ type_ "text", E.onInput SearchStringChanged ] []
            , button
                [ type_ "button", E.onClick SearchClicked ]
                [ text "Search..." ]
            ]
        , div
            [ class "quotes" ]
            (case model.quotes of
                NotRequested ->
                    [ div [ class "no-quotes" ] [ text "Search for something..." ] ]

                Loading ->
                    [ div [ class "no-quotes" ] [ text "Loading..." ] ]

                Success [] ->
                    [ div [ class "no-quotes" ] [ text "No results" ] ]

                Success quotes ->
                    List.map viewQuote quotes

                Failure str ->
                    [ div [ class "no-quotes" ] [ "There was an error: " ++ str |> text ] ]
            )
        ]


viewQuote : Quote -> Html Msg
viewQuote quote =
    div [ class "quote" ]
        [ p [] [ text quote.quote ]
        , a [ href quote.source ] [ text quote.source ]
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
