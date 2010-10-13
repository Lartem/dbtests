./rebar compile

exec erl -pa $PWD/ebin $PWD/deps/*/ebin -s dbtests

