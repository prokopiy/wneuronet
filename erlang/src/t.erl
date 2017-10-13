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
  io:format("Hello world!\n~w\n",[layer:madd(2, 2, 5)]),
  L = layer:new(5),
  layer:print(L).