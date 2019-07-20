CXX		  := g++
CXX_FLAGS := -Wall -Wextra -std=c++17 -ggdb `sdl2-config --cflags` -DIMGUI_IMPL_OPENGL_LOADER_GLAD

OPENGL_API := 4.5
GLAD_BUILD_DIR := glad

IMGUI_DIR := imgui
IMGUI_SRC := $(IMGUI_DIR)/examples/imgui_impl_sdl.cpp $(IMGUI_DIR)/examples/imgui_impl_opengl3.cpp
IMGUI_SRC += $(IMGUI_DIR)/imgui.cpp $(IMGUI_DIR)/imgui_demo.cpp $(IMGUI_DIR)/imgui_draw.cpp $(IMGUI_DIR)/imgui_widgets.cpp

BIN		:= bin
SRC		:= src
INCLUDE	:= include
LIB		:= lib

LIBRARIES	:= `sdl2-config --libs` -ldl
EXECUTABLE	:= main


all: $(BIN)/$(EXECUTABLE)

run: clean all
	clear
	./$(BIN)/$(EXECUTABLE)

$(GLAD_BUILD_DIR)/src/*.c:
	python -m glad --out-path=$(GLAD_BUILD_DIR) --api="gl=$(OPENGL_API)" --extensions="GL_KHR_debug" --generator="c"

$(BIN)/$(EXECUTABLE): $(SRC)/*.cpp $(GLAD_BUILD_DIR)/src/*.c $(IMGUI_SRC)
	$(CXX) $(CXX_FLAGS) -I$(INCLUDE) -I$(GLAD_BUILD_DIR)/include -I$(IMGUI_DIR) -I$(IMGUI_DIR)/examples -L$(LIB) $^ -o $@ $(LIBRARIES)

clean:
	rm -rf $(BIN)/*
	rm -rf $(GLAD_BUILD_DIR)
