BUILD_DIR     := build
SRC_DIR       := src
TEST          := test

SRCS          := $(shell find $(SRC_DIR) -name "*.cc" -or -name "*.l" -or -name "*.y")
OBJS          := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS          := $(OBJS:.o=.d)
INC_DIRS      := $(shell find $(SRC_DIR) -type d)
INC_FLAGS     := $(addprefix -I,$(INC_DIRS))

TARGET        := compiler
CXX           := g++
OBJCOPY       := objcopy
GDB           := gdb
SIZE          := size
CXXFLAGS      := -Wall -MMD -MP $(INC_FLAGS) 
LDFLAGS       := -Wl,-Map=$(BUILD_DIR)/$(TARGET).map
BISONFLAGS    := -v -d -Wall

$(BUILD_DIR)/$(TARGET): $(OBJS)
	$(CXX) $(OBJS) $(LDFLAGS) -o $@.exe

$(BUILD_DIR)/%.cc.o: %.cc
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.l.o: %.l $(BUILD_DIR)/%.y.o
	mkdir -p $(dir $@)
	flex -o$@.cc $< 
	$(CXX) $(CXXFLAGS) -c $@.cc -o $@

$(BUILD_DIR)/%.y.o: %.y
	mkdir -p $(dir $@)
	bison $(BISONFLAGS) $< -o $@.cc
	$(CXX) $(CXXFLAGS) -c $@.cc -o $@

-include $(DEPS)

.PHONY: clean
clean:
	$(RM) -r $(BUILD_DIR)

.PHONY: gdb
gdb: 
	$(GDB) $(BUILD_DIR)/$(TARGET).exe

.PHONY: test
test:
ifndef INPUT
	@echo Please specify the name of the test file
else
	cd $(BUILD_DIR); ./$(TARGET).exe < ../${TEST}/$(INPUT)
endif

.PHONY: show_ast
show_ast:
ifndef INPUT
	@echo Please specify the name of the test file
else
	cd $(BUILD_DIR); ./${TARGET}.exe < ../${TEST}/$(INPUT)
	cd $(BUILD_DIR); dot -Tpng -O AST.dot
endif

.PHONY: show_pst
show_pst:
ifndef INPUT
	@echo Please specify the name of the test file
else
	cd $(BUILD_DIR); ./${TARGET}.exe < ../${TEST}/$(INPUT)
	cd $(BUILD_DIR); dot -Tpng -O parse_tree.dot
endif