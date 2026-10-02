#define _GNU_SOURCE

#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef char *(*codec_function)(const char *);
typedef void (*free_function)(const char *);

static void *load_symbol(void *module, const char *name)
{
    return dlsym(module, name);
}

static int run_codec(const char *module_path, const char *operation,
                     const char *input)
{
    void *module;
    void *symbol;
    codec_function codec;
    free_function release_result;
    char *result;

    module = dlopen(module_path, RTLD_NOW | RTLD_LOCAL);
    if (module == NULL) {
        fprintf(stderr, "无法加载编码模块: %s\n", dlerror());
        return 0;
    }
    symbol = load_symbol(module,
                         strcmp(operation, "code") == 0 ? "Code" : "DeCode");
    memcpy(&codec, &symbol, sizeof(codec));
    symbol = load_symbol(module, "FreeResult");
    memcpy(&release_result, &symbol, sizeof(release_result));
    if (codec == NULL || release_result == NULL) {
        fprintf(stderr, "编码模块缺少导出接口\n");
        dlclose(module);
        return 0;
    }
    result = codec(input);
    if (result == NULL) {
        fprintf(stderr, "编码模块返回空结果\n");
        dlclose(module);
        return 0;
    }
    fputs(result, stdout);
    fputc('\n', stdout);
    release_result(result);
    dlclose(module);
    return 1;
}

int main(int argc, char **argv)
{
    if (argc != 4 ||
        (strcmp(argv[2], "code") != 0 && strcmp(argv[2], "decode") != 0)) {
        fprintf(stderr, "用法: %s <protect.so> <code|decode> <text>\n", argv[0]);
        return EXIT_FAILURE;
    }
    return run_codec(argv[1], argv[2], argv[3]) ? EXIT_SUCCESS : EXIT_FAILURE;
}