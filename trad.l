	/*ce fichier flex ne prend en compte que : 
	 - les declaration simple de type (int/float a;) ou (int/float a= val;) ou (int/float a,b ,c)
	 */ 
%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
#include<ctype.h>
FILE* fichier=NULL; 
FILE* fichier1=NULL;
FILE* fichier2=NULL;
FILE* fichier3=NULL;
FILE* fichier4=NULL;
int include=0;
int inMain=0,fait=0;
char chaine[100] = "";
%}

        /*remarque
	? zero ou une seule fois
	* zero ou plsr fois
	+ une seul fois minimum*/ 
	/*var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]**/

	/*la declaration de var1 a due changer pour accepter en entres des valeur numerique*/
	/*var1   [0-9a-zA-Z]+("->"|".")?[0-9a-zA-Z]**/
	
	/*var     [a-zA-Z]+("->"|".")?[0-9a-zA-Z]**/

var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
var1   [a-zA-Z][0-9a-zA-Z]*("->"|".")?[0-9a-zA-Z]+

	/*en cas d'initialisation*/
nbr [0-9]+|[0-9]*\.[0-9]+



		
%%


"#include".+ {
			 	if (include==0)
			 	{ 
					fputs("#include <pthreads.h>\n", fichier);	
					fputs("#include <inttypes.h>\n",fichier);
					fputs("#include \"mythreads.h\"\n",fichier);	
					include++;			
				}
				fprintf(fichier, "%s \n", yytext);
			}

	/*declaration variable*/
{var}" "+{var}" "*(","" "*{var}" "*)*";" { 
	/*celle des fonctions*/
	if(inMain==0)
		fprintf(fichier1, "%s \t", yytext);
	/*celle du main*/
	else{
		if(fait==0){
			fputs("\n\ntypedef struct Data Data;\n struct Data\n {\n",fichier);
			fait=1;
			} 
		fprintf(fichier, "\t%s\n", yytext);
	}
}
		
	/*declaration et initialisation de variable*/
{var}" "+{var}" "*"="" "*{nbr}" "*";" { 
	if(inMain==1){
		fputs("\t", fichier);
		int v = strlen(yytext);
		char ligne[v];
		int i;
		strcpy(ligne,&yytext[0]);
		for(i=0;i<v;i++){
			if(ligne[i] == '=') break;
			fputc(ligne[i], fichier);
		}		
		fputs(";\n", fichier);	
		fprintf(fichier1, "\n%s", yytext);	
	}
	else
		fprintf(fichier1, "%s\t", yytext);	
}


	/*position du return du main*/

" "*"return".+"\n" {
	/*afin de savoir si nous avons atteint le main ou non ce qui nous servira 
	plus tard lors du  compte du nbrsde fcts*/
	if(inMain==1) { 
		/*fputs("\tThreadPool *pool;\n", fichier);
		fputs("};\n\n", fichier);*//*afin de fermer la declaration de la structure*/
		fprintf(fichier1, "%s\n", yytext);	
	}
}
	
" "*"//#".+? { 
		if(inMain==1){
			int v = strlen(yytext),i,position,j=0;
			char ligne[v];	
			strcpy(ligne,&yytext[0]);
			char chaine[100] = "";			
			char output[100]= ""; 
			for(i=0;i<v;i++){
				if(ligne[i]=='#') break;
				position=i+2;
				}

			for(i=position;i<v;i++){
				output[j]=ligne[i];
				j++;
				}
        	fprintf(fichier2, "%s ", output);
        	fprintf(fichier2, "%s", fgets(chaine, 100, fichier3)); // On affiche la chaîne qu'on vient de lire	
		}	
	}	
	/*appele de fonction et de procedure*/
{var}" "*"("" "*(({var1}|{var})" "*(","" "*({var1}|{var})" "*)*)*")"" "*";" { }
({var1}|{var})" "*"+"?"-"?"*"?"/"?"="" "*{var}" "*"("" "*(({var1}|{var})" "*(","" "*({var1}|{var})" "*)*)*")"" "*";" { }

	/*pour ne pas prendre en compte les appele sous-commantaire*/
"//".+ {}
"/*".+"\n"*"*/" {}	

	/*declaration de fonction et de procedure*/	
{var}" "+{var}" "*"(".+ {
		int v = strlen(yytext);
		int position=0;
		char ligne[v];
		strcpy(ligne,&yytext[0]);	
	    char *p = strstr(ligne, "main");
	    if (p != NULL)
	    {
			inMain=1;    
	    }
	    fprintf(fichier1, "\n%s { ",yytext);
	
}


	/*transformer les saut de ligne en simple tabulation*/
.+";" {	fprintf(fichier1, "%s \t", yytext);}  


"\n" { } 

. { }   
     
%%    
int main(){		

fichier = fopen("sebiss.c", "w+"); 
fichier1 = fopen("sebiss1.txt", "w+"); 
fichier2 = fopen("pp.txt", "w+");
fichier3 = fopen("teste.txt", "r+");
if (fichier != NULL)
{    
	yylex();
	fclose(fichier);
}
else
	printf("Impossible d'ouvrir le fichier sebiss.c\n");
if(fichier1 != NULL)
   {	
	yylex();
	fclose(fichier1);
}
else	
	printf("Impossible d'ouvrir le fichier sebiss1.c\n");

if (fichier3 != NULL)
    {	
			if (fichier2!= NULL)
		    {	
		    	yylex();
				fclose(fichier2);
			}
			else
				printf("Impossible d'ouvrir le fichier pp.txt\n");
	fclose(fichier3);
	}
else
	printf("Impossible d'ouvrir le fichier teste.txt\n");
	
return EXIT_SUCCESS;
}
