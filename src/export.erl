%% -*- mode: nitrogen -*-
-module(export).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() ->
    {Format, ContentType} = 
        case wf:qs(format) of
            []          -> {txt, "text/plain"};
            ["txt"]     -> {txt, "text/plain"};
            ["csv"]     -> {csv, "text/csv"}
        end,

    [FileName] = wf:qs(file),
    Data = wf:session("file_"++FileName),

    wf:header("Content-Type", ContentType),
    wf:header("Content-Disposition", "attachment; filename="++FileName++"."++atom_to_list(Format)),

    render(Format, Data).

render(Format, Messages) ->
    [render_msg(Format, Msg) || Msg <- Messages].

render_msg(txt, {message, _Direction, Author, Text, Date}) ->
    io_lib:format("~s ~s: ~s~n", [Date, Author, Text]);
render_msg(csv, {message, _Direction, Author, Text, Date}) ->
    io_lib:format("~s;~s;~s~n", [Date, Author, Text]).