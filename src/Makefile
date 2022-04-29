BUILD = build
TEST = test
CC = gcc
CXX = g++
TARGET = compiler

.PHONY: all
all:
	mkdir -p $(BUILD)
	bison -v -d -Wall parser.y -o $(BUILD)/parser.cc
	flex -o$(BUILD)/lexer.cc lexer.l 
	$(CXX) -c $(BUILD)/lexer.cc -o $(BUILD)/lexer.o
	$(CXX) -c $(BUILD)/parser.cc -o $(BUILD)/parser.o
	$(CXX) -c tree/tree.cc -o $(BUILD)/tree.o
	$(CXX) -c compiler.cc -o $(BUILD)/compiler.o
	$(CXX) $(BUILD)/*.o -o $(BUILD)/${TARGET}.exe

.PHONY: test
test:
ifndef INPUT
	@echo Please specify the name of the test file
else
	cd $(BUILD); ./${TARGET}.exe < ../${TEST}/$(INPUT)
endif

.PHONY: clean
clean:
	rm -rf build