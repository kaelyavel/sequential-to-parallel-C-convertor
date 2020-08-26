 
%{
#include <stdlib.h>
#include<stdio.h>
#include<ctype.h>
FILE* fichier=NULL;
FILE* fichier1=NULL;

  
%}
         
CHIFFRE  [0-9]+|([0-9]+\.[0-9]*|\.[0-9]+) 
IDFCT    [a-zA-Z][0-9a-zA-Z]+ 
       
%%
 
({CHIFFRE}" "+{CHIFFRE}*)+{IDFCT}"\n" {
		/*extraction de la ligne et copie dans une varible tomporaire*/
		int v = strlen(yytext); 
		char ligne[v];
		char phrase[100];		
		strcpy(ligne,&yytext[0]);		
		int position=0,i,j=0,cpt=2;

		//elimine les espace
		for(i=0;i<v;i++) {
			//si ce n'est pas  un chiffre
			if(isdigit(ligne[i])==0) {
							//sauvgarde de la derniere position avant l'espace
							position=i;
							}
			if(ligne[i]== ' ') break;
		}		

		//elimine la prmeier colonne

		for(i=position;i<v;i++) {
			if(ligne[i]== ' ') continue;
			if(isdigit(ligne[i])!=0){
			position=i;
			break;
			}
			}

		//elimine les espaces
		for(i=position;i<v;i++){
			//phrase[j]=ligne[i]; j++;
			if(ligne[i]== ' '){position=i; break;}
		}

		//elimine la  2 case	
		for(i=position;i<v;i++) {
			if(ligne[i]== ' ') continue;
			if(isdigit(ligne[i])!=0){
			position=i;
			break;
			}
			}


			// a ne pas toucher
		//enregistre la trooisieme colonne
		for(i=position;i<v;i++){
			phrase[j]=ligne[i]; j++;
			if(ligne[i]== ' '){
				position=i;
				break;
			}
		}
		//fin
		
		fprintf(fichier, "%s\n", phrase);
	}


.+"seconds" {}
"\n" { } 
. {}
     
     
%%    
int main(){
int caractereActuel = 0;
int tMAX=100,vide=0,i,position,taille;
char chaine[100] = "";		
fichier = fopen("teste.txt", "w+"); 
if (fichier != NULL)
    {	
	yylex();
	fclose(fichier);
	}
else
	printf("Impossible d'ouvrir le fichier test.txt");


return EXIT_SUCCESS;
    }
