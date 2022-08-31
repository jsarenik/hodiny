#include <stdio.h>
#include <sys/time.h>

int main() {
    struct timeval t;
    double my;

    printf("Content-Type: text/javascript\n\n");
    gettimeofday(&t, NULL);
    my = t.tv_sec*1000 + (double)t.tv_usec/1000;

    printf("%f\n", my);

    return 0;
}
