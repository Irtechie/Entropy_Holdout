CC = gcc
CFLAGS = -Wall -Wextra -I.
TARGET = core_sample

all: $(TARGET)

$(TARGET): main.c src/core_lib.c
	$(CC) $(CFLAGS) -o $(TARGET) main.c src/core_lib.c

clean:
	rm -f $(TARGET)

