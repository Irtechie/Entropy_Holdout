CC = gcc
CFLAGS = -Wall -Wextra -std=c11

CORE_DIR = ../core
FEATURE_DIR = ../feature
LIB_CORE = $(CORE_DIR)/libcore.a
LIB_FEATURE = $(FEATURE_DIR)/libfeature.a

all: pipeline-sample

$(LIB_CORE):
	$(MAKE) -C $(CORE_DIR) libcore.a

$(LIB_FEATURE):
	$(MAKE) -C $(FEATURE_DIR) libfeature.a

libpipeline.a: pipeline.o
	ar rcs libpipeline.a pipeline.o

pipeline.o: pipeline.c pipeline.h
	$(CC) $(CFLAGS) -c pipeline.c -I$(CORE_DIR) -I$(FEATURE_DIR)

pipeline-sample: main.o libpipeline.a $(LIB_FEATURE) $(LIB_CORE)
	$(CC) $(CFLAGS) -o pipeline-sample main.o libpipeline.a $(LIB_FEATURE) $(LIB_CORE)

main.o: main.c pipeline.h
	$(CC) $(CFLAGS) -c main.c -I$(CORE_DIR) -I$(FEATURE_DIR)

clean:
	rm -f *.o libpipeline.a pipeline-sample

