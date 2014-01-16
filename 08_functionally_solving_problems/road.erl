-module(road).
-compile(export_all).

main([FileName]) ->
  {ok, Bin} = file:read_file(FileName),
  Map = parse_map(Bin),
  io:format("~p~n", [optimal_path(Map)]),
  erlang:halt().

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
  OptA2 = {DistB + B + X, [{x,X}, {b,B}|PathB]},
  OptB1 = {DistB + B, [{b,B}|PathB]},
  OptB2 = {DistA + A + X, [{x,X}, {a,A}|PathA]},
  {erlang:min(OptA1, OptA2), erlang:min(OptB1, OptB2)}.

optimal_path(Map) ->
  {OptA, OptB} = lists:foldl(fun shortest_step/2, {{0,[]}, {0,[]}}, Map),
  {_Dist,Path} = if hd(element(2,OptA)) =/= {x,0} -> OptA;
                    hd(element(2,OptB)) =/= {x,0} -> OptB
                 end,
  lists:reverse(Path).
