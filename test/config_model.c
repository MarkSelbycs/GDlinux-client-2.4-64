#include <libxml/parser.h>
#include <libxml/tree.h>
#include <stdio.h>
#include <stdlib.h>

static char *child_text(xmlNodePtr root, const char *name)
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

        return (char *)content;
    }

    return NULL;
}

static int child_int(xmlNodePtr root, const char *name)
{
    char *content = child_text(root, name);
    int value = content == NULL ? 0 : atoi(content);

    xmlFree(content);
    return value;
}

static void print_text(xmlNodePtr root, const char *name,
                       const char *default_value)
{
    char *content = child_text(root, name);

    printf("%s=%s\n", name,
           content == NULL ? default_value : content);
    xmlFree(content);
}

static void print_int(xmlNodePtr root, const char *name)
{
    printf("%s=%d\n", name, child_int(root, name));
}

static void print_model(xmlNodePtr root)
{
    print_text(root, "hostName", "");
    print_text(root, "clientId", "");
    print_text(root, "version", "");
    print_text(root, "redirect", "");
    print_text(root, "redirectipv6", "http://www.baidu.com/");
    print_text(root, "disasterUrl", "");
    print_text(root, "schoolId", "");
    print_text(root, "domain", "");
    print_text(root, "area", "");
    print_text(root, "wlanuserip", "");
    print_text(root, "wlanusermac", "");
    print_text(root, "wlanacip", "");
    print_text(root, "termUrl", "");
    print_text(root, "keepUrl", "");
    print_int(root, "plusInterval");
    print_int(root, "plusFlag");
}

int main(int argc, char **argv)
{
    xmlDocPtr document;
    xmlNodePtr root;

    if (argc != 2) {
        fprintf(stderr, "用法: %s <conf.xml>\n", argv[0]);
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

    print_model(root);

    xmlFreeDoc(document);
    xmlCleanupParser();
    return EXIT_SUCCESS;
}