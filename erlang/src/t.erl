%%%-------------------------------------------------------------------
%%% @author prokopiy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Окт. 2017 17:09
%%%-------------------------------------------------------------------
-module(t).
-author("prokopiy").

%% API
-export([start/0]).

start()->
  io:format("Hello world!\n~w\n",[layer:msub(2, 6, 55)]),
  L = layer:new(5),
  layer:print(L).