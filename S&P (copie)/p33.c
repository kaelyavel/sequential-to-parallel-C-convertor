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
	int d;
	int nbr_for_op2;
	int nbr_for_op3;
	pthread_mutex_t mutex_pile;
	pthread_cond_t cond_pile; 
	ThreadPool *pool;
} Data;

void op2 (void * d  );
 void op3 (void * d  );
 
void notifier(char name[],void *d )
{
	Data *dd = d;
	if(strcmp (name, "op3") == 0)
	{
		--dd->nbr_for_op3;
		if(dd->nbr_for_op3 == 0)
		{
			addJobToPool(dd->pool, &op3, dd);
		}
	}
	if(strcmp (name, "op2") == 0)
	{
		--dd->nbr_for_op2;
		if(dd->nbr_for_op2 == 0)
		{
			addJobToPool(dd->pool, &op2, dd);
		}
	}
}

void op1 (void * d )	
	{
	Data *dd =  d; 
int z=dd->b;
  	    z++; 	    
	dd->a =  z;	notifier("op2" , d); 
}
void op2 (void * d )	
	{
	Data *dd =  d; 
int m=dd->a;
  	    m++; 	    
	dd->d =  m;	notifier("op3" , d); 
}
void op3 (void * d )	
	{
	Data *dd =  d; 
int j=dd->d;
  	    printf("%d",j); 	
}

int main() { 	 
	Data d1;
		d1.b=0;
	d1.nbr_for_op2 = 1;
	d1.nbr_for_op3 = 1;
	int size,size2;
	scanf("%d",&size);
	ThreadPool *pool = createPool(size);
	d1.pool=pool;
	addJobToPool(pool, &op1, &d1);
	printf("POL");
	scanf("%d" , &size2);
	return 0;} 	
