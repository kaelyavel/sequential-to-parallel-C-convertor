#include <pthread.h>
#include <inttypes.h>
#include "mythreads.h"
#include <stdlib.h> 
#include <string.h> 
#include <stdio.h> 


typedef struct 
 {
	int a;
	int b;
	int c;
	int nbr_for_op3;
	int nbr_for_op4;
	pthread_mutex_t mutex_pile;
	pthread_cond_t cond_pile; 
	ThreadPool *pool;
} Data;

void op3 (void * d  );
 void op4 (void * d  );
 
void notifier(char name[],void *d )
{
	Data *dd = d;
	if(strcmp (name, "op4") == 0)
	{
		--dd->nbr_for_op4;
		if(dd->nbr_for_op4 == 0)
		{
			addJobToPool(dd->pool, &op4, dd);
		}
	}
	if(strcmp (name, "op3") == 0)
	{
		--dd->nbr_for_op3;
		if(dd->nbr_for_op3 == 0)
		{
			addJobToPool(dd->pool, &op3, dd);
		}
	}
}

void op1 (void * d )	
	{
	Data *dd =  d; 
int z=dd->a;
  	    z++; 	    
	dd->a =  z;	notifier("op3" , d); 
}
void op2 (void * d )	
	{
	Data *dd =  d; 
  	    int z= 0; 	    
	dd->b =  z;	notifier("op4" , d); 
}
void op3 (void * d )	
	{
	Data *dd =  d; 
int m=dd->a;
  	     	    m++; 	    
	dd->c =  m;	notifier("op4" , d); 
}
void op4 (void * d )	
	{
	Data *dd =  d; 
int a=dd->c;
 int b=dd->b;
  	printf("%d %d", a,b); 	
}

int main() { 	 
	Data d1;
		d1.b=8;
	d1.c=9;
	d1.nbr_for_op3 = 1;
	d1.nbr_for_op4 = 2;
	int size,size2;
	scanf("%d",&size);
	ThreadPool *pool = createPool(size);
	d1.pool=pool;
	addJobToPool(pool, &op1, &d1);
	addJobToPool(pool, &op2, &d1);
	printf("POL");
	scanf("%d" , &size2);
	return 0;} 	
