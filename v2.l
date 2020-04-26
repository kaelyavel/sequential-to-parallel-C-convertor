 
	/*pour l'executer le cmd suivante
		flex v2.l
		gcc lex.yy.c -ll
		./a.out < teste.c
	*/  
%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
FILE* fichier=NULL;
int lineno=1;  


//à la bachiiiir
typedef struct Inputs Inputs;
struct Inputs
{
    char in[20];
};

Inputs Input[20];


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
	
	/*pour ne pas prendre en compte les appele sous-commantaire*/
		
		/*appele de fonction*/
" "*"//"" "*{var}" "*"="" "*{var}""*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";"  {fprintf(fichier, "%s", yytext);}
" "*"*/"" "*{var}" "*"="" "*{var}""*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";"" "*"*/"  {fprintf(fichier, "%s", yytext);}
		/*appele de procedure souscom*/
" "*"//"" "*{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";" {fprintf(fichier, "%s", yytext);}
" "*"/*"" "*{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";"" "*"*/" {fprintf(fichier, "%s", yytext);}

	/*traitement des fct les procedure viendront plus tard */
	/*premier cas avec ou sans  input*/

" "*{var}" "*"="" "*{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";"  { 
				
			
		int v = strlen(yytext);
		char ligne[v];
		//copie juste de la premiere case de yytext		
		strcpy(ligne,&yytext[0]);
		//debut du traitement sur ligne
		//extraction de l'output
		int i=0,j=0,count=0;
		for(i=0;i<v;i++) {
			if(ligne[i] == '=') break;
                	count++;
		}	
		char output[count];
		//copie de count(n char) de ligne vers output 	
		strncpy (output,ligne, count);
		
		char tmp[]="#pragma omp task depend(out:";
		char tmp2[]= ")";
		strcat (tmp, output);
		strcat (tmp, tmp2);
		//strcat (phrase, tmp);
		printf("%s\n",tmp);
	
		//tout est juste au dessus 
		//passage aux input
		//position parenthese ouvrante
		int position=count;
		for(i=count-1;i<v;i++) {
			if(ligne[i] == '(') break;
                	position++;
		}
		/*while(ligne[i]!= ')'){
		

		}	*/	
		
		
		
			
		//faudrait d'abord construire la phrase
		// #pragma omp task shared(x) depend(out: x)
		//
		fprintf(fichier, "%s\n", tmp); 
		fprintf(fichier, "%s\n", yytext);
		}

	/*traitement procedure*/

" "*{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";" {
		/*extraction de laligne et copie dans une varible tomporaire*/
		int v = strlen(yytext);
		//printf("%d \n",v); 
		char ligne[v];		
		strcpy(ligne,&yytext[0]);

		
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
