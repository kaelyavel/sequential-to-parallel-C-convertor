#include <stdio.h>
#include <stdlib.h>


int a1(int x)
{   int a = x+1;
    return a;
}

int b1()
{
    int b = 1;
    return ++b;
}

aa


void f1(int a, int b)
{
    printf("Value of a : %d\n", a);
    printf("Value of b : %d\n", b);
}

int main ()
{

int a = 2;
int b;
int c;
a = a1(a);
b = b1();
f1(a,b);

}

/*c1(&a,&b);
b = d1(b,c);
a = e1(a);
f1(a,b);

int d1(int a, int b)
{
a++;
b++;

return a+b;

}

int e1(int a)
{
    return ++a;
}

void c1(int *a, int *z)
{
*++a;
*++z;

}
*/