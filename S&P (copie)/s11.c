#include <stdlib.h>
#include <string.h>
#include <stdio.h>



void op1(int *z)
{
    ++*z;
   
}

void op2(int *m)
{
    ++*m;
}

void op3(int j, int h)
{
    printf("%d %d", j,h);
}

int main()
{
//op1 0
//op2 0
//op3 2

int b = 0;
int c = 2;

//#op1 b /
op1(&b);

//#op2 c /
op2(&c);

//op3 b,c /
op3(b,c);

return 0;
}
