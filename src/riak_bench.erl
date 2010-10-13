-module(riak_bench).

-include("docs.hrl").

-define(INSERT_COUNT, 10000).

%% Application callbacks
-export([start2k/1, start16k/1, insert/4]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start2k(Pid) ->
	{Ok, RiakPid} = riakc_pb_socket:start_link("localhost", 8087),
  spawn(?MODULE,insert,[?DOC2K,?INSERT_COUNT,Pid,RiakPid]).

start16k(Pid) ->
	{Ok, RiakPid} = riakc_pb_socket:start_link("localhost", 8087),
  spawn(?MODULE,insert,[?DOC16K,?INSERT_COUNT,Pid,RiakPid]).

insert(Document, Count, Pid, RiakPid) ->
  if 
    Count =/= 0 ->
			{MegaSec, Sec, MicroSec} = now(),
			Object = riakc_obj:new(<<"bench">>, <<MegaSec:32,Sec:32,MicroSec:32>>, Document),
      {ok,_} = riakc_pb_socket:put(RiakPid, Object, [return_body]),
			if 
        (Count rem 100) =:= 0 -> io:format(".");
        true -> ok
      end,
      insert(Document, (Count-1), Pid, RiakPid);

    true ->
			riakc_pb_socket:stop(RiakPid),
      Pid ! done
  end.
