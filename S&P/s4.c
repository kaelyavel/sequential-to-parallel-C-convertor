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
int b;
int c;

a = op1(a);
b = op2();
c = op3(a);
op4(c,b);


}
