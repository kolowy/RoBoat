cc = ocamlfind ocamlc
api = ${wildcard api/*.ml}
cmo = ${patsubst %.ml,%.cmo,$(api)}

packages = lwt cohttp cohttp-lwt-unix

flags = -o
main = main

exe = ./
out = ${main}.exe
rm = rm -f ${out} *.cmi *.cmo

main: run clean

compile:
	${cc} -c ${foreach p,$(packages),-package $(p)} ${api}
	${cc} ${foreach p,$(packages),-package $(p)} ${cmo} -o ${out}

run: compile
	${exe}${out}

clean:
	${rm}


# marking end of file can avoid problems
# make parsing strategy if your editor doesn't
# close the line for you.
# END
