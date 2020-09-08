#include <stdlib.h>
#include <string.h>
#include <stdio.h>






int op1(int z)
{
    z++;
    return z;
}

int op2()
{
    int z= 0;
    return z;
}

int op3(int m)
{
    

    m++;
    return m;
}

void op4(int a, int b)
{
printf("%d %d", a,b);
}




int main()
{
//op1 0
//op2 1


int a;
int b=8;
int c=9;

//#op1 a a
a = op1(a);

//#op2 / b
b = op2();

//#op3 a c
c = op3(a);

//#op4 c,b /
op4(c,b);


return 0;
}
