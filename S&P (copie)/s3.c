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
//#op1 b a
a = op1(b);

//#op2 a d
d = op2(a);

//#op3 d /
op3(d);

return 0;
}
