.PHONY: clean

all: compile run

compile:
	g++ -c ../BaseSensorHandler.cpp
	# g++ -c testInterrupt.cpp
	g++ -c testAll.cpp
	# g++ BaseSensorHandler.o testInterrupt.o -o test.out
	g++ BaseSensorHandler.o testAll.o -o testAll.out

run:
	@./test.out

clean:
	rm -f test.out
	rm -f testInterrupt.o
	rm -f BaseSensorHandler.o
	rm -f testAll.o
	rm -f testAll.out