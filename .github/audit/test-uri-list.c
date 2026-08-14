#include <glib.h>
#include <string.h>

static void omit_failed_uri(char ***slot)
{
    char **pfile = *slot;
    int n = g_strv_length(pfile + 1);

    if (n > 0)
    {
        memmove(pfile, pfile + 1, sizeof(char *) * (n + 1));
        --pfile;
    }
    else
    {
        *pfile = NULL;
    }

    *slot = pfile;
}

int main(void)
{
    char **files = g_new0(char *, 5);
    char **pfile;

    files[0] = g_strdup("/tmp/one");
    files[1] = g_strdup("invalid-uri");
    files[2] = g_strdup("/tmp/two");
    files[3] = g_strdup("/tmp/three");

    g_free(files[1]);
    pfile = &files[1];
    omit_failed_uri(&pfile);

    g_assert_cmpstr(files[0], ==, "/tmp/one");
    g_assert_cmpstr(files[1], ==, "/tmp/two");
    g_assert_cmpstr(files[2], ==, "/tmp/three");
    g_assert_null(files[3]);

    g_strfreev(files);
    return 0;
}
