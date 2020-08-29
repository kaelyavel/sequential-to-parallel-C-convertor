#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <pthread.h>
#include <inttypes.h>
#include "mythreads.h"



typedef struct
{

int ini_a;
int ini_b;
int ini_c;
int ini_d;


int nb_for_op3;

pthread_mutex_t mutex_pile; <++++++++++>
pthread_cond_t cond_pile;  <++++++++++>

ThreadPool *pool;
}
data;

void op3(void *a)
{
 data *dd = a;
 printf("%d %d", dd->ini_a, dd->ini_d);
}

void notifier(char name[],void *a )
{
    data *dd = a;
    if(strcmp (name, "op3") == 0)
    {   
        --dd->nb_for_op3;
        
        if(dd->nb_for_op3 == 0)
        {
            
            addJobToPool(dd->pool, &op3, a);
        }
    }


}



void op2(void *a)
{
    data *dd = a;
    --dd->ini_c; //Le positionnement du -- avant la variable est nécessaire;
    dd->ini_d = dd->ini_b;
    printf("no");
    pthread_mutex_lock (&dd.mutex_pile); <++++++++++>
    pthread_cond_wait (&dd.cond_pile); <++++++++++>
    notifier("op3" , a);
    pthread_cond_signal (&dd.cond_pile); <++++++++++>
    pthread_mutex_unlock (&dd.mutex_pile); <++++++++++>
    
}
void op1(void *a)
{
    data *dd = a;
    ++dd->ini_b; //Le positionnement du ++ avant la variable est nécessaire;
    dd->ini_a = dd->ini_b;
    printf("yes");
    pthread_mutex_lock (&dd.mutex_pile); <++++++++++>
    pthread_cond_wait (&dd.cond_pile);  <++++++++++>
    notifier("op3" , a);
     pthread_cond_signal (&dd.cond_pile); <++++++++++>
    pthread_mutex_unlock (&dd.mutex_pile); <++++++++++>
    
}



int main ()
{

data d;

d.mutex_stock = PTHREAD_MUTEX_INITIALIZER;  <++++++++++>
d.cond_stock = PTHREAD_COND_INITIALIZER; <++++++++++>
d.cond_clients = PTHREAD_COND_INITIALIZER; <++++++++++>

d.ini_a = 0;
d.ini_d = 0;
d.ini_b = 0;
d.ini_c = 2;
d.nb_for_op3 = 1;

uint64_t size;
int size2;

scanf("%" SCNu64 , &size);
  
ThreadPool *pool = createPool(size);

d.pool = pool;

addJobToPool(pool, &op1, &d);
addJobToPool(pool, &op2, &d);
//destroyPool(pool);
printf("POL\n"); //Affichage nécessaire
//waitToComplete(pool);
scanf("%d" , &size2);

}
