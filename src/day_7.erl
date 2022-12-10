-module(day_7).

-export([solve/0]).

input() ->
  {ok, Listing} = file:read_file("data/7.txt"),
  Listing.

solve() ->
  Directory = parse(input()),
  {solve1(Directory), solve2(Directory)}.

solve1(Directory) ->
  Sizes = maps:values(Directory),
  AtMost100_000 = lists:filter(fun(X) -> X =< 100_000 end, Sizes),
  lists:sum(AtMost100_000).

solve2(Directory) ->
  Sizes = maps:values(Directory),
  Available = 70_000_000 - lists:max(Sizes),
  Needed = 30_000_000 - Available,
  lists:min(
    lists:filter(fun(Size) -> Size - Needed > 0 end, Sizes)).

parse(Listing) ->
  Commands =
    [Command
     || Command
          <- [parse_command(List) || List <- binary:split(Listing, <<"\n">>, [global, trim])],
        Command /= no_op],
  Files = get_files(Commands),
  build_dir_map(Files).

get_files(Commands) ->
  Init = {[], ["/"]},
  Reducer =
    fun(Cmd, {Files, [_ | Rest] = Path}) ->
       case Cmd of
         root -> {Files, ["/"]};
         up -> {Files, Rest};
         {cd, Dir} -> {Files, [[Dir | Path] | Path]};
         {Size, FileName} -> {[{FileName, build_dir_map(Path, Size)} | Files], Path}
       end
    end,
  {Files, _} = lists:foldl(Reducer, Init, Commands),
  lists:uniq(Files).

build_dir_map(Directories, Size) ->
  lists:foldl(fun(Directory, Acc) -> maps:put(Directory, Size, Acc) end,
              maps:new(),
              Directories).

build_dir_map(Files) ->
  lists:foldl(fun({_, Dirs}, Acc) ->
                 maps:merge_with(fun(_, V1, V2) -> V1 + V2 end, Dirs, Acc)
              end,
              maps:new(),
              Files).

parse_command(List) ->
  case List of
    <<"$ cd /", _/binary>> ->
      root;
    <<"$ cd ..", _/binary>> ->
      up;
    <<"$ cd ", Directory/binary>> ->
      {cd, binary_to_list(Directory)};
    <<"dir ", _/binary>> ->
      no_op;
    <<"$ ls">> ->
      no_op;
    File ->
      [Size, Name] = binary:split(File, <<" ">>),
      {binary_to_integer(Size), binary_to_list(Name)}
  end.
