#include <libxml/parser.h>
#include <libxml/tree.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int print_message(const unsigned char *data, size_t length, size_t index)
{
    xmlDocPtr document;
    xmlNodePtr root;
    xmlNodePtr node;
    const char *op_source = NULL;
    const char *op_type = NULL;
    const char *op_code = NULL;
    const char *payload_src = NULL;
    const char *payload_ticket = NULL;
    char *source_copy = NULL;
    char *type_copy = NULL;
    char *code_copy = NULL;
    char *payload_src_copy = NULL;
    char *payload_ticket_copy = NULL;

    if (length == 0) {
        printf("message[%zu]: empty\n", index);
        return 0;
    }

    document = xmlReadMemory((const char *)data, (int)length, NULL, NULL,
                             XML_PARSE_NONET);
    if (document == NULL) {
        fprintf(stderr, "message[%zu]: invalid XML\n", index);
        return 0;
    }

    root = xmlDocGetRootElement(document);
    if (root == NULL || xmlStrcmp(root->name, (const xmlChar *)"M") != 0) {
        fprintf(stderr, "message[%zu]: root is not <M>\n", index);
        xmlFreeDoc(document);
        return 0;
    }

    for (node = root->children; node != NULL; node = node->next) {
        xmlChar *content;

        if (node->type != XML_ELEMENT_NODE) {
            continue;
        }
        if (xmlStrcmp(node->name, (const xmlChar *)"OpS") == 0) {
            content = xmlNodeGetContent(node);
            if (content != NULL) {
                source_copy = (char *)content;
                op_source = source_copy;
            }
        } else if (xmlStrcmp(node->name, (const xmlChar *)"OpT") == 0) {
            content = xmlNodeGetContent(node);
            if (content != NULL) {
                type_copy = (char *)content;
                op_type = type_copy;
            }
        } else if (xmlStrcmp(node->name, (const xmlChar *)"OpC") == 0) {
            content = xmlNodeGetContent(node);
            if (content != NULL) {
                code_copy = (char *)content;
                op_code = code_copy;
            }
        } else if (xmlStrcmp(node->name, (const xmlChar *)"P") == 0) {
            xmlNodePtr payload_node;

            for (payload_node = node->children; payload_node != NULL;
                 payload_node = payload_node->next) {
                if (payload_node->type != XML_ELEMENT_NODE) {
                    continue;
                }
                if (xmlStrcmp(payload_node->name,
                              (const xmlChar *)"src") == 0) {
                    content = xmlNodeGetContent(payload_node);
                    if (content != NULL) {
                        payload_src_copy = (char *)content;
                        payload_src = payload_src_copy;
                    }
                } else if (xmlStrcmp(payload_node->name,
                                     (const xmlChar *)"ticket") == 0) {
                    content = xmlNodeGetContent(payload_node);
                    if (content != NULL) {
                        payload_ticket_copy = (char *)content;
                        payload_ticket = payload_ticket_copy;
                    }
                }
            }
        }
    }

        printf("message[%zu]: OpS=%s OpT=%s OpC=%s", index,
            op_source == NULL ? "<missing>" : op_source,
           op_type == NULL ? "<missing>" : op_type,
           op_code == NULL ? "<missing>" : op_code);
    if (op_code != NULL && strcmp(op_code, "PortalConnect") == 0) {
        printf(" dispatch=PortalConnect");
    }
    if (payload_src != NULL) {
        printf(" P.src-len=%zu", strlen(payload_src));
    }
    if (payload_ticket != NULL) {
        printf(" P.ticket-len=%zu", strlen(payload_ticket));
    }
    putchar('\n');

    xmlFree((void *)source_copy);
    xmlFree((void *)type_copy);
    xmlFree((void *)code_copy);
    xmlFree((void *)payload_src_copy);
    xmlFree((void *)payload_ticket_copy);
    xmlFreeDoc(document);
    return 1;
}

int main(int argc, char **argv)
{
    FILE *input;
    unsigned char *data;
    long file_size;
    size_t offset = 0;
    size_t index = 0;
    int success = 1;

    if (argc != 2) {
        fprintf(stderr, "用法: %s <NUL分隔消息文件>\n", argv[0]);
        return EXIT_FAILURE;
    }

    input = fopen(argv[1], "rb");
    if (input == NULL) {
        perror(argv[1]);
        return EXIT_FAILURE;
    }
    if (fseek(input, 0, SEEK_END) != 0 || (file_size = ftell(input)) < 0 ||
        fseek(input, 0, SEEK_SET) != 0) {
        fprintf(stderr, "无法读取文件大小: %s\n", argv[1]);
        fclose(input);
        return EXIT_FAILURE;
    }

    data = (unsigned char *)malloc((size_t)file_size + 1);
    if (data == NULL ||
        fread(data, 1, (size_t)file_size, input) != (size_t)file_size) {
        fprintf(stderr, "无法读取消息文件: %s\n", argv[1]);
        free(data);
        fclose(input);
        return EXIT_FAILURE;
    }
    fclose(input);
    data[file_size] = '\0';

    while (offset < (size_t)file_size) {
        size_t end = offset;

        while (end < (size_t)file_size && data[end] != '\0') {
            ++end;
        }
        if (!print_message(data + offset, end - offset, index)) {
            success = 0;
        }
        ++index;
        offset = end + 1;
    }

    free(data);
    xmlCleanupParser();
    return success ? EXIT_SUCCESS : EXIT_FAILURE;
}