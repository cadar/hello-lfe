MAIN=hello
LFE_EBIN=${HOME}/lfe/ebin/
ERL_LOAD='code:load_file(lfe_comp).'
ERL_COMP='File=hd(init:get_plain_arguments()), try lfe_comp:file(File,[report,{outdir,"."}]) of {ok,_Module} -> halt(0); error -> halt(1); All -> io:format("./~s:1: ~p~n",[File,All]) catch X:Y -> io:format("./~s:1: Catch outside of compiler: ~p ~p ~n",[File,X,Y]) end, halt(1).'

all: ${MAIN}.beam start

%.beam : %.lfe
	@echo Recompile: $<
	@erl -pa ${LFE_EBIN} -noshell -eval $(ERL_LOAD) -eval $(ERL_COMP) -extra $< 

start: ${MAIN}.beam
	@erl -noshell -pa ${LFE_EBIN} -eval 'code:load_file(${MAIN}).' -eval '${MAIN}:start().' -s erlang halt

clean:
	@rm -f *.beam *.dump *.out *.err

# syntax-check works only on main file.
# Solution: Work in main, Iron out to sub files. :(
check-syntax:
	@erl -noshell -pa ${LFE_EBIN} \
	-eval 'code:load_file(lfe_comp).' \
	-eval 'File=hd(init:get_plain_arguments()), \
	       try lfe_comp:file(File) of \
	          {ok,_Module} -> halt(0); \
	          error -> halt(0); \
	          All   -> io:format("./~s:1: ~p (All)~n",[File,All]) \
	       catch X:Y -> io:format("./~s:1: Makefile catch: ~p ~p~n", [File,X,Y]) end, \
			    halt(0).' \
	-extra ${MAIN}_flymake.lfe 2> compile.err | sed 's/:none:/:1:/' | tee compile.out
	rm ${MAIN}_flymake.beam


help:
	@echo ";; Copy to .emacs, then restart."
	@echo "(when (load \"flymake\" t)"
	@echo "  (setq flymake-log-level 3)"
	@echo "  (add-hook 'find-file-hook 'flymake-find-file-hook)"
	@echo "  (add-to-list 'flymake-allowed-file-name-masks"
	@echo "	       '(\"\\\\\.lfe\\\\\'\" flymake-simple-make-init)))"
