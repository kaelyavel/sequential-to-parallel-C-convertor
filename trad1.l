%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
#include<ctype.h>
FILE* fichier=NULL; 
FILE* fichier1=NULL;
FILE *tmp=NULL;
int inMain=0,existe=0,fait=0;

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
	        fprintf(fichier,"\t\t--dd->nbr_for_%s;\n",actuel->nom);       
	        fprintf(fichier,"\t\tif(dd->nbr_for_%s == 0)\n\t\t{\n",actuel->nom);
	        fprintf(fichier, "\t\t\taddJobToPool(dd->pool, &%s, dd);\n\t\t}\n\t}\n",actuel->nom);
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
	/*detecter les entetes et les réecrire*/
"void".+"(void * d );" {
		fprintf(tmp, "%s\n",yytext );
	}

"int nbr_for_"{var}";" {
	int v = strlen(yytext);
	char ligne[v];
	int i,position,rep=0,j=0;	
	char chaine[20];	
	strcpy(ligne,&yytext[0]);
	fprintf(fichier, "\t%s\n",ligne );
	char output[100];
	memset (output, 0, sizeof (output));
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
	existe=1;
}

"d1.nbr_for_"{var}" = "{nbr}";"  { fprintf(fichier1, "%s\n",yytext );}

"\n" { } 
. { }
%%    
int main(){		
maListe = initialisation();
fichier = fopen("para.c", "a+");
fichier1 = fopen("para01.txt", "a+");
tmp = fopen("tmp.txt", "w+"); 
char par[20];
memset (par, 0, sizeof (par));
if (fichier1 != NULL)
    {
if (fichier != NULL)
    {
	if(tmp != NULL){
	    fputs("\n",fichier1);	
		yylex();
		fputs("\tThreadPool *pool;\n} Data;\n\n",fichier);
		fseek(tmp, 0, SEEK_SET); 	
		while(fgets(par,20, tmp) != NULL){
		fprintf(fichier, "%s ",par);
		}
		if(existe==1){
		fputs("\nvoid notifier(char name[],void *d )\n{\n\tData *dd = d;\n",fichier);
	    afficherListe(maListe);   
		fputs("}\n\n",fichier);
		}
		fclose(tmp);
		}
	else
		printf("Impossible d'ouvrir le fichier tmp.txt");
	fclose(fichier);
	}
	else
		printf("Impossible d'ouvrir le fichier sebiss.c");
fclose(fichier1);
}	
else
	printf("Impossible d'ouvrir le fichier sebiss1.txt");
	suppression(maListe);


return EXIT_SUCCESS;
}
