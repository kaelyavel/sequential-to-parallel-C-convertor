 
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
int include=0;
int fait=0,inMain=0;
void traitement(char *ligne,int v){
		char tmp[200]="#pragma omp task ";
		char tmp2[]= ")";
		
		//debut du traitement sur ligne
		//extraction de l'output
		int i=0,j=0,count=0;
		for(i=0;i<v;i++) {
			if(ligne[i] == '=') break;
			//debut des changement
			if(ligne[i] == '/') break;
			if(ligne[i] == '*') break;
			if((ligne[i] == '-') &&(ligne[i+1] == '=')) break;
			if(ligne[i] == '+') break;
	         	count++;
		}
		char output[100]="depend(out:";
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
			}
%}

%option noyywrap
        /*remarque
	? zero ou une seule foi
	* zero ou plsr fois*/ 
var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
var1   [a-zA-Z][0-9a-zA-Z]*("->"|".")?[0-9a-zA-Z]+
	
		/*chiffre  (\+|\-)?[0-9]+("."[0-9]+)?*/
		
%%
 
	/*ajout de l'include*/ 
"#include".+       { 	if (include==0){ 
					fputs("#include<omp.h>\n", fichier);		
					include++;			
				}
				fprintf(fichier, "%s", yytext);
			}		

	/*pour ne pas prendre en compte les appele sous-commantaire*/
"//".+ {fprintf(fichier, "%s", yytext);}
"/*".+"*/" {fprintf(fichier, "%s", yytext);}

	/*position du main*/
"int"" "+"main".+ {	inMain=1;
			fprintf(fichier, "%s", yytext);}

	/*teste sur les chiffres*/
	/*{chiffre} {
		if(inMain==1){		
	
		fputs("#pragma omp chiffre\n",fichier);
		}
		fprintf(fichier, "%s\n", yytext);
		}*/

({var1}|{var})" "*"=""=".+ {}
	
	/*traitement des fct sans parametre numerique*/
	
({var1}|{var})" "*"+"?"-"?"*"?"/"?"="" "*{var}" "*"("" "*(({var1}|{var})" "*(","" "*({var1}|{var})" "*)*)*")"" "*";"  {
		if(inMain==1){		
		if (fait==0){	
		fputs("#pragma omp parrallel\n", fichier);
		fputs("#pragma omp single\n",fichier);
		fputs("{\n", fichier);
		fait=1;}
		int v = strlen(yytext);
		char ligne[v];
		//copie juste de la premiere case de yytext		
		strcpy(ligne,&yytext[0]);
		traitement(ligne,v);	
		}
		fprintf(fichier, "%s\n", yytext);
		}

	/*traitement procedure*/

{var}" "*"("" "*(({var1}|{var})" "*(","" "*({var1}|{var})" "*)*)*")"" "*";" {
	if(inMain==1){		
		if (fait==0){	
			fputs("#pragma omp parrallel\n", fichier);
			fputs("#pragma omp single\n",fichier);
			fputs("{\n", fichier);
			fait=1;	}
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
		    		printf("pas asser d'epace, priere de racourcir le nom de s variable en entres\n");
             					break; }
			phrase[taille++]=ligne[i];
		}
		taille=strlen(phrase);

		if(cpm!= taille){				
			fprintf(fichier, "%s\n", strcat(tmp3,phrase));
		} }
		fprintf(fichier, "%s\n", yytext);
			
		} 


		/*60is the octal value of zero*/
"return"" "*"("*"\60"" "*")"*";" {if(inMain==1){fputs("}\n", fichier);}
		fprintf(fichier, "%s\n", yytext);}
"return".+";" {if(inMain==1){fputs("}\n", fichier);}
		fprintf(fichier, "%s\n", yytext);}
"return"" "+"EXIT_SUCCESS"" "*";" {if(inMain==1){fputs("}\n", fichier);}
		fprintf(fichier, "%s\n", yytext);}

"\n" 	{fputs("\n", fichier);}
	
	

	/*ecriture du reste du fichier tel quel*/
. {fprintf(fichier, "%s", yytext);}
     
     
%%    
int main(){		
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
