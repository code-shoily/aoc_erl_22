-module(day_2).

-export([solve/0]).

input() ->
  {ok, Turns} = file:read_file("data/2.txt"),
  Turns.

solve() ->
  Turns = parse(input()),
  Possibilities =
    #{<<"A X">> => {4, 3},
      <<"A Y">> => {8, 4},
      <<"A Z">> => {3, 8},
      <<"B X">> => {1, 1},
      <<"B Y">> => {5, 5},
      <<"B Z">> => {9, 9},
      <<"C X">> => {7, 2},
      <<"C Y">> => {2, 6},
      <<"C Z">> => {6, 7}},
  Solve1 = solve1(Turns, Possibilities),
  Solve2 = solve2(Turns, Possibilities),
  {Solve1, Solve2}.

solve1(Turns, Possibilities) ->
  lists:sum([Score
             || {ok, {Score, _}} <- [maps:find(Turn, Possibilities) || Turn <- Turns]]).

solve2(Turns, Possibilities) ->
  lists:sum([Score
             || {ok, {_, Score}} <- [maps:find(Turn, Possibilities) || Turn <- Turns]]).

parse(Turns) ->
  [X || X <- binary:split(Turns, <<"\n">>, [global, trim])].
