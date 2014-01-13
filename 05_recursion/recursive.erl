-module(recursive).
-compile(export_all).

fac(0) -> 1;
fac(N) when N > 0 -> N * fac(N-1).

len([]) -> 0;
len([_|T]) -> 1 + len(T).

tail_fac(N) -> tail_fac(N,1).
tail_fac(0,Acc) -> Acc;
tail_fac(N,Acc) when N > 0 -> tail_fac(N-1,N*Acc).

tail_len(Arr) -> tail_len(Arr, 0).
tail_len([],Acc) -> Acc;
tail_len([_|Arr],Acc) -> tail_len(Arr,Acc+1).

duplicate(0,_) ->
  [];
duplicate(N,X) when N > 0 ->
  [X|duplicate(N-1,X)].

tail_duplicate(N,X) ->
  tail_duplicate(N,X,[]).
tail_duplicate(0,_,Acc) ->
  Acc;
tail_duplicate(N,X,Acc) when N > 0 ->
  tail_duplicate(N-1,X,[X|Acc]).

reverse([]) -> [];
reverse([H|T]) -> reverse(T) ++ [H].

tail_reverse(List) -> tail_reverse(List,[]).
tail_reverse([], Acc) -> Acc;
tail_reverse([H|T], Acc) -> tail_reverse(T, [H|Acc]).

sublist(_,0) -> [];
sublist([],_) -> [];
sublist([H|T],N) when N > 0 -> [H|sublist(T,N-1)].

tail_sublist(List,N) -> lists:reverse(tail_sublist(List,N,[])).
tail_sublist(_,0,Acc) -> Acc;
tail_sublist([],_,Acc) -> Acc;
tail_sublist([H|T],N,Acc) when N > 0 -> tail_sublist(T,N-1, [H|Acc]).

zip([],[]) -> [];
zip([H1|T1],[H2|T2]) -> [{H1,H2}|zip(T1,T2)].

tail_zip(X,Y) -> lists:reverse(tail_zip(X,Y,[])).
tail_zip([],[],Result) -> Result;
tail_zip([H1|T1],[H2|T2],Result) -> tail_zip(T1,T2,[{H1,H2}|Result]).

lenient_zip([],_) -> [];
lenient_zip(_,[]) -> [];
lenient_zip([H1|T1],[H2|T2]) -> [{H1,H2}|zip(T1,T2)].

tail_lenient_zip(X,Y) -> lists:reverse(tail_lenient_zip(X,Y,[])).
tail_lenient_zip([],_,Result) -> Result;
tail_lenient_zip(_,[],Result) -> Result;
tail_lenient_zip([H1|T1],[H2|T2],Result) -> tail_lenient_zip(T1,T2,[{H1,H2}|Result]).

quicksort([]) -> [];
quicksort([Pivot|Rest]) ->
  {Smaller,Larger} = partition(Pivot,Rest,[],[]),
  quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).

partition(_,[],Smaller,Larger) -> {Smaller,Larger};
partition(Pivot,[H|T],Smaller,Larger) ->
  if Pivot >  H -> partition(Pivot,T,[H|Smaller],Larger);
     Pivot =< H -> partition(Pivot,T,Smaller,[H|Larger])
  end.

lc_quicksort([]) -> [];
lc_quicksort([Pivot|Rest]) ->
  lc_quicksort([Smaller || Smaller <- Rest, Smaller < Pivot])
  ++ [Pivot] ++
  lc_quicksort([Larger || Larger <- Rest, Larger >= Pivot]).

bestest_quicksort([]) -> [];
bestest_quicksort([H|T]) ->
  bestest_quicksort([H|T],[]).

bestest_quicksort([],Acc) -> Acc;
bestest_quicksort([Pivot|Rest],Acc) ->
  bestest_partition(Pivot,Rest,{[],[Pivot],[]},Acc).

bestest_partition(_,[],{Smaller,Equal,Larger},Acc) -> bestest_quicksort(Smaller, (Equal ++ bestest_quicksort(Larger,Acc)));
bestest_partition(Pivot,[H|T],{Smaller,Equal,Larger},Acc) ->
  if Pivot > H  -> bestest_partition(Pivot,T,{[H|Smaller],Equal,Larger},Acc);
     Pivot < H  -> bestest_partition(Pivot,T,{Smaller,Equal,[H|Larger]},Acc);
     Pivot == H -> bestest_partition(Pivot,T,{Smaller,[H|Equal],Larger},Acc)
  end.
