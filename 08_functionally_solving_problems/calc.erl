-module(calc).
-export([rpn/1, rpn_test/0]).

rpn(L) when is_list(L) ->
  [Result] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
  Result.

read(Val) ->
  case string:to_float(Val) of
    {error, no_float} -> list_to_integer(Val);
    {F, _} -> F
  end.

rpn("+", [X,Y|Rest]) ->
  [Y+X|Rest];
rpn("-", [X,Y|Rest]) ->
  [Y-X|Rest];
rpn("/", [X,Y|Rest]) ->
  [Y/X|Rest];
rpn("*", [X,Y|Rest]) ->
  [Y*X|Rest];
rpn("^", [X,Y|Rest]) ->
  [math:pow(Y, X)|Rest];
rpn("ln", [X|Rest]) ->
  [math:log(X)|Rest];
rpn("log10", [X|Rest]) ->
  [math:log10(X)|Rest];
rpn("sum", Rest) ->
  [lists:foldl(fun(X, Acc) -> X + Acc end, 0, Rest)];
rpn("prod", Rest) ->
  [lists:foldl(fun(X, Acc) -> X * Acc end, 1, Rest)];
rpn(Val, Acc) ->
  [read(Val)|Acc].

rpn_test() ->
  5 = rpn("2 3 +"),
  87 = rpn("90 3 -"),
  -4 = rpn("10 4 3 + 2 * -"),
  -2.0 = rpn("10 4 3 + 2 * - 2 /"),
  ok = try
         rpn("90 34 12 33 55 66 + * - +")
       catch
         error:{badmatch, [_|_]} -> ok
       end,
  4037 = rpn("90 34 12 33 55 66 + * - + -"),
  8.0 = rpn("2 3 ^"),
  true = math:sqrt(2) == rpn("2 0.5 ^"),
  true = math:log(2.7) == rpn("2.7 ln"),
  true = math:log10(2.7) == rpn("2.7 log10"),
  50 = rpn("10 10 10 20 sum"),
  10.0 = rpn("10 10 10 20 sum 5 /"),
  1000.0 = rpn("10 10 20 0.5 prod"),
  ok.
