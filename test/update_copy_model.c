#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int copy_file(const char *source, const char *destination)
{
    FILE *input = fopen(source, "rb");
    FILE *output;
    unsigned char buffer[8192];
    size_t count;

    if (input == NULL) {
        return 0;
    }
    output = fopen(destination, "wb");
    if (output == NULL) {
        fclose(input);
        return 0;
    }
    while ((count = fread(buffer, 1, sizeof(buffer), input)) != 0) {
        if (fwrite(buffer, 1, count, output) != count) {
            fclose(output);
            fclose(input);
            return 0;
        }
    }
    if (ferror(input) || fclose(output) != 0) {
        fclose(input);
        return 0;
    }
    fclose(input);
    return 1;
}

static int make_path(char *result, size_t result_size,
                     const char *directory, const char *name)
{
    int written = snprintf(result, result_size, "%s/%s", directory, name);

    return written >= 0 && (size_t)written < result_size;
}

static int copy_update_file(const char *update_dir, const char *decompress_dir,
                            const char *backup_dir)
{
    char update_path[4096];
    char decompress_path[4096];
    char backup_path[4096];
    const char *source;

    if (!make_path(update_path, sizeof(update_path), update_dir,
                   "AutoUpdate.dll") ||
        !make_path(decompress_path, sizeof(decompress_path), decompress_dir,
                   "AutoUpdate.dll") ||
        !make_path(backup_path, sizeof(backup_path), backup_dir,
                   "AutoUpdate.dll")) {
        return 0;
    }
    source = access(update_path, F_OK) == 0 ? update_path : decompress_path;
    return copy_file(source, backup_path);
}

int main(int argc, char **argv)
{
    if (argc == 5 && strcmp(argv[1], "copy") == 0) {
        int result = copy_update_file(argv[2], argv[3], argv[4]);

        printf("copy-update=%d\n", result);
        return result ? EXIT_SUCCESS : EXIT_FAILURE;
    }
    fprintf(stderr, "用法: %s copy <updateDir> <decompressDir> <backupPath>\n",
            argv[0]);
    return EXIT_FAILURE;
}