#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

static void usage(const char *program)
{
    fprintf(stderr, "用法: %s <ELF文件> [最小字符串长度]\n", program);
}

static int parse_min_length(const char *text, size_t *result)
{
    char *end = NULL;
    unsigned long value;

    errno = 0;
    value = strtoul(text, &end, 10);
    if (errno != 0 || end == text || *end != '\0' || value == 0) {
        return 0;
    }

    *result = (size_t)value;
    return 1;
}

static int print_strings(FILE *input, size_t minimum_length)
{
    char *buffer = NULL;
    size_t length = 0;
    size_t capacity = 0;
    int byte;

    while ((byte = fgetc(input)) != EOF) {
        if (isprint((unsigned char)byte) || byte == '\t') {
            if (length + 1 >= capacity) {
                size_t new_capacity = capacity == 0 ? 128 : capacity * 2;
                char *new_buffer = realloc(buffer, new_capacity);

                if (new_buffer == NULL) {
                    free(buffer);
                    fprintf(stderr, "内存分配失败\n");
                    return 0;
                }

                buffer = new_buffer;
                capacity = new_capacity;
            }
            buffer[length++] = (char)byte;
            continue;
        }

        if (length >= minimum_length) {
            buffer[length] = '\0';
            puts(buffer);
        }
        length = 0;
    }

    if (ferror(input)) {
        perror("读取文件失败");
        free(buffer);
        return 0;
    }

    if (length >= minimum_length) {
        buffer[length] = '\0';
        puts(buffer);
    }

    free(buffer);
    return 1;
}

int main(int argc, char **argv)
{
    const char *path;
    size_t minimum_length = 4;
    FILE *input;
    int success;

    if (argc < 2 || argc > 3) {
        usage(argv[0]);
        return EXIT_FAILURE;
    }

    path = argv[1];
    if (argc == 3 && !parse_min_length(argv[2], &minimum_length)) {
        fprintf(stderr, "最小字符串长度必须是正整数\n");
        return EXIT_FAILURE;
    }

    input = fopen(path, "rb");
    if (input == NULL) {
        perror(path);
        return EXIT_FAILURE;
    }

    success = print_strings(input, minimum_length);
    fclose(input);
    return success ? EXIT_SUCCESS : EXIT_FAILURE;
}