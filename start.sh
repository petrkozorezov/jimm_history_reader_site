#!/bin/bash
ROOT=$(dirname $0)
ERL_LIBS=${ROOT}/deps erl -pa ebin -config default -s jimm_history_reader_site -sname jimm_history_reader_site@localhost -setcookie test  -sync sync_mode nitrogen
