#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int op1(int z)
{
    z++;
    return z;
}

int op2(int m)
{
    m--;
    return m;
}

void op3(int j, int h)
{
    printf("%d %d", j,h);
}

int main()
{

int a;
int d;
int b = 0;
int c = 2;


a = op1(b);
d = op2(c);

op3(a,d);

}