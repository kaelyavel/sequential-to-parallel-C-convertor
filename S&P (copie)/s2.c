#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>


int op1(int z)
{
    z++;
    return z;
}

void op2(int m)
{
    printf("%d", m);
}


int main()
{

int a;
int b = 5;

//#op1 b a 
a = op1(b);

//#op2 a /
op2(a);
return 0;
}