%%%-------------------------------------------------------------------
%%% @author prokopiy
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Дек. 2014 0:01
%%%-------------------------------------------------------------------
-module(link).
-author("prokopiy").

%% API
-export([register_neuron_to_neuron/2, register_neuron_to_neuron/3]).
%%

register_neuron_to_neuron(Pid_neuron_from, Pid_neuron_to) ->
  neuron:register_link(Pid_neuron_from, Pid_neuron_to, 0.5 - random:uniform()).

register_neuron_to_neuron(Pid_neuron_from, Pid_neuron_to, W) ->
  neuron:register_link(Pid_neuron_from, Pid_neuron_to, W).

