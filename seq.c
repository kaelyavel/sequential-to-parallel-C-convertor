#include <stdio.h>
#include <stdlib.h>




//op 1 input() output(y)
int op1()

{

int y = 3;

return y;

}

//op2 input(y) output(t)
int op2(int y)
{

int t = y + 1;
return t;
}

//op3 input(y,t) output(z)
int op3(int y, int t)
{

int z= y + t;
return z;
}

int main () {
	

int a,b,c;

a = op1();
b = op2(a);
c = op3(a,b);

printf("passes %d\n", c);

}