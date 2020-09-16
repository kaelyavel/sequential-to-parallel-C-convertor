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
FILE* fichier5=NULL;
int include=0;
int inMain=0,fait=0,aPara=0;
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

	/*var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]**/
var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
var1   [a-zA-Z][0-9a-zA-Z]*("->"|".")?[0-9a-zA-Z]+
type "int"|"char"|"long"|"float"|"double"|"uint64_t"


	/*en cas d'initialisation*/
nbr [0-9]+|[0-9]*\.[0-9]+
	/*chr ("\""(" "*[0-9a-zA-Z]+)+"\"")|"\'"[0-9a-zA-Z]|" ""\'"*/


		
%%

"#"" "*"include".+ {
			 	if (include==0)
			 	{ 
					fputs("#include <pthread.h>\n", fichier);	
					fputs("#include <inttypes.h>\n",fichier);
					fputs("#include \"mythreads.h\"\n",fichier);	
					include++;			
				}
				fprintf(fichier, "%s \n", yytext);
			}

"#"" "*"define".+ {
			fprintf(fichier, "%s \n", yytext);
}

	/*declaration variable*/
({type}|{var})" "+{var}" "*(","" "*{var}" "*)*";" { 
	/*celle des fonctions*/
	if(inMain==0)
		fprintf(fichier1, "%s \t", yytext);
	/*celle du main*/
	else{
		if(fait==0){
			fputs("\n\ntypedef struct \n {\n",fichier);
			fait=1;
			} 
		fprintf(fichier, "\t%s\n", yytext);
	}
}
		
	/*declaration et initialisation de variable*/
	/*{type}" "+{var}" "*"="" "*({nbr}|{var}|{chr})" "*";" {*/
{type}" "+{var}" "*"=".+";" {	 
	if(inMain==1){
		if(fait==0){
			fputs("\n\ntypedef struct \n {\n",fichier);
			fait=1;
			} 
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
		fprintf(fichier1, "\n%s\t", yytext);

	}
	else{
		
		fprintf(fichier1, "%s\t", yytext);	
	}
}
	/*position du return du main*/

" "*"return".+ {
	
	fprintf(fichier1, "%s", yytext);
}
	
" "*"//#".+? { 
		if(inMain==1){
			int v = strlen(yytext),i,position,j=0;
			char ligne[v],nomfct[50],nomfct1[50];	
			strcpy(ligne,&yytext[0]);
			memset (nomfct, 0, sizeof (nomfct));

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
			j=0;
			for(i=position;i<v;i++){
				if(ligne[i]==' ') break;
				nomfct[j]=ligne[i];
				j++;
				}
			aPara=1;
        	fseek(fichier3,0,SEEK_SET);
        	//extraction du temps d'execution de chaquefct
        	while(fgets(chaine, 100, fichier3)!=NULL){
        		memset (nomfct1, 0, sizeof (nomfct1));
        		j=0;
        		for(i=0;i<100;i++){
					if(chaine[i] == ' ') {position=i; break;}
						nomfct1[j]=chaine[i];
					j++;
				}
				int taille=strlen(chaine);
				if(strcmp(nomfct,nomfct1) == 0){
					fprintf(fichier2, "%s ",output);
					for(i=position+1;i<taille;i++){
						if(chaine[i] == ' ') break;
					fputc(chaine[i],fichier2);
					}
					fputs("\n",fichier2);
				}
        	}
		}	
	}


	/*pour ne pas prendre en compte les appele sous-commantaire*/
