#include <libxml/parser.h>
#include <libxml/tree.h>
#include <stdio.h>
#include <stdlib.h>

static xmlChar *child_text(xmlNodePtr root, const char *name)
{
    xmlNodePtr node;

    for (node = root->children; node != NULL; node = node->next) {
        if (node->type != XML_ELEMENT_NODE ||
            xmlStrcmp(node->name, (const xmlChar *)name) != 0) {
            continue;
        }

        return xmlNodeGetContent(node);
    }

    return NULL;
}

static void print_text(xmlNodePtr root, const char *name)
{
    xmlChar *value = child_text(root, name);

    printf("%s=%s\n", name, value == NULL ? "" : (char *)value);
    xmlFree(value);
}

static void print_int(xmlNodePtr root, const char *name)
{
    xmlChar *value = child_text(root, name);

    printf("%s=%d\n", name, value == NULL ? 0 : atoi((char *)value));
    xmlFree(value);
}

static void print_update_info(xmlNodePtr root)
{
    static const char *text_fields[] = {
        "version",
        "updateInstId",
        "decompressDir",
        "updateDir",
        "mainProgram",
        "mainProgramWnd",
        "mainProgramId",
        "backupPath",
        "recordFile",
        "downloadDir",
        "imgDir"
    };
    size_t index;

    for (index = 0; index < sizeof(text_fields) / sizeof(text_fields[0]);
         ++index) {
        print_text(root, text_fields[index]);
    }
    print_int(root, "updateType");
}

int main(int argc, char **argv)
{
    xmlDocPtr document;
    xmlNodePtr root;

    if (argc != 2) {
        fprintf(stderr, "用法: %s <update-param.xml>\n", argv[0]);
        return EXIT_FAILURE;
    }

    document = xmlReadFile(argv[1], NULL, XML_PARSE_NONET);
    if (document == NULL) {
        fprintf(stderr, "无法解析 XML: %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    root = xmlDocGetRootElement(document);
    if (root == NULL || xmlStrcmp(root->name, (const xmlChar *)"conf") != 0) {
        fprintf(stderr, "XML 根节点不是 <conf>\n");
        xmlFreeDoc(document);
        xmlCleanupParser();
        return EXIT_FAILURE;
    }

    print_update_info(root);
    xmlFreeDoc(document);
    xmlCleanupParser();
    return EXIT_SUCCESS;
}