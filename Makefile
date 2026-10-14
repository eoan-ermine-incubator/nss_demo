CC       = gcc
INSTALL  = install
PREFIX   = /usr
MULTIARCH = $(shell $(CC) -print-multiarch)
LIBDIR   = $(PREFIX)/lib/$(MULTIARCH)

TARGET   = libnss_demo.so.2
SOURCE   = nss_demo.c
OBJECT   = nss_demo.o
TEST_SRC  = getaddrinfo_test.c
TEST_BIN  = getaddrinfo_test

CFLAGS   = -O2 -std=gnu11 -Wall -Wextra -Werror -fPIC
LDFLAGS  = -shared -Wl,-soname,$(TARGET)
TEST_CFLAGS = -O2 -Wall -Wextra -Werror

.PHONY: all test clean install uninstall

all: $(TARGET)

$(TARGET): $(OBJECT)
	$(CC) $(LDFLAGS) -o $@ $^

$(OBJECT): $(SOURCE)
	$(CC) $(CFLAGS) -c -o $@ $<

$(TEST_BIN): $(TEST_SRC)
	$(CC) $(TEST_CFLAGS) -o $@ $<

test: all $(TEST_BIN)

install: $(TARGET)
	$(INSTALL) -d $(DESTDIR)$(LIBDIR)
	$(INSTALL) -m 0644 $(TARGET) $(DESTDIR)$(LIBDIR)/$(TARGET)

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/$(TARGET)

clean:
	rm -f $(OBJECT) $(TARGET) $(TEST_BIN)
