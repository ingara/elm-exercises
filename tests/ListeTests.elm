module ListeTests exposing (tests)

import Basics exposing (..)
import Expect
import Liste exposing (..)
import Maybe exposing (Maybe(..))
import Test exposing (..)


tests : Test
tests =
    describe "Liste Tests"
        [ testListeOfN 0
        , testListeOfN 1
        , testListeOfN 2
        , testListeOfN 5000
        ]


testListeOfN : Int -> Test
testListeOfN n =
    let
        xs =
            Liste.range 1 n

        xsOpp =
            Liste.range -n -1

        xsNeg =
            foldl (::) [] xsOpp

        -- assume foldl and (::) work
        zs =
            Liste.range 0 n

        sumSeq k =
            k * (k + 1) // 2

        xsSum =
            sumSeq n

        mid =
            n // 2
    in
    describe (String.fromInt n ++ " elements")
        [ describe "foldl"
            [ test "order" <| \() -> Expect.equal n (foldl (\x acc -> x) 0 xs)
            , test "total" <| \() -> Expect.equal xsSum (foldl (+) 0 xs)
            ]
        , describe "foldr"
            [ test "order" <| \() -> Expect.equal (min 1 n) (foldr (\x acc -> x) 0 xs)
            , test "total" <| \() -> Expect.equal xsSum (foldl (+) 0 xs)
            ]
        , describe "map"
            [ test "identity" <| \() -> Expect.equal xs (map identity xs)
            , test "linear" <| \() -> Expect.equal (Liste.range 2 (n + 1)) (map ((+) 1) xs)
            ]
        , test "isEmpty" <| \() -> Expect.equal (n == 0) (isEmpty xs)
        , test "length" <| \() -> Expect.equal n (length xs)
        , test "reverse" <| \() -> Expect.equal xsOpp (reverse xsNeg)
        , describe "member"
            [ test "positive" <| \() -> Expect.equal True (member n zs)
            , test "negative" <| \() -> Expect.equal False (member (n + 1) xs)
            ]
        , test "head" <|
            \() ->
                if n == 0 then
                    Expect.equal Nothing (head xs)

                else
                    Expect.equal (Just 1) (head xs)
        , describe "Liste.filter"
            [ test "none" <| \() -> Expect.equal [] (Liste.filter (\x -> x > n) xs)
            , test "one" <| \() -> Expect.equal [ n ] (Liste.filter (\z -> z == n) zs)
            , test "all" <| \() -> Expect.equal xs (Liste.filter (\x -> x <= n) xs)
            ]
        , describe "take"
            [ test "none" <| \() -> Expect.equal [] (take 0 xs)
            , test "some" <| \() -> Expect.equal (Liste.range 0 (n - 1)) (take n zs)
            , test "all" <| \() -> Expect.equal xs (take n xs)
            , test "all+" <| \() -> Expect.equal xs (take (n + 1) xs)
            ]
        , describe "drop"
            [ test "none" <| \() -> Expect.equal xs (drop 0 xs)
            , test "some" <| \() -> Expect.equal [ n ] (drop n zs)
            , test "all" <| \() -> Expect.equal [] (drop n xs)
            , test "all+" <| \() -> Expect.equal [] (drop (n + 1) xs)
            ]
        , test "repeat" <| \() -> Expect.equal (map (\x -> -1) xs) (repeat n -1)
        , test "append" <| \() -> Expect.equal (xsSum * 2) (append xs xs |> foldl (+) 0)
        , test "(::)" <| \() -> Expect.equal (append [ -1 ] xs) (-1 :: xs)
        , test "Liste.concat" <| \() -> Expect.equal (append xs (append zs xs)) (Liste.concat [ xs, zs, xs ])
        , test "intersperse" <|
            \() ->
                Expect.equal
                    ( min -(n - 1) 0, xsSum )
                    (intersperse -1 xs |> foldl (\x ( c1, c2 ) -> ( c2, c1 + x )) ( 0, 0 ))
        , describe "partition"
            [ test "left" <| \() -> Expect.equal ( xs, [] ) (partition (\x -> x > 0) xs)
            , test "right" <| \() -> Expect.equal ( [], xs ) (partition (\x -> x < 0) xs)
            , test "split" <| \() -> Expect.equal ( Liste.range (mid + 1) n, Liste.range 1 mid ) (partition (\x -> x > mid) xs)
            ]
        , describe "map2"
            [ test "same length" <| \() -> Expect.equal (map ((*) 2) xs) (map2 (+) xs xs)
            , test "long first" <| \() -> Expect.equal (map (\x -> x * 2 - 1) xs) (map2 (+) zs xs)
            , test "short first" <| \() -> Expect.equal (map (\x -> x * 2 - 1) xs) (map2 (+) xs zs)
            ]
        , test "unzip" <| \() -> Expect.equal ( xsNeg, xs ) (map (\x -> ( -x, x )) xs |> unzip)
        , describe "filterMap"
            [ test "none" <| \() -> Expect.equal [] (filterMap (\x -> Nothing) xs)
            , test "all" <| \() -> Expect.equal xsNeg (filterMap (\x -> Just -x) xs)
            , let
                halve x =
                    if modBy 2 x == 0 then
                        Just (x // 2)

                    else
                        Nothing
              in
              test "some" <| \() -> Expect.equal (Liste.range 1 mid) (filterMap halve xs)
            ]
        , describe "concatMap"
            [ test "none" <| \() -> Expect.equal [] (concatMap (\x -> []) xs)
            , test "all" <| \() -> Expect.equal xsNeg (concatMap (\x -> [ -x ]) xs)
            ]
        , test "indexedMap" <| \() -> Expect.equal (map2 Tuple.pair zs xsNeg) (indexedMap (\i x -> ( i, -x )) xs)
        , test "sum" <| \() -> Expect.equal xsSum (sum xs)
        , test "product" <| \() -> Expect.equal 0 (product zs)
        , test "maximum" <|
            \() ->
                if n == 0 then
                    Expect.equal Nothing (maximum xs)

                else
                    Expect.equal (Just n) (maximum xs)
        , test "minimum" <|
            \() ->
                if n == 0 then
                    Expect.equal Nothing (minimum xs)

                else
                    Expect.equal (Just 1) (minimum xs)
        , describe "all"
            [ test "false" <| \() -> Expect.equal False (all (\z -> z < n) zs)
            , test "true" <| \() -> Expect.equal True (all (\x -> x <= n) xs)
            ]
        , describe "any"
            [ test "false" <| \() -> Expect.equal False (any (\x -> x > n) xs)
            , test "true" <| \() -> Expect.equal True (any (\z -> z >= n) zs)
            ]
        , describe "sort"
            [ test "sorted" <| \() -> Expect.equal xs (sort xs)
            , test "unsorted" <| \() -> Expect.equal xsOpp (sort xsNeg)
            ]
        , describe "sortBy"
            [ test "sorted" <| \() -> Expect.equal xsNeg (sortBy negate xsNeg)
            , test "unsorted" <| \() -> Expect.equal xsNeg (sortBy negate xsOpp)
            ]
        , describe "sortWith"
            [ test "sorted" <| \() -> Expect.equal xsNeg (sortWith (\x -> \y -> compare y x) xsNeg)
            , test "unsorted" <| \() -> Expect.equal xsNeg (sortWith (\x -> \y -> compare y x) xsOpp)
            ]
        ]
