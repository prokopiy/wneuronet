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
-export([new/1, print/1, loop/1, madd/3, msub/3]).


new(Size) ->

  Neurons = generate_layer(Size*Size),

  Data = #{
    size => Size,
    neurons => Neurons
    },
  spawn(layer, loop, [Data]).


print(Layer) when is_pid(Layer) ->
  Layer ! {request, self(), print}.


generate_layer(A) ->
  generate_layer(A, []).
generate_layer(0, Acc) ->
  Acc;
generate_layer(Size, Acc) ->
  N = neuron:new(),
  generate_layer(Size-1, Acc ++ [N]).


madd(A, B, M) ->
  (A + B) rem M.

msub(A, B, M) ->
  (M + ((A - B) rem M)) rem M.

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