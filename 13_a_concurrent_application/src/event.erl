-module(event).
-compile(export_all).

-record(state, {server,
                name="",
                to_go=0}).

% API
start(EventName, DateTime) ->
  spawn(?MODULE, init, [self(), EventName, DateTime]).

start_link(EventName, DateTime) ->
  spawn_link(?MODULE, init, [self(), EventName, DateTime]).

init(Server, EventName, DateTime) ->
  loop(#state{server=Server,
              name=EventName,
              to_go=time_to_go(DateTime)}).

cancel(Pid) ->
  Ref = erlang:monitor(process, Pid),
  Pid ! {self(), Ref, cancel},
  receive
    {Ref, ok} ->
      erlang:demonitor(Ref, [flush]),
      ok;
    {'DOWN', Ref, process, Pid, _Reason} ->
      ok
  end.

% Main loop
loop(S = #state{server=Server, to_go=[T|Next]}) ->
  receive
    {Server, Ref, cancel} ->
      Server ! {Ref, ok}
  after T*1000 ->
    if Next =:= [] ->
         Server ! {done, S#state.name};
       Next =/= [] ->
         loop(S#state{to_go=Next})
    end
  end.

% Erlang timeout is limited to 49 days (49*24*60*60 seconds)
normalize(N) ->
  Limit = 49*24*60*60,
  [N rem Limit | lists:duplicate(N div Limit, N)].

% convert datetime to seconds
time_to_go(TimeOut={{_,_,_}, {_,_,_}}) ->
  Now = calendar:local_time(),
  ToGo = calendar:datetime_to_gregorian_seconds(TimeOut) -
         calendar:datetime_to_gregorian_seconds(Now),
  Secs = if ToGo > 0 -> ToGo;
            ToGo =< 0 -> 0
         end,
  normalize(Secs);
time_to_go(Seconds) ->
  normalize(Seconds).

