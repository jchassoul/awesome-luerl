%% File    : class.erl
%% Purpose : Brief demonstration of 30log on Luerl.
%% Use     $ erlc class.erl && erl -pa ./ebin -s class run -s init stop -noshell
%% Or      $ make

-module(class).
-export([run/0]).

run() ->

    % execute an example file
    luerl:dofile("./30log-example.lua", luerl:init()),

    done.
