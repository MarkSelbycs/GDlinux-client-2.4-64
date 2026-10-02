#define _GNU_SOURCE

#include <dlfcn.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static int copy_file(const char *source, const char *destination)
{
    char buffer[8192];
    int input;
    int output;
    ssize_t count;

    input = open(source, O_RDONLY | O_CLOEXEC);
    if (input < 0) {
        return -1;
    }
    output = open(destination, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC,
                  0700);
    if (output < 0) {
        close(input);
        return -1;
    }
    while ((count = read(input, buffer, sizeof(buffer))) > 0) {
        ssize_t written = 0;

        while (written < count) {
            ssize_t result = write(output, buffer + written, count - written);

            if (result <= 0) {
                close(input);
                close(output);
                return -1;
            }
            written += result;
        }
    }
    close(input);
    close(output);
    return count == 0 ? 0 : -1;
}

int unlink(const char *path)
{
    static int (*real_unlink)(const char *);
    const char *destination = getenv("CAPTURE_PROTECT_DEST");

    if (real_unlink == NULL) {
        void *symbol = dlsym(RTLD_NEXT, "unlink");

        memcpy(&real_unlink, &symbol, sizeof(real_unlink));
    }
    if (destination != NULL && strstr(path, "protect.so") != NULL) {
        copy_file(path, destination);
    }
    return real_unlink(path);
}