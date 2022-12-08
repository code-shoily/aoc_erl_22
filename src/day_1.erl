-module(day_1).

-export([solve/0]).

input() ->
    {ok, RawCalories} = file:read_file("data/1.txt"),
    RawCalories.

solve() ->
    RawCalories = input(),
    ParsedData = parse(RawCalories),
    Calories = [lists:sum(X) || X <- ParsedData],
    Solve1 = solve1(Calories),
    Solve2 = solve2(Calories),

    {Solve1, Solve2}.

solve1(Calories) -> lists:max(Calories).

solve2(Calories) ->
    SortedCalories =
        lists:reverse(
            lists:sort(Calories)),
    Top3 = lists:sublist(SortedCalories, 3),
    lists:sum(Top3).

parse(RawCalories) ->
    [[binary_to_integer(Calory) || Calory <- ElfCalories]
     || ElfCalories
            <- [binary:split(ElfCalories, <<"\n">>, [global, trim])
                || ElfCalories
                       <- [Calories
                           || Calories <- binary:split(RawCalories, <<"\n\n">>, [global, trim])]]].
