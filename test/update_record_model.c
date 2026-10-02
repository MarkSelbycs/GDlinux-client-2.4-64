#include <libxml/parser.h>
#include <libxml/tree.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static xmlNodePtr child(xmlNodePtr parent, const char *name)
{
    xmlNodePtr node;

    for (node = parent == NULL ? NULL : parent->children;
         node != NULL; node = node->next) {
        if (node->type == XML_ELEMENT_NODE &&
            xmlStrcmp(node->name, (const xmlChar *)name) == 0) {
            return node;
        }
    }
    return NULL;
}

static xmlNodePtr ensure_child(xmlNodePtr parent, const char *name)
{
    xmlNodePtr node = child(parent, name);

    return node == NULL ? xmlNewChild(parent, NULL, (const xmlChar *)name,
                                      NULL) : node;
}

static xmlNodePtr find_pack(xmlNodePtr installed, const char *version,
                            const char *name)
{
    xmlNodePtr pack;

    for (pack = installed == NULL ? NULL : installed->children;
         pack != NULL; pack = pack->next) {
        xmlChar *record_version;
        xmlChar *record_name;
        int matches;

        if (pack->type != XML_ELEMENT_NODE ||
            xmlStrcmp(pack->name, (const xmlChar *)"pack") != 0) {
            continue;
        }
        record_version = xmlGetProp(pack, (const xmlChar *)"version");
        record_name = xmlGetProp(pack, (const xmlChar *)"name");
        matches = record_version != NULL && record_name != NULL &&
                  strcmp((char *)record_version, version) == 0 &&
                  strcmp((char *)record_name, name) == 0;
        xmlFree(record_version);
        xmlFree(record_name);
        if (matches) {
            return pack;
        }
    }
    return NULL;
}

static xmlDocPtr load_or_create(const char *path)
{
    xmlDocPtr document;

    if (access(path, F_OK) == 0) {
        document = xmlReadFile(path, NULL, XML_PARSE_NONET);
    } else {
        document = NULL;
    }

    if (document != NULL) {
        return document;
    }

    document = xmlNewDoc((const xmlChar *)"1.0");
    if (document != NULL) {
        xmlNodePtr client = xmlNewNode(NULL, (const xmlChar *)"client");
        if (client == NULL) {
            xmlFreeDoc(document);
            return NULL;
        }
        xmlDocSetRootElement(document, client);
    }
    return document;
}

static int add_record(const char *path, const char *version,
                      const char *name, const char *time_text, int state)
{
    xmlDocPtr document = load_or_create(path);
    xmlNodePtr root;
    xmlNodePtr installed;
    xmlNodePtr pack;
    char state_text[32];

    if (document == NULL) {
        return 0;
    }
    root = xmlDocGetRootElement(document);
    if (root == NULL || xmlStrcmp(root->name, (const xmlChar *)"client") != 0) {
        xmlFreeDoc(document);
        return 0;
    }
    installed = ensure_child(root, "installed");
    pack = find_pack(installed, version, name);
    if (pack == NULL) {
        pack = xmlNewChild(installed, NULL, (const xmlChar *)"pack", NULL);
    }
    if (pack == NULL) {
        xmlFreeDoc(document);
        return 0;
    }
    snprintf(state_text, sizeof(state_text), "%d", state);
    xmlNewProp(pack, (const xmlChar *)"version", (const xmlChar *)version);
    xmlNewProp(pack, (const xmlChar *)"name", (const xmlChar *)name);
    xmlNewProp(pack, (const xmlChar *)"time", (const xmlChar *)time_text);
    xmlNewProp(pack, (const xmlChar *)"state", (const xmlChar *)state_text);
    if (xmlSaveFormatFileEnc(path, document, "UTF-8", 1) < 0) {
        xmlFreeDoc(document);
        return 0;
    }
    xmlFreeDoc(document);
    return 1;
}

static int is_updated(const char *path, const char *version, const char *name)
{
    xmlDocPtr document = xmlReadFile(path, NULL, XML_PARSE_NONET);
    xmlNodePtr installed;
    xmlNodePtr pack;
    int found = 0;

    if (document == NULL) {
        return 0;
    }
    installed = child(xmlDocGetRootElement(document), "installed");
    for (pack = installed == NULL ? NULL : installed->children;
         pack != NULL; pack = pack->next) {
        xmlChar *record_version;
        xmlChar *record_name;

        if (pack->type != XML_ELEMENT_NODE ||
            xmlStrcmp(pack->name, (const xmlChar *)"pack") != 0) {
            continue;
        }
        record_version = xmlGetProp(pack, (const xmlChar *)"version");
        record_name = xmlGetProp(pack, (const xmlChar *)"name");
        if (record_version != NULL && record_name != NULL &&
            strcmp((char *)record_version, version) == 0 &&
            strcmp((char *)record_name, name) == 0) {
            found = 1;
        }
        xmlFree(record_version);
        xmlFree(record_name);
        if (found) {
            break;
        }
    }
    xmlFreeDoc(document);
    return found;
}

int main(int argc, char **argv)
{
    int result;

    if (argc == 7 && strcmp(argv[1], "record") == 0) {
        result = add_record(argv[2], argv[3], argv[4], argv[5], atoi(argv[6]));
        xmlCleanupParser();
        return result ? EXIT_SUCCESS : EXIT_FAILURE;
    }
    if (argc == 5 && strcmp(argv[1], "is-updated") == 0) {
        result = is_updated(argv[2], argv[3], argv[4]);
        printf("is-updated=%d\n", result);
        xmlCleanupParser();
        return result ? EXIT_SUCCESS : EXIT_FAILURE;
    }

    fprintf(stderr,
            "用法: %s record <file> <version> <name> <time> <state>\n"
            "       %s is-updated <file> <version> <name>\n",
            argv[0], argv[0]);
    return EXIT_FAILURE;
}
