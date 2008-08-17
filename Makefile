LFE_PATH=${HOME}/lfe0.2/

all:
	@erl -noshell -pa ${LFE_PATH} -eval 'code:load_file(lfe_comp).' -eval 'case lfe_comp:file(hd(init:get_plain_arguments())) of {error,X,AR} -> io:format("~p~n",[X]), halt(1) ; {ok,X,AR} -> io:format("~p ~p~n",[X,AR]), halt(0) end.' \
-extra myhello.lfe

start:
	@erl -noshell -pa ${LFE_PATH} \
-eval 'code:load_file(myhello).' \
-eval 'myhello:start().' \
-s erlang halt

clean:
	@rm -f *.beam *.dump
