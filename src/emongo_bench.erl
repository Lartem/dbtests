-module(emongo_bench).

-include("docs.hrl").

-define(INSERT_COUNT, 10000).
%% Application callbacks
-export([start2k/0, start16k/0, insert/2]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start2k() ->
  spawn(?MODULE,insert,[?DOC2K,?INSERT_COUNT]).

start16k() ->
  spawn(?MODULE,insert,[?DOC16K,?INSERT_COUNT]).


insert(Document, Count) ->
  if 
    Count =/= 0 ->
      emongo:insert(emongo_testpool, test_collection, []),
      insert(Document, Count-1);

    true -> ok
  end.
