cc = dune


main: build run

build:
	${cc} build main.exe

run:
	${cc} exec ./main.exe

clear:
	${cc} clean
