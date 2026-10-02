#include <stdio.h>
#include <stdlib.h>

static int run_thread(int active, int has_connection, int request_result,
                      unsigned long cycles)
{
    unsigned long counter = 0;

    while (active && cycles-- != 0) {
        if (!has_connection) {
            return 0;
        }
        if (counter == 600) {
            if (request_result == 1) {
                active = 0;
                break;
            }
        }
        if (counter == 600) {
            counter = 0;
        }
        ++counter;
    }
    return active;
}

int main(int argc, char **argv)
{
    int active;
    int has_connection;
    int request_result;
    unsigned long cycles;

    if (argc != 5) {
        fprintf(stderr,
                "用法: %s <active> <has-connection> <request-result> <cycles>\n",
                argv[0]);
        return EXIT_FAILURE;
    }
    active = atoi(argv[1]) != 0;
    has_connection = atoi(argv[2]) != 0;
    request_result = atoi(argv[3]);
    cycles = strtoul(argv[4], NULL, 10);
    printf("active=%d\n",
           run_thread(active, has_connection, request_result, cycles));
    return EXIT_SUCCESS;
}