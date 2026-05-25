CC = gcc
CFLAGS = -Wall -Wextra -I.
TARGET = feature_sample

all: $(TARGET)

$(TARGET): main.c src/feature_lib.c ../core/src/core_lib.c
	$(CC) $(CFLAGS) -o $(TARGET) main.c src/feature_lib.c ../core/src/core_lib.c

clean:
	rm -f $(TARGET)

