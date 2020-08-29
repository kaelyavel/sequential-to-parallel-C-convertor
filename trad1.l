%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
#include<ctype.h>
FILE* fichier=NULL;
FILE* fichier1=NULL;
FILE* fichier2=NULL; 
int inMain=0,fait=0;

	/*typedef struct fct fct;
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

	Liste *initialisation()
	{
	Type* variable = malloc (nombre * sizeof(*Type));
    Liste *liste = malloc(sizeof(*Liste));
    fct *fct = malloc(sizeof(*fct));

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
	{*/
    /* Création du nouvel élément */
   /* fct *nouveau = malloc(sizeof(*nouveau));
    if (liste == NULL || nouveau == NULL)
    {
        exit(EXIT_FAILURE);
    }
    //nouveau->nom = nvNombre;
    strcpy(nouveau->nom,nvNom);*/

    /* Insertion de l'élément au début de la liste */
    /*nouveau->suivant = liste->premier;
    liste->premier = nouveau;
	}*/

%}

var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
nbr    [0-9]+

%%


"int nbr_for_"{var}";" {
	fprintf(fichier, "\t%s\n",yytext );
}


{var}": notifier(\""{var}"\" , d);" {
	fprintf(fichier2, "%s\n", yytext );
}

	



"\n" { } 
. { }
%%    
int main(){		
fichier = fopen("sebiss.c", "a+"); 
fichier1 = fopen("sebiss1.txt", "r+");
fichier2 = fopen("sebiss2.txt", "w+");
if (fichier2 != NULL)
    {
		if (fichier1 != NULL)
		    {
if (fichier != NULL)
    {	
	yylex();
	fputs("\tThreadPool *pool;\n}\n\n",fichier);

	//ecriture de la fonction notifier
	fputs("void notifier(char name[],void *d )\n{\ndata *dd = d;",fichier);

	fclose(fichier);
	}
else
	printf("Impossible d'ouvrir le fichier sebiss.c");
		
			fclose(fichier1);
			}
		else
			printf("Impossible d'ouvrir le fichier sebiss.c");	
	fclose(fichier2);
	}
else
	printf("Impossible d'ouvrir le fichier sebiss.c");

return EXIT_SUCCESS;
}
