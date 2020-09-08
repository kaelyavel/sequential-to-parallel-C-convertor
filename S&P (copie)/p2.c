#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <pthread.h>
#include "mythreads.h"


typedef struct
{

int ini_a;
int ini_b;

int nb_for_op2;

pthread_mutex_t mutex_pile;
pthread_cond_t cond_pile;

ThreadPool *pool;
}
data;

void op2(void *ll)
{
    data *dd = ll;
    printf("%d", dd->ini_a);
    
}

void notifier(char name[],void *ll )
{
    data *dd = ll;
    if(strcmp (name, "op2") == 0)
    {   
        --dd->nb_for_op2;
        
        if(dd->nb_for_op2 == 0)
        {
            
            addJobToPool(dd->pool, &op2, ll);
        }
    }

}

void op1(void *ll)
{
    //Pointeur vers structure
data *dd = ll;

//Début traitement
++dd->ini_b; 
dd->ini_a = dd->ini_b;
//Fin traitement
    
pthread_mutex_lock (&dd->mutex_pile); //Verrouiller accès
pthread_cond_wait (&dd->cond_pile,&dd->mutex_pile);
notifier("op2" , ll); //Notification de la fonction dépendante de celle-ci
pthread_cond_signal (&dd->cond_pile);
pthread_mutex_unlock (&dd->mutex_pile); //Déverouiller accès
    
}

int main()
{

data d;

d.nb_for_op2 = 1;

d.ini_a = 0;
d.ini_b = 5;

int num_threads = 4;
 
ThreadPool *pool = createPool(num_threads);

d.pool = pool;

addJobToPool(pool, &op1, &d);

}