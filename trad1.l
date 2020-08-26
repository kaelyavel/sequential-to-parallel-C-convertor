%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
#include<ctype.h>
FILE* fichier=NULL;
FILE* fichier1=NULL;
FILE* fichier2=NULL; 
int inMain=0,fait=0;
%}

var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
nbr    [0-9]+

%%


"int nbr_for_"{var}";" {
	fprintf(fichier, "\t%s\n",yytext );
}


{var}": notifier(\""{var}"\" , d);" {
	int v = strlen(yytext);
	char ligne[v];	
	char chaine[v];	
	strcpy(chaine,&yytext[0]);
	char nomFCT[v],nomFCT1[v];
	nomFCT[v]=' ';
	ligne[v]=' ';		
	int i,count=0,j=0,same=0,position;
	
	/*retour au debut du fichier 1 qui est sebiss1.c*/
	fseek(fichier1, 0, SEEK_SET);

	fgets(ligne,1000, fichier1);
	
	while (fgets(ligne,1000, fichier1) != NULL) // On lit le fichier tant qu'on ne reçoit pas d'erreur (NULL)
       	{
       				count=0;
       				j=0;
       				position=0;
       				nomFCT[v]=' ';
       				for(i=0;i<v;i++){
							if(ligne[i]==' ') 	break;
							count++;	
						}
       				for(i=count;i<v;i++) {
						if(ligne[i] == '(')  break;
						if(ligne[i] == ' ')  continue;
						    nomFCT[j]=ligne[i];	
						if(chaine[j] == ':')  break;
		            		nomFCT1[j]=chaine[j];
		            	if(nomFCT[j] != nomFCT1[j]) same=1;
							j++;
						}
					j=0;
					if(same == 0){	
					char *output = strtok(ligne, "\n");					
						strcat(output,chaine);
						fprintf(fichier2, "%s \n", output);
						//fprintf(fichier2, "%s ",chaine);
					}	
					//fprintf(fichier2, "%s ", ligne);
        }    
	fprintf(fichier1, "%s\n ",yytext);
	/*while (fgets(ligne,1000, fichier1) != NULL) // On lit le fichier tant qu'on ne reçoit pas d'erreur (NULL)
       	{ 
       		fprintf(fichier2, "ch3r", ligne);
   		}*/
	//fprintf(fichier2, "%s\n ",yytext);
}


"\n" { } 
. { }
%%    
int main(){		
fichier = fopen("sebiss.c", "a+"); 
fichier1 = fopen("sebiss1.c", "a+");
fichier2 = fopen("sebiss2.c", "w+");
if (fichier != NULL)
    {	
	yylex();
	fputs("\tThreadPool *pool;\n", fichier);
	fputs("};\n\n", fichier);/*afin de fermer la declaration de la structure*/
	fclose(fichier);
	}
else
	printf("Impossible d'ouvrir le fichier sebiss.c");
if (fichier2 != NULL)
    {
		if (fichier1 != NULL)
		    {		
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
