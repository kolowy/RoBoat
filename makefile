cc = ocamlfind ocamlc
api = ${wildcard api/*.ml}
cmo = ${patsubst %.ml,%.cmo,$(api)}

packages = cohttp cohttp-lwt cohttp-lwt-unix

flags = -thread -linkpkg
main = main

exe = ./
out = ${main}.exe
rm = rm -f ${out} *.cmi *.cmo

main: run clean

compile:
	${cc} -c ${foreach p,$(packages),-package $(p)} ${api} ${flags}
	${cc} ${foreach p,$(packages),-package $(p)} ${cmo} -o ${out} ${flags}

run: compile
	${exe}${out}

clean:
	${rm}


# marking end of file can avoid problems
# make parsing strategy if your editor doesn't
# close the line for you.
# END
