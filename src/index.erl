%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./templates/bare.html" }.

title() -> "Jimm history file reader".

body() ->
    #container_12 { body=[
        #grid_4 { alpha=true, prefix=2, suffix=0, omega=true, body=header_l() },
        #grid_4 { alpha=true, prefix=0, suffix=2, omega=true, body=header_r() },
        #grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=[#hr{}] },
        #grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() }
    ]}.


header_l() ->
    #h2 { text="Jimm history file reader"}.

header_r() ->
    #p{style="text-align:right; color:gray", text="Tool by Petr Kozorezov"}.

inner_body() -> 
    [
        % #dropdown { id=vendor, value="nokia", options=[
        %     #option { text="Nokia"  , value="nokia" },
        %     #option { text="Siemens", value="siemens" }
        % ]},
        #radiogroup { id=vendor, body=[
            #radio { text="Nokia"  , value="nokia"  , checked=true }, #br{},
            #radio { text="Siemens", value="siemens"},                 #br{}
        ]},
        #upload { tag=history_file, show_button=false, button_text="Upload a file" },
        #hr{},
        #panel { id=history_placeholder, body=[] }
    ].


event(_) ->
    ok.

start_upload_event(history_file) ->
    ok.

finish_upload_event(history_file, undefined, _, _) ->
    ok;

finish_upload_event(history_file, FileName, LocalFileName, _) ->
    CorruptedFile = #p{style="text-align:center", text="This file is corrupted."},
    Render = 
        try 
            History = jimm_history_reader:read_file(wf:q(vendor), LocalFileName),
            ok = file:delete(LocalFileName),

            wf:session("file_"++FileName, History),
            % io:format("~p~n", [wf:session("file_"++FileName)]),

            [
                #panel{style="text-align:center", body=[
                    #link{text="Save as txt", url="/export?format=txt&file="++FileName},
                    " | ",
                    #link{text="Save as csv", url="/export?format=csv&file="++FileName}
                ]},
                render_messages(History)
            ]
        catch
            throw:currupted_file   -> CorruptedFile;
            throw:currupted_header -> CorruptedFile;
            _    :Error          -> io_lib:format("unexpected error: ~n~p~n~p", [erlang:get_stacktrace(), Error])
        end,
    wf:replace(history_placeholder, #panel { id=history_placeholder, body=[Render, #hr{}]}).


render_messages([]) ->
    #p{style="text-align:center", text="This file is empty."};
render_messages(Messages) ->
    [render_message(Msg) || Msg <- Messages].

render_message({message, _Direction, Author, Text, Date}) ->
    [
        #p{},
        #span{style="color:silver", text=Date},
        "  ",
        #span{style="color:gray", text=Author},
        #br{},
        Text,
        #br{}
    ].
