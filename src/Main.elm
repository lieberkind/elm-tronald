module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes as Attr exposing (src)
import Html.Events as E
import Http
import Json.Decode as Decode exposing (Decoder)



---- MODEL ----


type alias Quote =
    { quote : String
    }


type alias Model =
    { quotes : List Quote
    , searchString : String
    }


init : ( Model, Cmd Msg )
init =
    ( { quotes = [], searchString = "" }, Cmd.none )



---- UPDATE ----


type Msg
    = SearchStringChanged String
    | SearchFor String
    | GotQuotes (Result Http.Error (List Quote))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchStringChanged str ->
            let
                newModel =
                    { model | searchString = str }
            in
            ( newModel, Cmd.none )

        SearchFor str ->
            let
                cmd =
                    requestQuotes str
            in
            ( model, cmd )

        GotQuotes result ->
            case result of
                Result.Err err ->
                    let
                        meh =
                            Debug.log (err |> Debug.toString)
                    in
                    ( model, Cmd.none )

                Result.Ok quotes ->
                    let
                        newModel =
                            { model | quotes = quotes }
                    in
                    ( newModel, Cmd.none )



---- HTTP ----


requestQuotes : String -> Cmd Msg
requestQuotes searchString =
    Http.get
        { url = "http://localhost:3001/search/quote?query=" ++ searchString
        , expect = Http.expectJson GotQuotes quotesDecoder
        }


quotesDecoder : Decoder (List Quote)
quotesDecoder =
    Decode.field "_embedded" <|
        Decode.field "quotes" <|
            Decode.list quoteDecoder


quoteDecoder : Decoder Quote
quoteDecoder =
    Decode.map Quote
        (Decode.field "value" Decode.string)



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ Html.input
            [ Attr.type_ "text"
            , Attr.value model.searchString
            , E.onInput SearchStringChanged
            ]
            []
        , Html.button [ E.onClick (SearchFor model.searchString) ] [ Html.text "Search..." ]
        , Html.p [] [ Html.text model.searchString ]
        , Html.div []
            (List.map
                viewQuote
                model.quotes
            )
        ]


viewQuote : Quote -> Html Msg
viewQuote quote =
    Html.div []
        [ Html.p [] [ Html.text quote.quote ]
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
