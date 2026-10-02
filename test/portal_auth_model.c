#include <libxml/parser.h>
#include <libxml/tree.h>
#include <stdio.h>
#include <stdlib.h>

static int write_auth_request(const char *user_agent, const char *client_id,
                              const char *user_id, const char *password,
                              const char *ticket)
{
    const char *names[] = {
        "user-agent",
        "client-id",
        "userid",
        "passwd",
        "ticket"
    };
    const char *values[] = {
        user_agent,
        client_id,
        user_id,
        password,
        ticket
    };
    xmlDocPtr document;
    xmlNodePtr root;
    xmlChar *buffer = NULL;
    int buffer_size = 0;
    size_t index;

    document = xmlNewDoc((const xmlChar *)"1.0");
    root = xmlNewNode(NULL, (const xmlChar *)"request");
    if (document == NULL || root == NULL) {
        xmlFreeDoc(document);
        return 0;
    }
    xmlDocSetRootElement(document, root);
    for (index = 0; index < sizeof(names) / sizeof(names[0]); ++index) {
        if (xmlNewChild(root, NULL, (const xmlChar *)names[index],
                        (const xmlChar *)values[index]) == NULL) {
            xmlFreeDoc(document);
            return 0;
        }
    }
    xmlDocDumpFormatMemoryEnc(document, &buffer, &buffer_size, "UTF-8", 0);
    if (buffer == NULL || buffer_size == 0) {
        xmlFree(buffer);
        xmlFreeDoc(document);
        return 0;
    }
    fwrite(buffer, 1, (size_t)buffer_size, stdout);
    fputc('\n', stdout);
    xmlFree(buffer);
    xmlFreeDoc(document);
    return 1;
}

int main(int argc, char **argv)
{
    int result;

    if (argc != 6) {
        fprintf(stderr,
                "用法: %s <user-agent> <client-id> <userid> <passwd> <ticket>\n",
                argv[0]);
        return EXIT_FAILURE;
    }
    result = write_auth_request(argv[1], argv[2], argv[3], argv[4], argv[5]);
    xmlCleanupParser();
    return result ? EXIT_SUCCESS : EXIT_FAILURE;
}