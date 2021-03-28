SVF := build/marsohod2-picorv32-wb-soc_0/bld-quartus/marsohod2-picorv32-wb-soc_0.svf

all: $(SVF)

$(SVF):
	fusesoc --cores-root cores/ run --build --tool quartus \
		$(subst _0.svf,,$(@F))

load: $(SVF)
	openocd -f board/marsohod2.cfg		\
		-c init				\
		-c "svf -tap ep3c10.tap $<"	\
		-c shutdown

clean:
	rm -rf build
