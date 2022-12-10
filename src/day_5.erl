-module(day_5).

-export([solve/0]).

input() ->
  {ok, Data} = file:read_file("data/5.txt"),
  Data.

solve() ->
  Data = parse(input()),
  {solve1(Data), solve2(Data)}.

solve1({State, Steps}) ->
  solver({State, Steps}, fun lists:reverse/1).

solve2({State, Steps}) ->
  solver({State, Steps}, fun(X) -> X end).

solver({State, Steps}, Fun) ->
  Reducer =
    fun({Q, S, D}, Acc) ->
       Source = array:get(S - 1, Acc),
       Destination = array:get(D - 1, Acc),
       {Move, NewSource} = lists:split(Q, Source),
       NewDestination = Fun(Move) ++ Destination,
       array:set(S - 1, NewSource, array:set(D - 1, NewDestination, Acc))
    end,
  top_containers(array:to_list(
                   lists:foldl(Reducer, State, Steps))).

parse(Data) ->
  [State, Steps] = binary:split(Data, <<"\n\n">>),
  {parse_state(State), parse_steps(Steps)}.

parse_steps(Steps) ->
  RawSteps = lists:map(fun binary_to_list/1, binary:split(Steps, <<"\n">>, [global])),
  ToInteger = fun(X) -> element(1, string:to_integer(X)) end,
  [begin
     [_, Q, _, S, _, D] = string:split(Step, " ", all),
     {ToInteger(Q), ToInteger(S), ToInteger(D)}
   end
   || Step <- RawSteps].

parse_state(State) ->
  Rows =
    [binary_to_list(X)
     || X
          <- lists:droplast(
               binary:split(remove_brackets(State), <<"\n">>, [global]))],
  Containers =
    lists:map(fun(X) -> [string:trim(Container) || Container <- string:split(X, "   ", all)]
              end,
              Rows),
  array:from_list([lists:dropwhile(fun(X) -> X == [] end, C)
                   || C <- common:transpose(Containers)]).

remove_brackets(Container) ->
  binary:replace(
    binary:replace(Container, <<"[">>, <<" ">>, [global]), <<"]">>, <<" ">>, [global]).

top_containers(Containers) ->
  binary_to_list(list_to_binary([hd(X) || X <- Containers])).
