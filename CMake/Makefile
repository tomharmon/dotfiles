
BIN  := EXECUTABLE_NAME
SRCS := $(wildcard src/*.c)
OBJS := $(SRCS:.c=.o)
HDRS := $(wildcard include/*.h)

CFLAGS := -g -std=gnu11
LDLIBS :=

$(BIN): $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDLIBS)

%.o : %.c $(wildcard *.h)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf *.o $(BIN) valgrind.out

valgrind: $(BIN)
	valgrind -q --leak-check=full --log-file=valgrind.out ./$(BIN)

.PHONY: clean
