#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
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

struct niveau1{
    char nom[60];
    float tmp;
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




int main ()
{


char dotname[10] = "td.dot";
char sup[10] = "extra.txt";
FILE *f, *ff, *fff;
FILE* fichier=NULL;
FILE* fichier2=NULL;
f = fopen ("inter.txt", "r");
ff = fopen(dotname,"w");
fff = fopen(sup,"w");
fichier2 = fopen("para02.txt", "w");
fichier = fopen("out.txt", "w");



char first[12];
strcpy(first,"digraph a {");
fprintf(ff,"%s",first);
fprintf(ff,"\n");

struct module modules[20]; //Nombre de ligne du fichier profile
struct niveau1 fct[20]; 

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
        count ++;
        strncpy(word,"",1);
        continue;
        }

        if(c == ' ' && count == 2)
        {

        if(empty == 0)
        {
        strncpy(modules[fonction].v_in[nbv].v, word, strlen(word));
        strncpy(word,"",1);
        modules[fonction].n_v_in = nbv + 1; //+1 for the last one copied localy
        }
        empty = 0;
        nbv = 0;
        count++;
        continue;
        }

        if(c == ' ' && count == 3)
        {
            if(empty == 0)
            {
        strncpy(modules[fonction].v_out[nbv].v, word, strlen(word));

        strncpy(word,"",1);
        modules[fonction].n_v_out = nbv + 1;
            }
        //+1 for the last one copied localy
        empty = 0;
        nbv = 0;
        count++;
        continue;
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
                strncpy(modules[fonction].v_out[nbv].v, word, strlen(word));
                nbv++;
                strncpy(word,"",1);
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

fclose(f);

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
			  if (strcmp (modules[i].v_in[j].v, modules[k].v_out[l].v) == 0)
			    {
			      strncpy (modules[i].depnd[d].v, modules[k].func, strlen(modules[k].func)); 
			      d++;
			      break;
			    }
			}
	    }
	}
      modules[i].n_depnd = d;
    }
    n_fonction = fonction;

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

//Module extra data
if (fichier2 != NULL)
    {
        if (fichier != NULL)
    {
        int m=0,taillle=0;
for(i=0;i<fonction;i++)
{
    //fprintf(fff,"%s ",modules[i].func);
    for(j=0;j<modules[i].n_dependent;j++)
    {
        fprintf(fichier2,"%s: %s/\n",modules[i].func,modules[i].dependent[j].v); //le bas
        
    }
    if(modules[i].n_depnd !=0){
        fprintf(fff, "int nbr_for_%s; ", modules[i].func);
        fprintf(fff, "d1.nbr_for_%s = %d; ", modules[i].func,modules[i].n_depnd); //le haut
        fprintf(fff, "void %s (void * d );",modules[i].func);
    }
    else
    {   

        //strcpy(fct[m].nom,modules[i].func);
        strncpy (fct[m].nom, modules[i].func, strlen(modules[i].func)); 
        fct[m].tmp=modules[i].time;
        m++;
        taillle++;
    }
    int fait=0; 
    for(j=0;j<modules[i].n_v_out;j++)
    {
        if(strcmp (modules[i].v_out[j].v," ")!=0){
            if(fait==0) {
               fprintf(fichier,"\n%s:",modules[i].func); 
               fait=1;
            }
            fprintf(fichier,"%s,",modules[i].v_out[j].v);
        }
    }
    fprintf(fff,"\n");
}


int imin,min;
char inter[60];
for(i=0;i<taillle;i++)
{
    imin=i;
    min=fct[i].tmp;
    for (j=i + 1; j < taillle; j++)
    {
      if (fct[imin].tmp > fct[j].tmp)
        imin = j;
    }
    if (imin != i)
    {
      strcpy(inter,fct[i].nom);
      strcpy(fct[i].nom,fct[imin].nom);
      strcpy(fct[imin].nom,inter);
    }
}
for(i=0;i<taillle;i++)
{
    fprintf(fff, "addJobToPool(pool, &%s, &d1); ",fct[i].nom);
}
fclose(fichier);
}
else
    printf("Impossible d'ouvrir le fichier out.txt");
fclose(fichier2);
}
else
    printf("Impossible d'ouvrir le fichier sebiss2.txt");
//system("xdot td.dot");
fclose(fff);
return 0;

}
