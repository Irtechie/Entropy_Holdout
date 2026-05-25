CC = gcc
CFLAGS = -Wall -Wextra -std=c11
CORE_DIR = ../core

all: sample

sample: main.o libfeature.a
	$(CC) $(CFLAGS) -o sample main.o libfeature.a -L$(CORE_DIR) -lcore

main.o: main.c feature.h
	$(CC) $(CFLAGS) -c main.c

libfeature.a: feature.o
	ar rcs libfeature.a feature.o

feature.o: feature.c feature.h core.h
	$(CC) $(CFLAGS) -I$(CORE_DIR) -c feature.c

clean:
	rm -f *.o libfeature.a sample

