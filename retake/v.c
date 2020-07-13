#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <omp.h>
#include </home/refl/Desktop/ops.h>

#define TRUE 1
#define FALSE 0
#define FULL 10
#define MAXTHREAD 7



struct variable
{

  char v[10];			//Variable peut contenir jusqu'C  10 caractC(res

};


struct func
{

  char v[10];


};

struct module
{

  char func[60];
  struct variable v_in[20];	// 20 input et dans chacun une variable de 10 character
  int n_v_in;
  struct variable v_out[20];	// 20 output
  int n_v_out;
  struct func depnd[100]; //Le bas //Les fonctions dont dC)pend cette fonction
  struct func dependent[100];	//Le haut //depend de combien de fonctions
  int n_depnd;              
  int n_dependent;  //Combien de fonctions en dépendent
  float time;		//Temps d'execution

};

/*
struct node
{
    int data;
    struct node *next;
};
typedef struct node node;

struct queue
{
    int count;
    node *front;
    node *rear;
};
typedef struct queue queue;

void initialize(queue *q)
{
    q->count = 0;
    q->front = NULL;
    q->rear = NULL;
}

int isempty(queue *q)
{
    return (q->rear == NULL);
}

void enqueue(queue *q, int value)
{
    if (q->count < FULL)
    {
        node *tmp;
        tmp = malloc(sizeof(node));
        tmp->data = value;
        tmp->next = NULL;
        if(!isempty(q))
        {
            q->rear->next = tmp;
            q->rear = tmp;
        }
        else
        {
            q->front = q->rear = tmp;
        }
        q->count++;
    }
    else
    {
        printf("List is full\n");
    }
}

int dequeue(queue *q)
{
    node *tmp;
    int n = q->front->data;
    tmp = q->front;
    q->front = q->front->next;
    q->count--;
    free(tmp);
    return(n);
}

void display(node *head)
{
    if(head == NULL)
    {
        printf("NULL\n");
    }
    else
    {
        printf("%d\n", head -> data);
        display(head->next);
    }
}
*/
int main ()
{


char dotname[10] = "td.dot";
char sup[10] = "extra.txt";
FILE *f, *ff, *fff;
f = fopen ("pp.txt", "r");
ff = fopen(dotname,"w");
fff = fopen(sup,"w");



char first[12];
strcpy(first,"digraph a {");
fprintf(ff,"%s",first);
fprintf(ff,"\n");

struct module modules[20]; //Nombre de ligne du fichier profile


char c;
char word[60];

strcpy (word, "");

int count = 1, 
	fonction = 0,
	n_fonction = 0, //Utiliser pour remplacer -fonction-
	nbv = 0,
	no_depend = 0,
	etage_depend = 0,
	nb_etages = 0;



int i,
	j,
	k,
	l,
	d,
	depend,
	broke=0, //used as boolean
    empty=0; //used as boolean


while (c=fgetc(f))
{

    if(c != EOF)

    {

        if(c == ' ' && count == 1)
        {
        strncpy(modules[fonction].func, word, strlen(word));	
        printf("%s\n",word);
        printf("%ld\n",strlen(word));

        count ++;
        strncpy(word,"",1);
        continue;
        printf("did not");
        }

        if(c == ' ' && count == 2)
        {

        if(empty == 0)
        {
        strncpy(modules[fonction].v_in[nbv].v, word, strlen(word));

        printf("%s\n",word);
        printf("%ld\n",strlen(word));

        strncpy(word,"",1);
        modules[fonction].n_v_in = nbv + 1; //+1 for the last one copied localy
        }
        empty = 0;
        nbv = 0;
        count++;
        continue;
        printf("did not");
        }

        if(c == ' ' && count == 3)
        {
            if(empty == 0)
            {
        strncpy(modules[fonction].v_out[nbv].v, word, strlen(word));
        //printf("%s\n",word);

        strncpy(word,"",1);
        modules[fonction].n_v_out = nbv + 1;
            }
        //+1 for the last one copied localy
        empty = 0;
        nbv = 0;
        count++;
        continue;
        printf("did not");
        }

        if(c == '\n' && count == 4)
        {   
            modules[fonction].time = atof(word);
            strncpy(word,"",1);
            nbv = 0;
            count = 1;
            fonction++;
            continue;

        }

        if(count == 1) //nom
        {
        strncat(word, &c,1);

        }

        if(count == 2)
        {

            if(c == '/')
            {
                empty = 1;
            }
            
            else
            {
                if(c == ',')
                {
                    strncpy(modules[fonction].v_in[nbv].v, word, strlen(word));
                    nbv++;
                    strncpy(word,"",1);
                }
                else
                {
                    strncat(word, &c,1);
                }
            }

        }

        if(count == 3)
        {

            if(c == '/')
            {
                empty = 1;
            }
            
            else
            {
                if(c == ',')
                {
                printf("%s\n",word);
                strncpy(modules[fonction].v_out[nbv].v, word, strlen(word));
                nbv++;
                strncpy(word,"",1);
                printf("%ld\n",strlen(word));
                }
                else
                {
                    strncat(word, &c,1);
                }
                
                

            }
        }

        if(count == 4)
        {
            strncat(word, &c,1);
        }

    }


    else
    //PARTIE END OF FILE
    {
    printf("j\n");
        if(count == 4)

        {
            
            modules[fonction].time = atof(word);
            
            strncpy(word,"",1);
            
            count = 0;
            nbv = 0;
            fonction++;
            
        }

    break;
    }

}


printf("%d\n", fonction);
fclose(f);

for (i = 0; i < fonction; i++)

    {
      printf ("Name of module : ");
      printf ("%s\n", modules[i].func);

      printf ("\t|INPUTS :");

      for (j = 0; j < modules[i].n_v_in; j++)
	{
	  printf ("%s", modules[i].v_in[j].v);

	  if (j != modules[i].n_v_in - 1)
	    printf ("|");

	}

	printf ("\n\t|OUTPUTS :");
	for (j = 0; j < modules[i].n_v_out; j++)
	{
	  printf ("%s", modules[i].v_out[j].v);

	  if (j != modules[i].n_v_out - 1)
	    printf ("|");


	}

   
	printf("\n");
    printf("Execution time : %f", modules[i].time);
    printf("\n");
    printf("\n");

	}

for (i = 0; i < fonction; i++)

    {
      
      d = 0;
      strncpy (modules[i].depnd[d].v, "",1);
      
      

      for (k = 0; k < fonction; k++)
	{
	  if (i == k)
	    
	    continue;


	  //compare input(j) of i with output(l) of k
		  for (j = 0; j < modules[i].n_v_in; j++)	//input of i 
		    {
		      for (l = 0; l < modules[k].n_v_out; l++)	//Output of j
			{
			    printf("%s\n",modules[i].v_in[j].v);
			    printf("%s\n",modules[k].v_out[l].v);
			    printf ("str : %d\n",strcmp(modules[i].v_in[j].v, modules[k].v_out[l].v));
			  if (strcmp (modules[i].v_in[j].v, modules[k].v_out[l].v) == 0)
			    {
			      //printf("%d",l);
			      printf ("entered\n");
			      strncpy (modules[i].depnd[d].v, modules[k].func, strlen(modules[k].func));
			      
			      d++;
			      break;

			    }


			}



		    }

	}


      modules[i].n_depnd = d;

    }

//Display the dependency of each function

  for (i = 0; i < fonction; i++)

    {
      printf ("OP  %d :\n", i + 1);

      if(modules[i].n_depnd != 0)
      {
	      for (j = 0; j < modules[i].n_depnd; j++)
		{
		  printf ("\t %s \n", modules[i].depnd[j].v);
		}
	  
	  }
	  else
	  {
	  	printf("\tNothing");
	  }

	printf("\n");

    }

    n_fonction = fonction;

    k = 0;
printf("11");
//op1();
//op1();
    printf("11rororo");

//Write the dot file and display it.

     for (i = 0; i < fonction; i++)

    {
      

      if(modules[i].n_depnd != 0)
      {
	      for (j = 0; j < modules[i].n_depnd; j++)
		{
            fprintf(ff,"%s",modules[i].depnd[j].v);
            if(j != modules[i].n_depnd - 1)
            {
                fprintf(ff,",");
            }
            
		    
            //printf ("\t %s \n", modules[i].depnd[j].v);
        
		}

        fprintf(ff,"->");
        fprintf(ff,"%s",modules[i].func);
        fprintf(ff,"\n");

	  
	  }
	  else
	  {
	  	fprintf(ff,"%s",modules[i].func);
        fprintf(ff,"\n");
	  }

	

    }

    fprintf(ff,"}");

fclose(ff);

//Module fonction dépendent
for(i=0;i<fonction;i++)
{   int c=0;
    for(j=0;j<fonction;j++)
    {
        for(k=0;k<modules[j].n_depnd;k++)
        {
            if(strcmp (modules[i].func, modules[j].depnd[k].v) == 0)
            {
                
                strncpy (modules[i].dependent[c].v, modules[j].func, strlen(modules[j].func));
                c++;

            }
        }
    }
    modules[i].n_dependent = c; // le haut
}

for(i=0;i<fonction;i++)
{   printf("\n%s",modules[i].func);
    printf("DPP %d \n",modules[i].n_dependent); // le haut
}
//Module parallélisation Needs lex 
/*call function by name
*pass its argument*/

//Module extra data

for(i=0;i<fonction;i++)
{
    fprintf(fff,"%s",modules[i].func);
    fprintf(fff," ");
    fprintf(fff, "%d", modules[i].n_depnd); //le haut
    fprintf(fff," ");
    for(j=0;j<modules[i].n_dependent;j++)
    {
        fprintf(fff,"%s",modules[i].dependent[j].v); //le bas
        fprintf(fff, " ");
    }
    fprintf(fff,"\n");
}

system("xdot td.dot");
fclose(fff);
//Ordonnanceur



}