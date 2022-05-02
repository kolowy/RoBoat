cc = ocamlfind ocamlc

modules = api
debug = ${wildcard debug/*.ml}
debugcmo = ${patsubst %.ml,%.cmo,$(debug)}

files = ${foreach d,$(modules),$(wildcard $(d)/*.ml)}
cmo = ${patsubst %.ml,%.cmo,$(files)} 
trash = ${patsubst %.ml,%.cmi,$(files)}

packages = cohttp cohttp-lwt cohttp-lwt-unix graphics

flags = -thread -linkpkg
out = main.exe

rm = rm -f ${out} ${cmo} ${trash}

main: compile run clean

debug: compile_debug run clean_debug

compile_debug:
	${cc} -c ${foreach p,$(packages),-package $(p)} ${files} ${debug} ${flags}
	${cc} ${foreach p,$(packages),-package $(p)} ${cmo} ${debugcmo} ${flags} -o ${out}


compile:
	${cc} -c ${foreach p,$(packages),-package $(p)} ${files} ${flags}
	${cc} ${foreach p,$(packages),-package $(p)} ${cmo} ${flags} -o ${out}

run:
	./${out}

clean_debug:
	${rm} ${patsubst %.ml,%.cmo,$(debug)} ${patsubst %.ml,%.cmi,$(debug)}

clean:
	${rm}
