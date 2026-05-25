CC = gcc
CFLAGS = -Wall -Wextra -I.
TARGET = pipeline_sample

all: $(TARGET)

$(TARGET): main.c src/pipeline_lib.c ../feature/src/feature_lib.c ../core/src/core_lib.c
	$(CC) $(CFLAGS) -o $(TARGET) main.c src/pipeline_lib.c ../feature/src/feature_lib.c ../core/src/core_lib.c

clean:
	rm -f $(TARGET)

