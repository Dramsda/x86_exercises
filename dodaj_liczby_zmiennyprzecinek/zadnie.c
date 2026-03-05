#include <stdio.h>

extern double dodaj_dwa(double);

void printAsHex(double l)
{
    printf("%lf\n", l);
    printf("%llx\n", l);
    char* ptr = &l;
    int i1 = *(int*)ptr;
    int i2 = *(int*)(ptr + 4);
    printf("%08lx %08lx\n\n", i2, i1);
}

int main()
{
    printAsHex(2.0);
    printAsHex(6.0);

    printf("wynik: %lf\n", dodaj_dwa(0.9999));
    printf("wynik: %lf\n", dodaj_dwa(1.0001));
    printf("wynik: %lf\n", dodaj_dwa(1000));
    printf("wynik: %lf\n", dodaj_dwa(0.0001));
    return 0;
}
