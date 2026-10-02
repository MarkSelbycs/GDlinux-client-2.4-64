#define _GNU_SOURCE

#include <arpa/inet.h>
#include <dlfcn.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

static int (*real_connect)(int, const struct sockaddr *, socklen_t);
static ssize_t (*real_send)(int, const void *, size_t, int);
static ssize_t (*real_sendto)(int, const void *, size_t, int,
                              const struct sockaddr *, socklen_t);

static void resolve_symbols(void)
{
    void *symbol;

    if (real_connect == NULL) {
        symbol = dlsym(RTLD_NEXT, "connect");
        memcpy(&real_connect, &symbol, sizeof(real_connect));
        symbol = dlsym(RTLD_NEXT, "send");
        memcpy(&real_send, &symbol, sizeof(real_send));
        symbol = dlsym(RTLD_NEXT, "sendto");
        memcpy(&real_sendto, &symbol, sizeof(real_sendto));
    }
}

static void log_connect(const struct sockaddr *address)
{
    char host[INET6_ADDRSTRLEN];
    const struct sockaddr_in *ipv4;
    const struct sockaddr_in6 *ipv6;

    if (address->sa_family == AF_INET) {
        ipv4 = (const struct sockaddr_in *)address;
        if (inet_ntop(AF_INET, &ipv4->sin_addr, host, sizeof(host)) != NULL) {
            fprintf(stderr, "[http-capture] connect %s:%u\n", host,
                    (unsigned)ntohs(ipv4->sin_port));
        }
    } else if (address->sa_family == AF_INET6) {
        ipv6 = (const struct sockaddr_in6 *)address;
        if (inet_ntop(AF_INET6, &ipv6->sin6_addr, host, sizeof(host)) != NULL) {
            fprintf(stderr, "[http-capture] connect [%s]:%u\n", host,
                    (unsigned)ntohs(ipv6->sin6_port));
        }
    }
}

static void log_request(const void *data, size_t length)
{
    const char *bytes = data;
    const char *end = memchr(bytes, '\n', length);
    size_t line_length = end == NULL ? length : (size_t)(end - bytes);

    if (line_length > 0 && line_length < 2048) {
        fprintf(stderr, "[http-capture] request %.*s", (int)line_length, bytes);
        if (end == NULL || bytes[line_length - 1] != '\r') {
            fputc('\n', stderr);
        }
    }
}

int connect(int descriptor, const struct sockaddr *address, socklen_t length)
{
    resolve_symbols();
    log_connect(address);
    return real_connect(descriptor, address, length);
}

ssize_t send(int descriptor, const void *data, size_t length, int flags)
{
    resolve_symbols();
    log_request(data, length);
    return real_send(descriptor, data, length, flags);
}

ssize_t sendto(int descriptor, const void *data, size_t length, int flags,
               const struct sockaddr *address, socklen_t address_length)
{
    resolve_symbols();
    log_request(data, length);
    return real_sendto(descriptor, data, length, flags, address,
                       address_length);
}