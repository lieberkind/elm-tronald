module SearchTerm exposing (SearchTerm, fromString, toString)


type SearchTerm
    = SearchTerm String


fromString : String -> Maybe SearchTerm
fromString str =
    if String.length str >= 3 then
        SearchTerm str |> Just

    else
        Nothing


toString : SearchTerm -> String
toString (SearchTerm str) =
    str
