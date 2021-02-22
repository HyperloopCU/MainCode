.PHONY: clean

all: compile run

compile:
	g++ -c ../BaseSensorHandler.cpp
	g++ -c testInterrupt.cpp
	g++ BaseSensorHandler.o testInterrupt.o -o test.out

run:
	@./test.out

clean:
	rm test.out
	rm testInterrupt.o
	rm BaseSensorHandler.o