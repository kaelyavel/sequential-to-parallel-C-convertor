 
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
		char tmp[200]="#pragma omp task ";
		char tmp2[]= ")";
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
		int taille=strlen(output);
		while((ligne[j]!= '=') && (j<count)){
			output[taille++]=ligne[j];
			j++;
		}
		
		
			 
		//passage aux input
		//position parenthese ouvrante
		int position=count, cpm;
		for(i=count-1;i<v;i++) {
			if(ligne[i] == '(') break;
                	position++;
		}
		
		char phrase[50]="  depend(in:";
		taille=strlen(phrase);
		cpm=taille+1;	
		for(i=position;i<v;i++){
			if(ligne[i]==';') break;
			if(ligne[i]== ' ') continue;
			if(taille==50) {
      		printf("pas asser d'epace, priere de racourcir le nom des variable en entres\n");	             					break; }
			phrase[taille++]=ligne[i];
		}
		taille=strlen(phrase);


		//construction de l'instruction
		strcat (tmp, output);
		strcat (tmp, tmp2);
		if(cpm !=taille)		
			strcat(tmp,phrase);
			
		fprintf(fichier, "%s\n", tmp); 
		fprintf(fichier, "%s\n", yytext);
		}

	/*traitement procedure*/

{var}" "*"("" "*({var}" "*(","" "*{var}" "*)*)*")"" "*";" {
		/*extraction de la ligne et copie dans une varible tomporaire*/
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
		int taille=strlen(phrase);
		int cpm=taille+1;

		for(i=position+1;i<v;i++){
			if(ligne[i]==';') break;
			if(ligne[i]== ' ') continue;
			if(taille==50) {
      		printf("pas asser d'epace, priere de racourcir le nom de s variable en entres\n");	             					break; }
			phrase[taille++]=ligne[i];
		}
		taille=strlen(phrase);

		if(cpm!= taille){				
			fprintf(fichier, "%s\n", strcat(tmp3,phrase));
		} 
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
