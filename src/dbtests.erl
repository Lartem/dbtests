%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.
-module(dbtests).

-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start() -> ok
%% @doc Start the gangs server.
start() ->
    dbtests_deps:ensure(),

%    ensure_started(emongo),
%    emongo:add_pool(emongopool, "localhost", 27017, "test", 10),

    application:start(dbtests).

%% @spec stop() -> ok
%% @doc Stop the gangs server.
stop() ->
    Res = application:stop(dbtests),
    application:stop(emongo),
    Res.

