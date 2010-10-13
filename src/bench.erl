-module(bench).

-define(WORKERS_COUNT,10).

%% Application callbacks
-export([start/0, loop/3]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
  emongo:add_pool(test_pool, "localhost", 27017, "test", 10),
  io:format("Let the benchmarks begin...",[]),
  spawn(?MODULE,loop,[
      [
        {emongo_bench,start2k,[]},
        {emongo_bench,start16k,[]}
      ],0,0
    ]).

loop(Remaining, WorkersRemaining, StartTime) ->
  {_,Sec,MicroSec} = now(),
  Time = Sec*1000000+MicroSec,

  if
    WorkersRemaining =:= 0 ->
      if 
        StartTime =/= 0 ->
          io:format("Time ~fmsec~n",[Time-StartTime])
      end,

      [ {Module, Function, Args} | Tail ] = Remaining,

      case Tail of
        [] -> true;

        _ ->
          io:format("~p:~p~n",[Module, Function]),
          startWorkers(Module,Function, Args, ?WORKERS_COUNT),
          loop(Remaining, ?WORKERS_COUNT, Time)
      end;


    true ->
      receive
        done ->
          loop(Remaining, WorkersRemaining-1, StartTime);

        Msg -> io:format("Unknown message ~p~n",[Msg])
      end
  end.

startWorkers(Module, Function, Args, Count) ->
  if
    Count =/=0 ->
      apply(Module,Function,Args),
      startWorkers(Module, Function, Args,Count-1);

    true -> ok
  end.
