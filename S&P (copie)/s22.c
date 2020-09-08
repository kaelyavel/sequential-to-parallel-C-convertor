#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>


void op1(int z)
{
    int i;
    for(i=0; i<0xFFFFFF;i++)
    {
        printf("o");
    }
	
}

void op2(int z)
{
    int i;
    for(i=0; i<0xFFFFFF;i++)
    {
        printf("o");
    }

}

void op3(int z)
{
    int i;
    for(i=0; i<0xFFFFFF;i++)
    {
        printf("o");
    }

}

void op4(int z)
{
    int i;
    for(i=0; i<0xFFFFFF;i++)
    {
        printf("o");
    }

}        

int main()
{

int a;
int b = 5;
int c;
//#op1 a b 
op1(a);
//#op2 a b 
op2(a);
//#op3 b c
op3(a);
//#op4 c /
op4(a);
return 0;

}
