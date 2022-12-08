-module(day_3).

-export([solve/0, chunks/2]).

input() ->
  {ok, RawRucksacks} = file:read_file("data/3.txt"),
  RawRucksacks.

solve() ->
  RawRucksacks = parse(input()),
  Solve1 = solve1(RawRucksacks),
  Solve2 = solve2(RawRucksacks),
  {Solve1, Solve2}.

solve1(RawRucksacks) ->
  total_priority(lists:map(fun(X) -> compartment(X) end, RawRucksacks)).

solve2(RawRucksacks) ->
  total_priority([common(X) || X <- chunks(RawRucksacks, 3)]).

parse(RawRucksacks) ->
  [binary:bin_to_list(Subject)
   || Subject <- binary:split(RawRucksacks, <<"\n">>, [global, trim])].

compartment(A) ->
  {First, Last} = lists:split(length(A) div 2, A),
  ordsets:intersection(
    ordsets:from_list(First), ordsets:from_list(Last)).

priority(X) when X =< 90 ->
  X - hd("A") + 27;
priority(X) when X >= 97 ->
  X - hd("a") + 1.

chunks([], _) ->
  [];
chunks(List, Len) when Len > length(List) ->
  [List];
chunks(List, Len) ->
  {Head, Tail} = lists:split(Len, List),
  [Head | chunks(Tail, Len)].

common([A, B, C]) ->
  ordsets:intersection(
    ordsets:from_list(A),
    ordsets:intersection(
      ordsets:from_list(B), ordsets:from_list(C))).

total_priority(CommonItems) ->
  lists:sum([priority(hd(X)) || X <- CommonItems]).
