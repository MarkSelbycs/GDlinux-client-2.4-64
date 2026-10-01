#include <libxml/parser.h>
#include <libxml/tree.h>
#include <stdio.h>
#include <stdlib.h>

static const char *child_text(xmlNodePtr root, const char *name)
{
    xmlNodePtr node;

    for (node = root->children; node != NULL; node = node->next) {
        xmlChar *content;

        if (node->type != XML_ELEMENT_NODE ||
            xmlStrcmp(node->name, (const xmlChar *)name) != 0) {
            continue;
        }

        content = xmlNodeGetContent(node);
        if (content == NULL) {
            return NULL;
        }

        if (content[0] == '\0') {
            xmlFree(content);
            return NULL;
        }

        printf("%s=%s\n", name, (const char *)content);
        xmlFree(content);
        return "present";
    }

    return NULL;
}

static int child_int(xmlNodePtr root, const char *name)
{
    xmlNodePtr node;

    for (node = root->children; node != NULL; node = node->next) {
        xmlChar *content;
        int value;

        if (node->type != XML_ELEMENT_NODE ||
            xmlStrcmp(node->name, (const xmlChar *)name) != 0) {
            continue;
        }

        content = xmlNodeGetContent(node);
        if (content == NULL) {
            return 0;
        }

        value = atoi((const char *)content);
        xmlFree(content);
        return value;
    }

    return 0;
}

int main(int argc, char **argv)
{
    const char *path;
    const char *redirectipv6;
    xmlDocPtr document;
    xmlNodePtr root;

    if (argc != 2) {
        fprintf(stderr, "用法: %s <conf.xml>\n", argv[0]);
        return EXIT_FAILURE;
    }

    path = argv[1];
    document = xmlReadFile(path, NULL, XML_PARSE_NONET);
    if (document == NULL) {
        fprintf(stderr, "无法解析 XML: %s\n", path);
        return EXIT_FAILURE;
    }

    root = xmlDocGetRootElement(document);
    if (root == NULL || xmlStrcmp(root->name, (const xmlChar *)"conf") != 0) {
        fprintf(stderr, "XML 根节点不是 <conf>\n");
        xmlFreeDoc(document);
        xmlCleanupParser();
        return EXIT_FAILURE;
    }

    redirectipv6 = child_text(root, "redirectipv6");
    if (redirectipv6 == NULL) {
        redirectipv6 = "http://www.baidu.com/";
        printf("redirectipv6=%s\n", redirectipv6);
    }

    printf("plusInterval=%d\n", child_int(root, "plusInterval"));
    printf("plusFlag=%d\n", child_int(root, "plusFlag"));

    xmlFreeDoc(document);
    xmlCleanupParser();
    return EXIT_SUCCESS;
}