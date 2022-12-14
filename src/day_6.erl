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
  case sets:size(sets:from_list(Buffer)) of
    BufferSize ->
      Counter + BufferSize;
    _ ->
      solve_for(tl(ParsedStream), BufferSize, Counter + 1)
  end.
