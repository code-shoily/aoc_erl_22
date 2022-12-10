-module(common).

-export([transpose/1]).

transpose([[] | _]) ->
  [];
transpose(M) ->
  [lists:map(fun hd/1, M) | transpose(lists:map(fun tl/1, M))].