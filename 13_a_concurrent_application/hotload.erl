-module(hotload).

-export([init/0, server/1, upgrade/1]).

init() ->
  spawn(?MODULE, server, ["Initial state"]).

server(State) ->
  receive
    update ->
      NewState = ?MODULE:upgrade(State),
      ?MODULE:server(NewState);
    info ->
      io:format("State is ~p~n", [State]),
      server(State)
  end.

upgrade(OldState) ->
  % OldState ++ " +".
  OldState ++ " -".

