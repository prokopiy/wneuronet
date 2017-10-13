%%%-------------------------------------------------------------------
%%% @author prokopiy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Окт. 2017 17:31
%%%-------------------------------------------------------------------
-module(layer).
-author("prokopiy").

%% API
-export([new/1, print/1, loop/1]).


new(Size) ->
  Data = #{
    size => Size
    },
  spawn(layer, loop, [Data]).

print(Layer) when is_pid(Layer) ->
  Layer ! {request, self(), print}.


loop(Data) ->
  receive
    {reply, _, ok} ->
      loop(Data);
    {request, _, stop} ->
      true;
    {request, _, print} ->
      io:format("Layer~w ~w~n", [self(), Data]),
      loop(Data)

  after
    25000 ->
      true
  end.