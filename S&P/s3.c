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
    m++;
    return m;
}

void op3(int j)
{
    printf("%d",j);
}

int main()
{
//op1 0
//op2 1
//op3 1

int a;
int b=0;
int d;
a = op1(b);
d = op2(a);
op3(d);

}
