#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int write_payload(const char *path, const char *payload)
{
    FILE *file;
    size_t length = strlen(payload);

    file = fopen(path, "wb");
    if (file == NULL) {
        return -1;
    }
    if (length != 0 && fwrite(payload, 1, length, file) != length) {
        fclose(file);
        return -1;
    }
    if (fclose(file) != 0) {
        return -1;
    }
    return 1;
}

static int update(const char *path, const char *payload, int has_payload)
{
    if (!has_payload) {
        return 0;
    }
    return write_payload(path, payload);
}

int main(int argc, char **argv)
{
    int result;

    if (argc != 4) {
        fprintf(stderr, "用法: %s <zsm-path> <payload|NULL> <has-payload>\n",
                argv[0]);
        return EXIT_FAILURE;
    }

    result = update(argv[1], argv[2], atoi(argv[3]) != 0);
    printf("update-result=%d\n", result);
    if (result < 0) {
        fprintf(stderr, "写入失败: %s\n", strerror(errno));
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}