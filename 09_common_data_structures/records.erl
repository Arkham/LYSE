-module(records).
-compile(export_all).

-record(robot, {name,
                type=industrial,
                hobbies,
                details=[]}).

first_robot() ->
  #robot{name="Mechatron",
         type=handmade,
         details=["Moved by a small man inside"]}.

car_factory(CorpName) ->
  #robot{name=CorpName,
         hobbies="building cars"}.

% Crusher = #robot{name="Crusher", details=["Crushing people", "Hugging cats"]}.
% Crusher#robot.details

% NestedBot = #robot{name="Outer", details=#robot{name="Nested"}}.
% NestedBot#robot.details#robot.name

-record(user, {id, name, group, age}).

admin_panel(#user{name=Name, group=admin}) ->
  Name ++ " is allowed!";
admin_panel(#user{name=Name}) ->
  Name ++ " is not allowed!".

adult_section(U = #user{}) when U#user.age > 18 ->
  allowed;
adult_section(_) ->
  forbidden.

% 4> Bob = #user{id=1337, name="Bob", group=normal, age=18}.
% #user{id = 1337,name = "Bob",group = normal,age = 18}
% 5> records:admin_panel(Bob).
% "Bob is not allowed!"
% 6> records:adult_section(Bob).
% forbidden
% 7> Alice = #user{id=567, name="Alice", group=admin, age=23}.
% #user{id = 567,name = "Alice",group = admin,age = 23}
% 8> records:admin_panel(Alice).
% "Alice is allowed!"
% 9> records:adult_section(Alice).
% allowed

repairman(Rob) ->
  Details = Rob#robot.details,
  NewRob = Rob#robot{details=["Repaired by repairman"|Details]},
  {repaired, NewRob}.

-include("records.hrl").

included() ->
  #included{some_field="Hello Mom!"}.
