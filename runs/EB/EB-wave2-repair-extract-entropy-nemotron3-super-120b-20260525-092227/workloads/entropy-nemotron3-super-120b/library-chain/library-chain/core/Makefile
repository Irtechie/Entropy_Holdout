CC = gcc
CFLAGS = -Wall -Wextra -std=c11

all: sample

sample: main.o libcore.a
\t$(CC) $(CFLAGS) -o sample main.o libcore.a

main.o: main.c core.h
\t$(CC) $(CFLAGS) -c main.c

libcore.a: core.o
\tar rcs libcore.a core.o

core.o: core.c core.h
\t$(CC) $(CFLAGS) -c core.c

clean:
\trm -f *.o libcore.a sample

