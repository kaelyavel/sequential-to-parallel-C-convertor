 
	/*pour l'executer le cmd suivante
		flex v2.l
		gcc lex.yy.c -ll
		./a.out < profile-data.txt
	*/  
%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
FILE* fichier=NULL;
int lineno=1;  
char phrase[300] = "#pragma omp task ";
//quoi qu'il arrive y aura tjr qu'un seul ouput
char output[20]= "\0";

//à la bachiiiir
typedef struct Inputs Inputs;
struct Inputs
{
    char in[20];
};

Inputs Input[20];


/*
//pour gérer plsr input
typedef struct Input Input;
struct Input
{
    char in[20];
    Input *suivant;
};

//initialisation de la liste 
Input *initialisation()
{
    Input *elt = malloc(sizeof(*Input));

    if (elt == NULL)
    {
        exit(EXIT_FAILURE);
    }

    elt->in = "\0";
    elt->suivant = NULL;
    return Input;
}
*/

%}

%option noyywrap
         
var    [a-zA-Z][0-9a-zA-Z]* 
  

     
%%
 
	/*ajout de l'include*/ 

"\n"            { 	if (lineno==1){ 
			fputs("\n", fichier);
			fputs("#include<omp.h> \n", fichier);		
			}
		fputs("\n", fichier);
		lineno++;
		}


	/*traitement des fct les procedure viendront plus tard */
	/*premier cas avec ou sans  input*/

" "*{var}" "*"="" "*{var}""*"("" "*({var}" "*(","" "*{var}" "*)*)*")"  { 
		
                
		fputs("ici repose une fonction a paralelise \n",fichier);
		//debut de l'enfer 
		//avec 200 je suis large normalement
		char ligne[200];
		strcpy(ligne,yytext);
		printf("%s \n",ligne);
		//faudrait d'abord construire la phrase
		// #pragma omp task shared(x) depend(out: x)
		//
		// pui se fprintf(fichier, %s , instruction); 
		fprintf(fichier, "%s", yytext);

		
		}

	/*traitement procedure*/

" "*{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"";" {
		fputs("ici repose une procedure a paralelise \n",fichier);
		char ligne[200];
		strcpy(ligne,yytext);
		printf("%s \n",ligne);
		fprintf(fichier, "%s", yytext);
			} 



	/*ecriture du reste du fichier tel quel*/
. {fprintf(fichier, "%s", yytext);}
     
     
%%    
 int main(){
int i=0;		
fichier = fopen("testepara.c", "w+"); 
if (fichier != NULL)
    {	
	yylex();
	fclose(fichier);
	}
else
	printf("Impossible d'ouvrir le fichier testepara.c");

return EXIT_SUCCESS;
    }
