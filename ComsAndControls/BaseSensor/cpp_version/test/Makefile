.PHONY: clean

all: compile run

compile:
	g++ -c ../BaseSensorHandler.cpp
	# g++ -c testInterrupt.cpp
	# g++ -c testAll.cpp
	g++ -c testLoad.cpp
	# g++ BaseSensorHandler.o testInterrupt.o -o test.out
	# g++ BaseSensorHandler.o testAll.o -o testAll.out
	g++ BaseSensorHandler.o testLoad.o -o testLoad.out

run:
	@./test.out

clean:
	rm -f test.out
	rm -f testInterrupt.o
	rm -f BaseSensorHandler.o
	rm -f testAll.o
	rm -f testAll.out
	rm -f testLoad.o
	rm -f testLoad.out