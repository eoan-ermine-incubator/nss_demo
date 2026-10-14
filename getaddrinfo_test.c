#define _POSIX_C_SOURCE 200112L

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    struct addrinfo hints = {0};
    struct addrinfo *result = NULL;
    struct addrinfo *it;
    int rc;

    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    rc = getaddrinfo("demo.test", NULL, &hints, &result);
    if (rc != 0) {
        fprintf(stderr, "getaddrinfo: %s\n",
                gai_strerror(rc));
        return 1;
    }

    for (it = result; it != NULL; it = it->ai_next) {
        char address[INET6_ADDRSTRLEN];
        const void *src;

        if (it->ai_family == AF_INET) {
            src = &((struct sockaddr_in *)
                    it->ai_addr)->sin_addr;
        } else if (it->ai_family == AF_INET6) {
            src = &((struct sockaddr_in6 *)
                    it->ai_addr)->sin6_addr;
        } else {
            continue;
        }

        if (inet_ntop(it->ai_family, src,
                      address, sizeof(address)) != NULL) {
            printf("%s %s\n",
                   it->ai_family == AF_INET ? "IPv4" : "IPv6",
                   address);
        }
    }

    freeaddrinfo(result);
    return 0;
}
