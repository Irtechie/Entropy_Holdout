CC = gcc
CFLAGS = -Wall -Wextra -std=c11

CORE_DIR = ../core
LIB_CORE = $(CORE_DIR)/libcore.a

all: feature-sample

$(LIB_CORE):
	$(MAKE) -C $(CORE_DIR) libcore.a

libfeature.a: feature.o
	ar rcs libfeature.a feature.o

feature.o: feature.c feature.h
	$(CC) $(CFLAGS) -c feature.c -I$(CORE_DIR)

feature-sample: main.o libfeature.a $(LIB_CORE)
	$(CC) $(CFLAGS) -o feature-sample main.o libfeature.a $(LIB_CORE)

main.o: main.c feature.h
	$(CC) $(CFLAGS) -c main.c -I$(CORE_DIR)

clean:
	rm -f *.o libfeature.a feature-sample

