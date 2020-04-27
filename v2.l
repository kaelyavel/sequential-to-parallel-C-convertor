 
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
" "*"*/"" "*{var}" "*"="" "*{var}""*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";"" "*"*/"  {fprintf(fichier, "%s", yytext);}	

		/*appele de procedure souscom*/

" "*"/*"" "*{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";"" "*"*/" {fprintf(fichier, "%s", yytext);}


	/*simple test epour les commantaire*/
	/*le premier marche*/
"//".+ {fprintf(fichier, "%s", yytext);}
"/*".+"*/" {fprintf(fichier, "%s", yytext);}
	
	/*traitement des fct les procedure viendront plus tard */
	/*premier cas avec ou sans  input*/

{var}" "*"="" "*{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";"  { 
				
			
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
		char output[50]="depend(out:";
		int t=strlen(output);
		while((ligne[j]!= '=') && (j<count)){
			output[t++]=ligne[j];
			j++;
		}
		char tmp[200]="#pragma omp task ";
		char tmp2[]= ")";
		strcat (tmp, output);
		strcat (tmp, tmp2);
			 
		//passage aux input
		//position parenthese ouvrante
		int position=count;
		for(i=count-1;i<v;i++) {
			if(ligne[i] == '(') break;
                	position++;
		}
		char phrase[50]="  depend(in:";
		t=strlen(phrase);
		while((ligne[i]!= ')') && (position<v-1)){
			phrase[t++]=ligne[position];
			position++;
		}		
		strcat(tmp,phrase);
			
		
		// #pragma omp task shared(x) depend(out: x)
		//
		fprintf(fichier, "%s\n", tmp); 
		fprintf(fichier, "%s\n", yytext);
		}

	/*traitement procedure*/

{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";" {
		/*extraction de laligne et copie dans une varible tomporaire*/
		int v = strlen(yytext); 
		char ligne[v];		
		strcpy(ligne,&yytext[0]);		
		//input
		char tmp3[200]="#pragma omp task ";
		int position=0,i;
		for(i=0;i<v;i++) {
			if(ligne[i] == '(') break;
                	position++;
		}

		char phrase[50]="depend(in: ";
		int t=strlen(phrase);
		while((ligne[position]!= ')') && (position<v-2)){
			phrase[t++]=ligne[position+1];
			position++;
		}		
		strcat(tmp3,phrase);		
		fprintf(fichier, "%s\n", tmp3); 
		fprintf(fichier, "%s\n", yytext);
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
