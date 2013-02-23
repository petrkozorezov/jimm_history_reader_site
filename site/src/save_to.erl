%% -*- mode: nitrogen -*-
-module(save_to).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() ->
    {Format, ContentType} = 
        case wf:qs(format) of
            []          -> {txt, "text/plain"};
            ["txt"]     -> {txt, "text/plain"};
            ["csv"]     -> {csv, "text/csv"}
        end,
    wf:header("Content-Type", ContentType),
    [FileName] = wf:qs(file),
    Data = wf:session("file_"++FileName),

    io:format("~p~n", [wf:session("file_"++FileName)]),

    render(Format, Data).

render(Format, Messages) ->
    [render_msg(Format, Msg) || Msg <- Messages].

render_msg(txt, {message, _Direction, Author, Text, Date}) ->
    io_lib:format("~s ~s: ~s~n", [Date, Author, Text]);
render_msg(csv, {message, _Direction, Author, Text, Date}) ->
    io_lib:format("~s;~s;~s~n", [Date, Author, Text]).