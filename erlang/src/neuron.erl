%%%-------------------------------------------------------------------
%%% @author prokopiy
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% Модуль реализует работу нейрона в нейросети
%%% Нейрон имеет память(задержку)
%%% Нейрон посылает сигнал на выход сразу после того как получит сигнал со всех входов
%%% Сигнал с выходных нейронов посылается инициатору текущей волны в виде кортежа {reply, Pid_выходного нейрона, {effect, Power}}
%%% @end
%%% Created : 13. Окт. 2017 21:57
%%%-------------------------------------------------------------------

-module(neuron).
-author("prokopiy").

%% API jjjj
-export([new/0, loop/1, register_link/3, print/1, stop/1, pulse/2]).




new() ->
  Data = #{
    in_powers => #{},
    in_links => #{},
    out_links => #{}
  },
  spawn(neuron, loop, [Data]).


call(Pid, Message) ->
  Pid ! {request, self(), Message},
  receive
    {reply, Pid, Reply} -> Reply
  end.


print(Neuron_pid) when is_pid(Neuron_pid) ->
%%   Neuron_pid ! {request, self(), print};
  call(Neuron_pid, print);
print([]) ->
  true;
print([H | T]) ->
  print(H),
  print(T).

stop(Neuron_pid) ->
  call(Neuron_pid, stop).


register_link(Pid_neuron_from, Pid_neuron_to, W) when is_pid(Pid_neuron_from), is_pid(Pid_neuron_to), is_number(W) ->
  Pid_neuron_from ! {request, self(), {set_link_out, Pid_neuron_to, W}},
  Pid_neuron_to ! {request, self(), {set_link_in, Pid_neuron_from, W}},
  true;
register_link(Pid_neuron_from, List_neurons_to, W) when is_pid(Pid_neuron_from), is_list(List_neurons_to), is_number(W) ->
  lists:foreach(fun(P) -> register_link(Pid_neuron_from, P, W) end, List_neurons_to).



pulse(Neuron_pid, Value) when is_pid(Neuron_pid) ->
  Neuron_pid ! {request, self(), {pulse, self(), Value}}.



loop(Data) ->
  receive
    {reply, _, ok} ->
      loop(Data);
    {reply, _, {confirm_back_error, ok}} ->
      loop(Data);
    {request, Pid, print} ->
      io:format("Neuron~w = ~w~n", [self(), Data]),
      Pid ! {reply, self(), ok},
      loop(Data);
    {request, Pid, stop} ->
      io:format("Neuron~w stopped~n", [self()]);
    {request, Pid, get_last_out} ->
      Pid ! {reply, self(), {ok, {last_out, maps:get(last_out, Data)}}},
      loop(Data);
    {request, Pid, {set_link_out, Output_neuron_pid, W}} ->
      Current_out_links = maps:get(out_links, Data),
      New_out_links = maps:put(Output_neuron_pid, W, Current_out_links),
      NewData = Data#{out_links := New_out_links},
      loop(NewData);
    {request, Pid, {set_link_in, Input_neuron_pid, W}} ->
      Current_in_links = maps:get(in_links, Data),
      New_in_links = maps:put(Input_neuron_pid, W, Current_in_links),
      NewData = Data#{in_links := New_in_links},
      loop(NewData)

  after
    15000 ->
%%       io:format("Neuron~w timeout~n", [self()])
      true
  end.



