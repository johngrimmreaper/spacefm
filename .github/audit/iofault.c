#define _GNU_SOURCE
#include <dlfcn.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int fd_matches(int fd, const char *env_name)
{
    const char *target = getenv(env_name);
    char proc[64];
    char path[PATH_MAX + 1];
    ssize_t n;

    if (!target || !*target)
        return 0;

    snprintf(proc, sizeof(proc), "/proc/self/fd/%d", fd);
    n = readlink(proc, path, PATH_MAX);
    if (n < 0)
        return 0;
    path[n] = '\0';
    return strcmp(path, target) == 0;
}

ssize_t write(int fd, const void *buf, size_t count)
{
    static ssize_t (*real_write)(int, const void *, size_t);

    if (!real_write)
        real_write = dlsym(RTLD_NEXT, "write");
    if (fd_matches(fd, "SPACEFM_SHORT_WRITE_TARGET") && count > 1)
        count /= 2;
    return real_write(fd, buf, count);
}

ssize_t read(int fd, void *buf, size_t count)
{
    static ssize_t (*real_read)(int, void *, size_t);
    static off_t injected_after = -1;
    off_t pos;
    const char *value;

    if (!real_read)
        real_read = dlsym(RTLD_NEXT, "read");

    if (fd_matches(fd, "SPACEFM_READ_ERROR_SOURCE"))
    {
        if (injected_after < 0)
        {
            value = getenv("SPACEFM_READ_ERROR_AFTER");
            injected_after = value ? strtoll(value, NULL, 10) : 8192;
        }
        pos = lseek(fd, 0, SEEK_CUR);
        if (pos >= injected_after)
        {
            errno = EIO;
            return -1;
        }
    }

    return real_read(fd, buf, count);
}
