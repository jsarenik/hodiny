#include <stdio.h>
#include <sys/time.h>

int main() {
    struct timeval t;

    if (gettimeofday(&t, NULL) == 0)
        printf("%ld%06lu\n", t.tv_sec, t.tv_usec);

    return 0;
}
