-module(day_6).

-export([solve/0]).

input() ->
  {ok, DataStream} = file:read_file("data/6.txt"),
  DataStream.

solve() ->
  ParsedStream = binary:bin_to_list(input()),
  {solve1(ParsedStream), solve2(ParsedStream)}.

solve1(ParsedStream) ->
  solve_for(ParsedStream, 4, 0).

solve2(ParsedStream) ->
  solve_for(ParsedStream, 14, 0).

solve_for(ParsedStream, BufferSize, Counter) ->
  {Buffer, _} = lists:split(BufferSize, ParsedStream),
  case unique_members(Buffer) of
    true ->
      Counter + BufferSize;
    false ->
      solve_for(tl(ParsedStream), BufferSize, Counter + 1)
  end.

unique_members(List) ->
  length(List) == length(ordsets:from_list(List)).
