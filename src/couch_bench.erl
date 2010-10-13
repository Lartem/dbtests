-module(couch_bench).

-include("docs.hrl").

-define(INSERT_COUNT, 10000).
%% Application callbacks
-export([start2k/1, start16k/1, insert/3]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start2k(Pid) ->
  spawn(?MODULE,insert,[?DOC2K,?INSERT_COUNT,Pid]).

start16k(Pid) ->
  spawn(?MODULE,insert,[?DOC16K,?INSERT_COUNT,Pid]).


insert(Document, Count, Pid) ->
  if 
    Count =/= 0 ->
      erlang_couchdb:create_document({"localhost", 5984}, "bench", [{<<"content">>, Document}]),
      if 
        (Count rem 100) =:= 0 -> io:format(".");
        true -> ok
      end,
      insert(Document, (Count-1), Pid );

    true -> 
      Pid ! done
  end.

