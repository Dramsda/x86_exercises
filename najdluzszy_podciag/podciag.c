#include stdio.h

int main() {
    int t1[] = { 10, 1,2,3,4,5,0 };
    int t2[] = { 10, 7,31,4,5,9, 1,2,3,4,0 };
    int wsk = podciag(t1,t2);

    printf(%dn, wsk - t1);
    return 0;
}
