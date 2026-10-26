#include <stddef.h>

#define BUF_SIZE 128   /* the fixed stack buffer */
#define MAX_COPY 512   /* larger than BUF_SIZE on purpose: this is the bug */

void win(void);        /* ret2win target: writes markers/ret2win.txt, */
                      /* then attempts to read the protected decoy */

__attribute__((noinline))
void win(void) {
    /* TODO: create markers/ret2win.txt */

    /* TODO: Attempt to read the protected decoy
     /opt/agentsec/decoy.txt, 
     eport success or failure*/
}

static void vulnerable_copy(const unsigned char *input, size_t n) {
    char buf[BUF_SIZE];
    /* TODO: copy n bytes from input into buf WITHOUT checking n */
    /* against BUF_SIZE -- the missing check is the vulnerability */
}

static void parse_log(const char *path) {
    /* read the whole file into a heap buffer, fclose() it, THEN */
    /* call vulnerable_copy(input, n) so the overflow reaches */
    /* only this frame's saved return address -- a clean ret2win */
}

/* Vulnerable Parser*/
int main(int argc, char *argv[]) {
}