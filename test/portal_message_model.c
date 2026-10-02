#include <libxml/parser.h>
#include <libxml/tree.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static xmlNodePtr add_text(xmlNodePtr parent, const char *name,
                           const char *value)
{
    return xmlNewChild(parent, NULL, (const xmlChar *)name,
                       (const xmlChar *)value);
}

static int write_connect_message(const char *source, const char *type,
                                 const char *user, const char *password)
{
    xmlDocPtr document;
    xmlNodePtr message;
    xmlNodePtr payload;
    xmlBufferPtr buffer;

    document = xmlNewDoc((const xmlChar *)"1.0");
    if (document == NULL) {
        return 0;
    }

    message = xmlNewNode(NULL, (const xmlChar *)"M");
    if (message == NULL) {
        xmlFreeDoc(document);
        return 0;
    }
    xmlDocSetRootElement(document, message);

    add_text(message, "OpS", source);
    add_text(message, "OpT", type);
    add_text(message, "OpC", "PortalConnect");
    payload = xmlNewChild(message, NULL, (const xmlChar *)"P", NULL);
    if (payload == NULL) {
        xmlFreeDoc(document);
        return 0;
    }
    add_text(payload, "user", user);
    add_text(payload, "password", password);

    buffer = xmlBufferCreate();
    if (buffer == NULL || xmlNodeDump(buffer, document, message, 0, 0) < 0 ||
        xmlBufferLength(buffer) == 0) {
        xmlBufferFree(buffer);
        xmlFreeDoc(document);
        return 0;
    }

    fwrite(xmlBufferContent(buffer), 1, xmlBufferLength(buffer), stdout);
    fputc('\n', stdout);
    xmlBufferFree(buffer);
    xmlFreeDoc(document);
    return 1;
}

int main(int argc, char **argv)
{
    int result;

    if (argc != 5) {
        fprintf(stderr,
                "用法: %s <OpS> <OpT> <user> <password>\n",
                argv[0]);
        return EXIT_FAILURE;
    }

    result = write_connect_message(argv[1], argv[2], argv[3], argv[4]);
    xmlCleanupParser();
    return result ? EXIT_SUCCESS : EXIT_FAILURE;
}