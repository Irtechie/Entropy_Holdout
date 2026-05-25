#ifndef CONTRACT_H
#define CONTRACT_H

/* Shared contract for the library chain.
 * All libraries must include this header and implement functions
 * that adhere to the common interface. */
#define CHAIN_INTERFACE_VERSION 1

/* Common operation signature */
typedef int (*chain_op_t)(int, int);

#endif

