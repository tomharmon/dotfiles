
BIN  := EXECUTABLE_NAME
SRCS := $(wildcard src/*.cpp)
OBJS := $(SRCS:.cpp=.o)
HDRS := $(wildcard include/*.h)

CFLAGS := -g -std=gnu++11
LDLIBS :=

$(BIN): $(OBJS)
	g++ -o $@ $(OBJS) $(LDLIBS)

%.o : %.cpp $(HDRS)
	g++ $(CFLAGS) -c -o $@ $<

clean:
	rm -rf *.o $(BIN) valgrind.out

valgrind: $(BIN)
	valgrind -q --leak-check=full --log-file=valgrind.out ./$(BIN)

.PHONY: clean