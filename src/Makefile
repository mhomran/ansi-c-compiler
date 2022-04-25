BUILD = build
TEST = test
CC = gcc
CXX = g++
TARGET = compiler

.PHONY: all
all:
	mkdir -p $(BUILD)
	bison -v -d parser.y -o $(BUILD)/parser.cc
	flex -o$(BUILD)/lexer.c lexer.l 
	$(CC) -c $(BUILD)/lexer.c -o $(BUILD)/lexer.o
	$(CXX) $(BUILD)/lexer.o $(BUILD)/parser.cc compiler.cc -o $(BUILD)/${TARGET}.exe

.PHONY: test
test:
ifndef INPUT
	@echo Please specify the name of the test file
else
	./$(BUILD)/${TARGET}.exe < ${TEST}/$(INPUT)
endif