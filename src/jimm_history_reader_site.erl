-module(jimm_history_reader_site).

-export([start/0, stop/0]).
-export([start/2, stop/1]).

%% API
start() ->
    start_application(?MODULE).

stop() ->
    application:stop(?MODULE).


%% Application callbacks
start(normal, _StartArgs) ->
    jimm_history_reader_site_sup:start_link().

stop(_State) ->
    ok.


%% local
start_application(AppName) ->
    case application:start(AppName) of
        ok -> 
            ok;
        {error, {already_started, AppName}} -> 
            ok;
        {error, {not_started, _}} -> 
            start_dependencies(AppName),
            application:start(AppName);
        Error ->
            Error
    end.

start_dependencies(AppName) ->
    Live = [ A || {A, _, _} <- application:which_applications() ],
    Deps = lists:reverse(gather_deps(AppName, []) -- [AppName | Live]),
    [ ok = application:start(Dep) || Dep <- Deps ],
    Deps.

gather_deps(AppName, Acc) ->
    case lists:member(AppName, Acc) of
        true -> 
            Acc;
        _    ->
            application:load(AppName),
            case application:get_key(AppName, applications) of
                {ok, DepsList} -> [AppName | lists:foldl(fun gather_deps/2, Acc, DepsList)];
                _              -> [AppName | Acc]
            end
    end.
