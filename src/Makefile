BUILD = build
TEST = test

.PHONY: all
all:
	mkdir -p $(BUILD)
	bison -v -d parser.y -o $(BUILD)/parser.c
	flex -o$(BUILD)/lexer.c lexer.l 
	gcc $(BUILD)/lexer.c $(BUILD)/parser.c -o $(BUILD)/compiler.exe

.PHONY: test
test:
ifndef INPUT
	@echo Please specify the name of the test file
else
	./build/compiler.exe < ${TEST}/$(INPUT)
endif