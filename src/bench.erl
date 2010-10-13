-module(bench).

-define(WORKERS_COUNT,10).

%% Application callbacks
-export([start/0, loop/3]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
  io:format("Let the benchmarks begin...~n",[]),
  spawn(?MODULE,loop,[
      [
%        {emongo_bench,start2k},
%        {emongo_bench,start16k}
        {couch_bench,start2k},
        {couch_bench,start16k}
%				{riak_bench,start2k},
%				{riak_bench,start16k}
      ],0,0
    ]).

loop(Remaining, WorkersRemaining, StartTime) ->
  {_,Sec,MicroSec} = now(),
  Time = Sec*1000000.0+MicroSec,
  if
    WorkersRemaining =:= 0 ->
      if 
        StartTime =/= 0 ->
          io:format("~nTime ~fsec~n",[(Time-StartTime)/1000000.0]);
        true -> true
      end,

      [ {Module, Function } | Tail ] = Remaining,
      Args = [self()],

      io:format("~p:~p~n",[Module, Function]),
      startWorkers(Module,Function, Args, ?WORKERS_COUNT),
      loop(Tail, ?WORKERS_COUNT, Time);

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
