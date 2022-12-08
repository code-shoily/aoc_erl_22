-module(day_4).

-export([solve/0]).

input() ->
  {ok, RawAssignments} = file:read_file("data/4.txt"),
  RawAssignments.

solve() ->
  RawAssignments = input(),
  Assignments = parse(RawAssignments),
  Solve1 = solve1(Assignments),
  Solve2 = solve2(Assignments),
  {Solve1, Solve2}.

solve1(Assignments) ->
  length(lists:filter(fun is_containing/1, Assignments)).

solve2(Assignments) ->
  length(lists:filter(fun is_overlapping/1, Assignments)).

parse(RawAssignments) ->
  [parse_ranges(Assignment)
   || Assignment
        <- [binary:split(RawAssignment, <<",">>, [global, trim])
            || RawAssignment <- binary:split(RawAssignments, <<"\n">>, [global, trim])]].

is_containing({{X1, Y1}, {X2, Y2}}) when X1 =< X2, Y1 >= Y2; X2 =< X1, Y2 >= Y1 ->
  true;
is_containing(_) ->
  false.

is_overlapping({{X1, Y1}, {X2, Y2}}) when X1 =< X2, Y1 >= X2; X2 =< X1, Y2 >= X1 ->
  true;
is_overlapping(_) ->
  false.

parse_ranges([Range1, Range2]) ->
  [From1, To1] = binary:split(Range1, <<"-">>),
  [From2, To2] = binary:split(Range2, <<"-">>),
  {{to_int(From1), to_int(To1)}, {to_int(From2), to_int(To2)}}.

to_int(Value) ->
  list_to_integer(binary_to_list(Value)).
