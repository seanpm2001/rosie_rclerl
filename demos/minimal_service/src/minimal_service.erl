-module(minimal_service).

-behaviour(gen_server).


-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2]).


% We are going to use AddTwoInts.msg, so we include its header to use its record definition.
-include_lib("example_interfaces/src/_rosie/add_two_ints_srv.hrl").

-record(state,{ ros_node,
                ros_service}).

start_link() -> 
        gen_server:start_link(?MODULE, #state{}, []).

handle_request(#add_two_ints_rq{a=A,b=B}) -> 
        io:format("[ROSIE] Received request for: ~p ~p\n",[A,B]),
        #add_two_ints_rp{r = A + B }.

init(S) -> 
        Node = ros_context:create_node("minimal_server"),

        Service = ros_node:create_service(Node, add_two_ints_srv, fun handle_request/1),

        {ok,S#state{ros_node=Node, ros_service=Service}}.
handle_call(_,_,S) -> {reply,ok,S}.
handle_cast(_,S) -> {noreply,S}.

