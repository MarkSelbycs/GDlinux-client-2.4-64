#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int copy_between(const char *start, const char *end, char *output,
                        size_t output_size)
{
    size_t length;

    if (start == NULL || end == NULL || end < start) {
        return 0;
    }

    length = (size_t)(end - start);
    if (length + 1 > output_size) {
        return 0;
    }

    memcpy(output, start, length);
    output[length] = '\0';
    return 1;
}

static int parse_error_line(const char *line, const char *wanted_id)
{
    const char *entry = strstr(line, "<err ");
    const char *id_start;
    const char *id_end;
    const char *legacy_separator;
    const char *value_start;
    const char *value_end;
    char id[64];

    if (entry == NULL) {
        return 0;
    }

    id_start = strstr(entry, "id=\"");
    if (id_start == NULL) {
        return 0;
    }
    id_start += strlen("id=\"");
    id_end = strchr(id_start, '"');
    if (id_end == NULL) {
        return 0;
    }

    legacy_separator = strstr(id_start, "':'");
    if (legacy_separator != NULL && legacy_separator < id_end) {
        if (!copy_between(id_start, legacy_separator, id, sizeof(id))) {
            return 0;
        }
        value_start = legacy_separator + strlen("':'");
        value_end = id_end;
    } else {
        if (!copy_between(id_start, id_end, id, sizeof(id))) {
            return 0;
        }
        value_start = strstr(id_end, "value=\"");
        if (value_start == NULL) {
            return 0;
        }
        value_start += strlen("value=\"");
        value_end = strchr(value_start, '"');
    }

    if (strcmp(id, wanted_id) != 0 || value_end == NULL) {
        return 0;
    }

    printf("%s=", wanted_id);
    fwrite(value_start, 1, (size_t)(value_end - value_start), stdout);
    putchar('\n');
    return 1;
}

int main(int argc, char **argv)
{
    FILE *input;
    char line[4096];
    int found = 0;

    if (argc != 3) {
        fprintf(stderr, "用法: %s <code.xml> <错误码>\n", argv[0]);
        return EXIT_FAILURE;
    }

    input = fopen(argv[1], "rb");
    if (input == NULL) {
        perror(argv[1]);
        return EXIT_FAILURE;
    }

    while (fgets(line, sizeof(line), input) != NULL) {
        if (parse_error_line(line, argv[2])) {
            found = 1;
            break;
        }
    }

    fclose(input);
    if (!found) {
        fprintf(stderr, "未找到错误码: %s\n", argv[2]);
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}