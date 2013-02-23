-module(heroku).
-export([port/1]).

port(DefaultPort) ->
    case os:getenv("PORT") of
        false -> DefaultPort;
        PortStr -> list_to_integer(PortStr)
    end. 
