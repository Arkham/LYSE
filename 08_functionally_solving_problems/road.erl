-module(road).
-compile(export_all).

main() ->
  File = "road.txt",
  {ok, Bin} = file:read_file(File),
  optimal_path(parse_map(Bin)).

parse_map(Bin) when is_binary(Bin) ->
  parse_map(binary_to_list(Bin));
parse_map(List) when is_list(List) ->
  Numbers = [list_to_integer(X) || X <- string:tokens(List, "\r\n\t ")],
  group_vals(Numbers, []).

group_vals([], Acc) -> lists:reverse(Acc);
group_vals([X,Y,Z|Rest], Acc) ->
  group_vals(Rest, [{X,Y,Z}| Acc]).

% -- A --
%       |
%       X
%       |
% -- B --

shortest_step({A,B,X}, {{DistA,PathA}, {DistB,PathB}}) ->
  OptA1 = {DistA + A, [{a,A}|PathA]},
  OptA2 = {DistA + B + X, [{x,X}, {b,B}|PathB]},
  OptB1 = {DistB + B, [{b,B}|PathB]},
  OptB2 = {DistB + A + X, [{x,X}, {a,A}|PathA]},
  {erlang:min(OptA1, OptA2), erlang:min(OptB1, OptB2)}.

optimal_path(Map) ->
  {OptA, OptB} = lists:foldl(fun shortest_step/2, {{0,[]}, {0,[]}}, Map),
  {_Dist,Path} = if hd(element(2,OptA)) =/= {x,0} -> OptA;
                    hd(element(2,OptB)) =/= {x,0} -> OptB
                 end,
  lists:reverse(Path).
