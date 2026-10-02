#include <errno.h>
#include <fcntl.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static void set_or_add(xmlNodePtr root, const char *name, const char *value)
{
    xmlNodePtr node;

    for (node = root->children; node != NULL; node = node->next) {
        if (node->type == XML_ELEMENT_NODE &&
            xmlStrcmp(node->name, (const xmlChar *)name) == 0) {
            xmlNodeSetContent(node, (const xmlChar *)value);
            return;
        }
    }
    xmlNewChild(root, NULL, (const xmlChar *)name, (const xmlChar *)value);
}

static int write_startup_config(const char *path, const char *client_id,
                                const char *pid_text)
{
    xmlDocPtr document;
    xmlNodePtr root;

    document = xmlReadFile(path, NULL, XML_PARSE_NONET);
    if (document == NULL) {
        fprintf(stderr, "无法解析 XML: %s\n", path);
        return 0;
    }

    root = xmlDocGetRootElement(document);
    if (root == NULL ||
        xmlStrcmp(root->name, (const xmlChar *)"conf") != 0) {
        fprintf(stderr, "XML 根节点不是 <conf>\n");
        xmlFreeDoc(document);
        return 0;
    }

    set_or_add(root, "clientId", client_id);
    set_or_add(root, "PID", pid_text);

    if (xmlSaveFormatFileEnc(path, document, "UTF-8", 1) < 0) {
        xmlFreeDoc(document);
        return 0;
    }
    xmlFreeDoc(document);
    return 1;
}

static int ensure_fifo(const char *path)
{
    struct stat info;
    int descriptor;

    if (lstat(path, &info) != 0) {
        if (errno != ENOENT || mkfifo(path, 0600) != 0) {
            perror(path);
            return 0;
        }
        printf("fifo-created mode=0600 path=%s\n", path);
    } else if (!S_ISFIFO(info.st_mode)) {
        fprintf(stderr, "路径不是 FIFO: %s\n", path);
        return 0;
    } else {
        printf("fifo-existing path=%s\n", path);
    }

    descriptor = open(path, O_RDWR | O_NONBLOCK);
    if (descriptor < 0) {
        perror(path);
        return 0;
    }
    printf("fifo-open fd=%d\n", descriptor);
    close(descriptor);
    return 1;
}

int main(int argc, char **argv)
{
    if (argc == 5 && strcmp(argv[1], "--config") == 0) {
        if (!write_startup_config(argv[2], argv[3], argv[4])) {
            xmlCleanupParser();
            return EXIT_FAILURE;
        }
         printf("config-written path=%s clientId=%s PID=%s\n",
             argv[2], argv[3], argv[4]);
        xmlCleanupParser();
        return EXIT_SUCCESS;
    }

    if (argc == 3 && strcmp(argv[1], "--fifo") == 0) {
        int result = ensure_fifo(argv[2]);
        return result ? EXIT_SUCCESS : EXIT_FAILURE;
    }

    fprintf(stderr,
            "用法: %s --config <conf.xml> <clientId> <PID> | --fifo <path>\n",
            argv[0]);
    return EXIT_FAILURE;
}bu