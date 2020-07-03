#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

/*
-mutex for the values of each function
-Each function needs to take a pointer as parameters,
functions without are no exception
-The struct has two sections : Initial variables & function's
variables 
-L'input est directement utilisé ONLY one Input
-Les return doivent être remplacés par des "x-> out =" (Litérallement)
-Tout est en passage par référence. Donc, ce n'est un cas à traiter.
-Les threads ne font qu'exécuter le corps des fonctions. 
-Le master nood créée la pool


Les cas faisant état d'exception : 
    -L'appel d'une fonction à l'intérieur d'une fonction
    -
*/

pthread_mutex_t mutex_s;
pthread_cond_t cond_s;

typedef struct
{

int ini_a;
int ini_b;

    //op1
int op1_in;
int op1_out;
    //op2
int op2_out;
    //op3
int op3_in31;
int op3_in32;
int op3_out3;

}
data;


void *a1 (void * d)
{
    //Cette ligne se répète (Pour l'instant) dans toutes les fonctions.
    data *dd =  d; 
    dd->op1_out = dd->ini_a++;
    return NULL;
}

void *a2(void *b)
{
    data *dd =  b;
   int b =1;
   dd->op2_out = ++b;

return NULL;
}

void *a3(void *a)
{
    data *dd = a;
   

    printf("value 1 : %d\n",dd->op1_in);
    printf("value 1 : %d\n",dd->op1_in);
    return NULL;
}


int main ()
{

data d1;
d1.ini_a = 2; 
d1.op1_in = d1.ini_a;

pthread_t ret, ret2, ret3;

pthread_create (&ret, NULL, a1, (void *) &d1);

pthread_create (&ret2, NULL, a2,(void*) &d1);      
pthread_create (&ret3, NULL, a3, (void *) &d1);

pthread_join(ret, NULL);
pthread_join(ret2, NULL);
pthread_join(ret3, NULL);

}