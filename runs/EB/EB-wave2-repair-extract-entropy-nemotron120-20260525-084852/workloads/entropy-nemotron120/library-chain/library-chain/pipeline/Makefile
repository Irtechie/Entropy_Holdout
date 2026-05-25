CC = gcc
CFLAGS = -Wall -Wextra -std=c11
CORE_DIR = ../core
FEATURE_DIR = ../feature

all: sample

sample: main.o libpipeline.a
	$(CC) $(CFLAGS) -o sample main.o libpipeline.a -L$(FEATURE_DIR) -lfeature -L$(CORE_DIR) -lcore

main.o: main.c pipeline.h
	$(CC) $(CFLAGS) -c main.c

libpipeline.a: pipeline.o
	ar rcs libpipeline.a pipeline.o

pipeline.o: pipeline.c pipeline.h feature.h
	$(CC) $(CFLAGS) -I$(FEATURE_DIR) -I$(CORE_DIR) -c pipeline.c

clean:
	rm -f *.o libpipeline.a sample

