BUILD = build
TEST = test
CC = gcc
CXX = g++
CXXFLAGS = -Wall
TARGET = compiler

.PHONY: all
all:
	mkdir -p $(BUILD)
	bison -v -d -Wall parser.y -o $(BUILD)/parser.cc
	flex -o$(BUILD)/lexer.cc lexer.l 
	$(CXX) $(CXXFLAGS) -c $(BUILD)/lexer.cc -o $(BUILD)/lexer.o
	$(CXX) $(CXXFLAGS) -c $(BUILD)/parser.cc -o $(BUILD)/parser.o
	$(CXX) $(CXXFLAGS) -c tree/tree.cc -o $(BUILD)/tree.o
	$(CXX) $(CXXFLAGS) -c compiler.cc -o $(BUILD)/compiler.o
	$(CXX) $(CXXFLAGS) $(BUILD)/*.o -o $(BUILD)/${TARGET}.exe

.PHONY: test
test:
ifndef INPUT
	@echo Please specify the name of the test file
else
	cd $(BUILD); ./${TARGET}.exe < ../${TEST}/$(INPUT)
endif

.PHONY: show
show:
ifndef INPUT
	@echo Please specify the name of the test file
else
	cd $(BUILD); ./${TARGET}.exe < ../${TEST}/$(INPUT)
	cd $(BUILD); dot -Tpng -O parse_tree.dot
endif

.PHONY: clean
clean:
	rm -rf build