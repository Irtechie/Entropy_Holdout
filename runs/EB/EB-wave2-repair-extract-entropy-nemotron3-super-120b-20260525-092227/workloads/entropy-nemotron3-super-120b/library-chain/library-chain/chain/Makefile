CC = gcc
CFLAGS = -Wall -Wextra -std=c11

CORE_DIR = ../core
FEATURE_DIR = ../feature
LIB_CORE = $(CORE_DIR)/libcore.a
LIB_FEATURE = $(FEATURE_DIR)/libfeature.a

all: chain-sample

$(LIB_CORE):
	$(MAKE) -C $(CORE_DIR) libcore.a

$(LIB_FEATURE):
	$(MAKE) -C $(FEATURE_DIR) libfeature.a

libchain.a: chain.o
	ar rcs libchain.a chain.o

chain.o: chain.c chain.h
	$(CC) $(CFLAGS) -c chain.c -I$(CORE_DIR) -I$(FEATURE_DIR)

chain-sample: main.o libchain.a $(LIB_FEATURE) $(LIB_CORE)
	$(CC) $(CFLAGS) -o chain-sample main.o libchain.a $(LIB_FEATURE) $(LIB_CORE)

main.o: main.c chain.h
	$(CC) $(CFLAGS) -c main.c -I$(CORE_DIR) -I$(FEATURE_DIR)

clean:
	rm -f *.o libchain.a chain-sample

