-module(helper).

-export([get_body/2]).
-export([get_model/3]).
-export([reply/3]).

get_body(Body, Req) ->
  case Body of 
    [{Input, true}] ->
      {ok, Input, Req};
    [] ->
      {error, empty, reply(400, <<"Missing body">>, Req)};
    _ ->
      {error, empty, reply(400, <<"Bad request">>, Req)}
  end.

get_model(Input, Model, Req) ->
  try jiffy:decode(Input, [return_maps]) of
    Data ->
        emodel:from_map(Data, #{}, Model)
  catch
    _:_ ->
        {error, empty, reply(400, <<"Invalid json">>, Req)}
  end.

reply(Code, Body, Req) ->
  cowboy_req:reply(Code, #{<<"content-type">> => <<"application/json">>}, jiffy:encode(Body), Req).