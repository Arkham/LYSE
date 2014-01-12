-module(greet).

-import(io, [format/2]).

-compile(export_all).

greet(male, Name) ->
  format("Hello, Mr. ~s!", [Name]);
greet(female, Name) ->
  format("Hello, Mrs. ~s!", [Name]);
greet(_, Name) ->
  format("Hello, ~s!", [Name]).

