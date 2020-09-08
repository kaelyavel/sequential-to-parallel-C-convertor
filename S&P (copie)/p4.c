#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <pthread.h>
#include "mythreads.h"


typedef struct
{

int ini_a;
int ini_b;
int ini_d;
int ini_c;


int nb_for_op2;
int nb_for_op3;
int nb_for_op4;

pthread_mutex_t mutex_pile;
pthread_cond_t cond_pile;

ThreadPool *pool;
}
data;


 

void op4(void *ll)
{

data *dd = ll;
     
printf("%d %d", dd->ini_c, dd->ini_b);


}


void op3(void *ll)
{
    data *dd = ll;
    ++dd->ini_a; 
    dd->ini_d = dd->ini_a;
    printf("yes");
    pthread_mutex_lock (&dd->mutex_pile);
    pthread_cond_wait (&dd->cond_pile, &dd->mutex_pile);
    notifier("op4" , ll);
    pthread_cond_signal (&dd->cond_pile);
    pthread_mutex_unlock (&dd->mutex_pile);
    
    
}

void op2(void *ll)
{
    data *dd = ll;
    int z = 0;
     
    dd->ini_b = z;
    printf("yes");
    pthread_mutex_lock (&dd->mutex_pile);
    pthread_cond_wait (&dd->cond_pile, &dd->mutex_pile);
    notifier("op3" , ll);
    pthread_cond_signal (&dd->cond_pile);
    pthread_mutex_unlock (&dd->mutex_pile);
    
    
}


void notifier(char name[],void *ll )
{
    printf("INSIDE");
    data *dd = ll;
    if(strcmp (name, "op3") == 0)
    {   
        --dd->nb_for_op2;
        
        if(dd->nb_for_op2 == 0)
        {
            
            addJobToPool(dd->pool, &op2, ll);
        }
    }
    if(strcmp (name, "op4") == 0)
    {   
        --dd->nb_for_op3;
        
        if(dd->nb_for_op3 == 0)
        {
            
            addJobToPool(dd->pool, &op3, ll);
        }
    }


}

void op1(void *ll)
{
    data *dd = ll;
    ++dd->ini_b; 
    dd->ini_a = dd->ini_b;
    printf("yes");
    pthread_mutex_lock (&dd->mutex_pile);
    pthread_cond_wait (&dd->cond_pile, &dd->mutex_pile);
    notifier("op3" , ll);
    pthread_cond_signal (&dd->cond_pile);
    pthread_mutex_unlock (&dd->mutex_pile);
}

int main()
{




data d;



d.nb_for_op3 = 1;
d.nb_for_op4 = 2;


d.ini_a = 0;
d.ini_b = 0;
d.ini_d = 0;

int size = 4;


  
ThreadPool *pool = createPool(size);

d.pool = pool;

addJobToPool(pool, &op1, &d);
addJobToPool(pool, &op2, &d);

printf("POL\n"); 
scanf("FIN%d" , &size);



}