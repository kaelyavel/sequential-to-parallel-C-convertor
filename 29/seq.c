#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int op1(int z)
{
    z++;
    for(int i=0;i<0xFFFFFFF;i++);
    return z;
}
void op4 (int i, int g)
{
	for(int i=0;i<0xFFFFFF;i++);
	//int azerty;
}

   int oppp2(int m)
{
    m--;
    for(int i=0;i<0xFFFF;i++);
    return m;
}

 void op3 (int j, int h)
{
	for(int i=0;i<0xFFFF;i++);
    printf("%d %d", j,h);
}


int main ()
{

int a;
int d;
int b = 0;
int c = 2;

//#op1 b a
a = op1(b);

//#oppp2 c d
d = oppp2(c);

//#op3 a,d v
op3(a,d);

//#op4 v /
op4(a,d);

return 0;
}