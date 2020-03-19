#include <stdio.h>
#include <sys/time.h>

int main() {
    struct timeval t;

    printf("Content-Type: text/javascript\n\n");
    gettimeofday(&t, NULL);
    printf("%ld%03lu.%03lu\n", t.tv_sec, t.tv_usec/1000, t.tv_usec%1000);

    return 0;
}
