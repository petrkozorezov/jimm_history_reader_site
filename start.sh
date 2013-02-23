#!/bin/bash
ROOT=$(dirname $0)
ERL_LIBS=${ROOT}/deps erl -pa ebin -noshell -boot start_sasl -config default -s jimm_history_reader_site -sync sync_mode nitrogen
