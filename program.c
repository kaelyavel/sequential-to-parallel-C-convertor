#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <omp.h>


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
  struct func depnd[100];	//Les fonctions dont dC)pend cette fonction
  int n_depnd;			//depend de combien de fonctions

};



int main () 
{

FILE *f;
f = fopen ("profile.txt", "r");
struct module modules[20];


char c;
char word[60];

strcpy (word, "");

int count = 1, 
	fonction = 0,
	nbv = 0;

int i,
	j,
	k,
	l,
	d,
	depend;


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

	strncpy(modules[fonction].v_in[nbv].v, word, strlen(word));

	printf("%s\n",word);
	printf("%ld\n",strlen(word));

	strncpy(word,"",1);
	modules[fonction].n_v_in = nbv + 1; //+1 for the last one copied localy
	nbv = 0;
	count++;
	continue;
	printf("did not");
	}

	if(c == '\n' && count == 3)
	{

	strncpy(modules[fonction].v_out[nbv].v, word, strlen(word));
	//printf("%s\n",word);

	strncpy(word,"",1);
	modules[fonction].n_v_out = nbv + 1; //+1 for the last one copied localy
	nbv = 0;
	count = 1;
	fonction++;
	continue;
	printf("did not");
	}

	if(count == 1)
	{
	strncat(word, &c,1);

	}

	if(count == 2)
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

	if(count == 3)
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


else

{
printf("j\n");
	if(count == 3)

	{
		printf("jj\n");
		printf("%s\n",word);
		strncpy(modules[fonction].v_out[nbv].v, word, strlen(word));
		modules[fonction].n_v_out = nbv + 1; //Last one processed internaly
		strncpy(word,"",1);
		printf("%ld\n",strlen(word));
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

return 0;

}
