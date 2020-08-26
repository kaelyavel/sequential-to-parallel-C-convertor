%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
#include<ctype.h>
FILE* fichier=NULL;
FILE* fichier1=NULL;
FILE* fichier2=NULL; 
int inMain=0;
%}

var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
nbr    [0-9]+


%%
{var}" ""addJobToPool(".+ { }

"d1.nbr_for_"{var}" = "{nbr}";"  { fprintf(fichier, "%s\n",yytext );}

	/*declaration de la fonction*/

{var}" "+{var}" "*"(".+ {
		int v = strlen(yytext);
		char ligne[v];
		strcpy(ligne,&yytext[0]);	

	    
	    char *p = strstr(ligne, "main");
	    if (p != NULL)
	    {	 
	    	fprintf(fichier, "\n%s ",yytext);
	    	fputs("\n",fichier);
			fputs("Data d1;\n",fichier);
			inMain=1;  
			
	    }
	    else{
	    	fputs("void *", fichier);
			int v = strlen(yytext);
			char ligne[v];	
			char chaine[1000];	
			strcpy(ligne,&yytext[0]);	
			char nomFCT[v],nomFCT1[v];
			nomFCT[v]=' ';
			
			int i,count=0,j=0,position;
			for(i=0;i<v;i++){
					if(ligne[i]==' ') 	break;
					count++;	
				}		
				//extraction du nom fct
				for(i=count;i<v;i++) {
					if(ligne[i] == '(')  break;
					if(ligne[i] == ' ')  continue;
					
		            nomFCT[j]=ligne[i];	
					fputc(ligne[i],fichier);
					j++;
				}
				//ne plus toucherce qu'il y a en haut
				for(i=i;i<v;i++) {
					if(ligne[i] == '{') {
		                	position=i+1;
		                break;
		            }
				}	
				
				
			fputs(" (void * d )\t", fichier);
				/*code qui ne chanhe pas*/
			fputs("{\t", fichier);
			fputs("Data *dd =  d; \t", fichier);	

				/*traitement du contenu de la fonction*/

			for(i=position;i<v;i++){
		    	fprintf(fichier, "%c",ligne[i]);		    	
			}	
			 while (fgets(chaine,1000, fichier1) != NULL) // On lit le fichier tant qu'on ne reçoit pas d'erreur (NULL)
       			{
       				//fprintf(fichier, "%s",chaine);
            		//extraction du nom fct
					for(i=0;i<1000;i++) {
						if(ligne[i] == ' ')  break;
		            	nomFCT1[j]=chaine[i];
					}
					if(strcmp(nomFCT1,nomFCT) == 0){
						//fprintf(fichier, "%s",chaine);
					}	
            		//printf("%s", chaine); // On affiche la chaîne qu'on vient de lire
        		}
			fputs("}\n\n", fichier);			
		}
	}
	/*"d1.nbr_for_"{var}" = "{nbr}";" {
	fprintf(fichier, "%s\n",yytext );
	}*/

"return".+ {
	if(inMain==1) { 		
		fprintf(fichier2, "%s\n",yytext );
	}
}
"\n" { }

{var}" "+{var}" "*"="" "*{nbr}" "*";" { 
	if(inMain==1){
		int v = strlen(yytext);
		char ligne[v];
		int i,position=0;
		strcpy(ligne,&yytext[0]);
		for(i=0;i<v;i++){
			if(ligne[i] == ' ') break;
			position++;
		}
		fputs("d1.", fichier);
		for(i=position+1;i<v;i++){
			if(ligne[i] == ';') break;
			fputc(ligne[i], fichier);
		}		
		fputs(";\n", fichier);	
	}
}

. { }
%%    
int main(){		
fichier = fopen("sebiss.c", "a+");
fichier2 = fopen("extra.txt", "a+"); 
fichier1 = fopen("pp.txt", "w+");
if(fichier2!= NULL){
	if (fichier != NULL)
	    {	
		yylex();
		fclose(fichier);
		}
		

	else
		printf("Impossible d'ouvrir le fichier sebiss.c");
	yylex();
	fclose(fichier2);
}
else
	printf("Impossible d'ouvrir le fichier extra.txt");

if (fichier1 != NULL)
    {	
	yylex();
	fclose(fichier1);
	}
else
	printf("Impossible d'ouvrir le fichier extra.txt");



return EXIT_SUCCESS;
}
