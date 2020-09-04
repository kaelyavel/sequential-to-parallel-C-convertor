%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
#include<ctype.h>
FILE* fichier=NULL; 
FILE* fichier1=NULL;
int inMain=0,fait=0;

typedef struct fct fct;
	struct fct
	{
	    char nom[50];

	    fct *suivant;
	};

typedef struct Liste Liste;
struct Liste
	{
	    fct *premier;
	};

Liste *maListe;




Liste *initialisation()
	{
	//Type* variable = malloc (nombre * sizeof(*Type));
    Liste* liste = malloc(sizeof(Liste));
    fct* fct = malloc(sizeof(*fct));

    if (liste == NULL || fct == NULL)
    {
        exit(EXIT_FAILURE);
    }

    *fct->nom = '\0';
    fct->suivant = NULL;
    liste->premier = fct;

    return liste;
	}
void insertion(Liste *liste, char *nvNom)
	{
    /* Création du nouvel élément */
   fct *nouveau = malloc(sizeof(*nouveau));
    if (liste == NULL || nouveau == NULL)
    {
        exit(EXIT_FAILURE);
    }
    //nouveau->nom = nvNombre;
    strcpy(nouveau->nom,nvNom);

    /* Insertion de l'élément au début de la liste */
    nouveau->suivant = liste->premier;
    liste->premier = nouveau;
	}

void afficherListe(Liste *liste)
{
    if (liste == NULL)
    {
        exit(EXIT_FAILURE);
    }

    fct *actuel = liste->premier;

    while (actuel != NULL)
    {
    	if(strlen(actuel->nom)!=0)
    	{
	        fprintf(fichier,"\tif(strcmp (name, \"%s\") == 0)\n\t{\n", actuel->nom);  
		    fprintf(fichier,"\t\t--dd->nb_for_%s;\n",actuel->nom);       
		    fprintf(fichier,"\t\tif(dd->nb_for_\"%s\" == 0)\n\t\t{\n",actuel->nom);
		    fprintf(fichier, "\t\t\taddJobToPool(dd->pool, &%s, d);\n\t\t}\n\t}\n",actuel->nom);
		}
        actuel = actuel->suivant;
    }
}

void suppression(Liste *liste)
{
    if (liste == NULL)
    {
        exit(EXIT_FAILURE);
    }

    if (liste->premier != NULL)
    {
        fct *aSupprimer = liste->premier;
        liste->premier = liste->premier->suivant;
        free(aSupprimer);
    }
}

%}

var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
nbr    [0-9]+

%%


"int nbr_for_"{var}";" {
	int v = strlen(yytext);
	char ligne[v];
	int i,position,rep=0,j=0;	
	char chaine[20];	
	strcpy(ligne,&yytext[0]);
	fprintf(fichier, "\t%s\n",ligne );
	char output[100];
	for(i=0;i<v;i++){
		if(ligne[i]==' ') continue;
		if(ligne[i]=='_') rep++;
		if(rep==2) {
			position=i+1;
			break;
		}
	}
	for(i=position;i<v;i++){
		if(ligne[i]==';') break;
		output[j]=ligne[i];
		j++;
	}
	insertion(maListe, output);
}

"d1.nbr_for_"{var}" = "{nbr}";"  { 
						fprintf(fichier1, "%s\n",yytext );
								}

"\n" { } 
. { }
%%    
int main(){		
maListe = initialisation();
fichier = fopen("sebiss.c", "a+");
fichier1 = fopen("sebiss1.txt", "a+"); 
if (fichier1 != NULL)
    {
if (fichier != NULL)
    {	
	yylex();
	fputs("\tpthread_mutex_t mutex_pile;\n\tpthread_cond_t cond_pile; \n",fichier);
	fputs("\tThreadPool *pool;\n}\n\n",fichier);
	fputs("void notifier(char name[],void *d )\n{\n\tdata *dd = d;\n",fichier);
    afficherListe(maListe);   
	fputs("}\n\n",fichier);
	fclose(fichier);
	}
else
	printf("Impossible d'ouvrir le fichier sebiss.c");
}
else
	printf("Impossible d'ouvrir le fichier sebiss1.txt");
	suppression(maListe);


return EXIT_SUCCESS;
}