.+"//".+ { }
"/*".+"\n"*"*/" { }	
	/*appele de fonction et de procedure*/
	/*tu remplace aveccequ'il y a sur reparation.l*/
	/*procedure*/
{var}" "*"("" "*(({var1}|{var})" "*(","" "*({var1}|{var})" "*)*)*")"" "*";" {
	if(aPara==1){
		if(inMain==1){		
		/*extraction de la ligne et copie dans une varible tomporaire*/
		int v = strlen(yytext); 
		char ligne[v];		
		strcpy(ligne,&yytext[0]);		
		//input
		char nomfct[50];
		char phrase[50];
		memset (nomfct, 0, sizeof (nomfct));
		memset (phrase, 0, sizeof (phrase));

		int position=0,i,j=0,taille=0;
		for(i=0;i<v;i++) {
			if(ligne[i] == '(') break;
                	nomfct[j]=ligne[i];
                	j++;
                	position++;
		}

		
		for(i=position+1;i<v;i++){
			if(ligne[i]==')') break;
			if(ligne[i]== ' ') continue;
			if(taille==50) {
		    		printf("pas asser d'epace, priere de racourcir le nom de s variable en entres\n");
             					break; }
			phrase[taille++]=ligne[i];
		}
		taille=strlen(phrase);
		if(taille!=0){
			fprintf(fichier5, "%s:", nomfct);				
			fprintf(fichier5, "%s, \n", phrase);
		} 
	}			
	aPara=0;
	 }
	}
		/*fonction*/
({var1}|{var}|{type})" "*"+"?"-"?"*"?"/"?"="" "*{var}" "*"("" "*(({var1}|{var})" "*(","" "*({var1}|{var})" "*)*)*")"" "*";" { 
	if(aPara==1){
		if(inMain==1){		
		int v = strlen(yytext);
		char ligne[v];
		char phrase1[50];
		char nomfct[50];
		memset (phrase1, 0, sizeof (phrase1));
		memset (nomfct, 0, sizeof (nomfct));
		//copie juste de la premiere case de yytext		
		strcpy(ligne,&yytext[0]);

		//debut du traitement sur ligne
		int i,j=0,count=0,position=0,taille=0;
		for(i=0;i<v;i++) {
			if(ligne[i] == '=') break;
			if(ligne[i] == '/') break;
			if(ligne[i] == '*') break;
			if((ligne[i] == '-') &&(ligne[i+1] == '=')) break;
			if(ligne[i] == '+') break;
	         	count++;
		}
		//extraction du nom de fct

		for(i=count+1;i<v;i++) {
			if(ligne[i] == '(') break;
			if(ligne[i]==' ') continue;
                	nomfct[j]=ligne[i];
                	j++;
                	position=i;
		}
		for(i=position+2;i<v;i++){
			if(ligne[i]==')') break;
			//if(ligne[i]== ' ') continue;
			if(taille==50) {
		    		printf("pas asser d'epace, priere de racourcir le nom de s variable en entres\n");
             					break; 
             				}
			phrase1[taille++]=ligne[i];
		}
		taille=strlen(phrase1);
		if(taille !=0){
			fprintf(fichier5, "%s:",nomfct); 		
			fprintf(fichier5, "%s,\n",phrase1);
		} 	
	}
	aPara=0;
	 }
}

	

	/*declaration de fonction et de procedure*/	
({type}|{var})" "+{var}" "*"(".+ {
		int v = strlen(yytext);
		int position=0;
		char ligne[v];
		strcpy(ligne,&yytext[0]);	
	    char *p = strstr(ligne, "main");
	    if (p != NULL)
	    {
			inMain=1;    
	    }
	    fprintf(fichier1, "\n%s ",yytext);	
}

	/*transformer les saut de ligne en simple tabulation*/
.+ {fprintf(fichier1, "%s \t", yytext);
	}  


"\n" { } 

	/*. { } */  
     
%%    
int main(){		

fichier = fopen("para.c", "w+"); 
fichier1 = fopen("para01.txt", "w+"); 
fichier2 = fopen("inter.txt", "w+");
fichier3 = fopen("teste.txt", "r+");
fichier5 = fopen("in.txt", "w+");
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
if (fichier5 != NULL)
    {
if (fichier3 != NULL)
    {	
			if (fichier2!= NULL)
		    {	
		    	yylex();
				fclose(fichier2);
			}
			else
				printf("Impossible d'ouvrir le fichier inter.txt\n");
	fclose(fichier3);
	}
else
	printf("Impossible d'ouvrir le fichier teste.txt\n");
fclose(fichier5);
	}
else
	printf("Impossible d'ouvrir le fichier in.txt\n");
	
return EXIT_SUCCESS;

}
