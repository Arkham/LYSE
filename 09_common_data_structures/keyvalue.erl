-module(keyvalue).
-compile(export_all).

prop_info() ->
  PropList = [{first_name, "Ju"}, {last_name, "Liu"}, {age, 27}],
  io:format("first_name is ~p~n", [proplists:get_value(first_name, PropList)]),
  io:format("first couple is ~p~n", [proplists:lookup(first_name, PropList)]),
  io:format("Keys are is ~p~n", [proplists:get_keys(PropList)]).

orddict_info() ->
  OrdDict = orddict:new(),
  FirstName = orddict:store(first_name, "Ju", OrdDict),
  io:format("~p~n", [FirstName]),
  LastName = orddict:store(last_name, "Liu", FirstName),
  io:format("~p~n", [LastName]),
  Profile = orddict:store(age, 27, LastName),
  io:format("finding first_name: ~p~n", [orddict:find(first_name, Profile)]),
  io:format("finding password: ~p~n", [orddict:find(password, Profile)]),
  catch io:format("fetching password: ~p~n", [orddict:fetch(password, Profile)]).

% other key value stores: dict, gb_trees
% arrays
% sets: ordsets, sets, gb_sets, sofs
% directed graphs: digraph, digraph_utils
% queues: queue

