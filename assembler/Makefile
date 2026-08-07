CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra

TARGET = assembler

SRCS = main.cpp helper.cpp

OBJS = $(SRCS:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)

main.o: main.cpp helper.h constant.h
	$(CXX) $(CXXFLAGS) -c main.cpp

helper.o: helper.cpp helper.h
	$(CXX) $(CXXFLAGS) -c helper.cpp

clean:
	rm -f $(TARGET) $(OBJS) machine_code.txt