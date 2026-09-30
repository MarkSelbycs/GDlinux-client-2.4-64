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

        printf("%s=%s\n", name, (const char *)content);
        xmlFree(content);
        return "present";
    }

    return NULL;
}

int main(int argc, char **argv)
{
    const char *path;
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

    child_text(root, "redirect");
    child_text(root, "version");
    child_text(root, "disasterUrl");

    xmlFreeDoc(document);
    xmlCleanupParser();
    return EXIT_SUCCESS;
}