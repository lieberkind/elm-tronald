# Elm Tronald Dump

# Running

`cd` into the `server` folder and run `node start`

`cd` back to the root folder run `elm-app` run

# Steps

# Open URLs:

- Http: https://package.elm-lang.org/packages/elm/http/latest/Http
- Json.Decode: https://package.elm-lang.org/packages/elm/json/latest/Json-Decode
- Tronald Dump search result: https://api.tronalddump.io/search/quote?query=obama

0. Present the different parts of the app
1. Get the input field to work
1. Get the button to work
1. Make an HTTP request
   a. Cmd.none
   b. Refactor to a function
   c. Make the request - Explain Http.get function `expectWhatever`
   d. Log the failures of the results
   e. Decode the response - boarder protection
1. Introduce empty results and errors
   a. What about the initial state?
   b. Introduce "hasMadeFirstRequest"
   c. Introduce Maybe (List Quote)
   d. Use Introduce (WebData = NotRequested | Loaded a)
1. Introduce the loading state
1. Introduce the SearchTerm type

## Notes on test run #1

- Show the finished product
- Create a Quote type alias from the beginning. Initialize the app
  with a few hardcoded quotes, and have the `viewQuote` function
  implemented as well
- Have the "no-quotes" ready available
- Maybe do a copy-paste solution with the Http library? That would be this section:

```elm
requestQuotes : String -> Cmd Msg
requestQuotes searchString =
    Http.get
        { url = "http://localhost:3001/search/quote?query=" ++ searchString
        , expect = Http.expectJson GotSearchResult searchResultDecoder
        }


searchResultDecoder : Decoder (List Quote)
searchResultDecoder =
    Decode.succeed []
```
