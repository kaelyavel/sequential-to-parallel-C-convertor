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
int inMain=0;
%}

var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
nbr    [0-9]+
type "int"|"char"|"long"|"float"|"double"|"uint64_t"

%%

"d1.nbr_for_"{var}" = "{nbr}";"  { fprintf(fichier, "\t%s\n",yytext );
								}

	/*{var}" "+{var}" "*"="" "*{nbr}" "*";" {*/ 
({var}|{type})" "+{var}" "*"=".+";" { 
	if(inMain==1){
		int v = strlen(yytext);
		char ligne[v];
		int i,position=0;
		strcpy(ligne,&yytext[0]);
		for(i=0;i<v;i++){
			if(ligne[i] == ' ') break;
			position++;
		}
		fputs("\td1.", fichier);
		for(i=position+1;i<v;i++){
			if(ligne[i] == ';') break;
			fputc(ligne[i], fichier);
		}		
		fputs(";\n", fichier);	
	}
}
	/*declaration de la fonction*/
({var}|{type})" "+{var}" "*"(".+ {	
		int v = strlen(yytext);
		char ligne[v];
		strcpy(ligne,&yytext[0]);
		char nomfct[20],par[20],nom[20];
		memset (nomfct, 0, sizeof (nomfct));
		memset (par, 0, sizeof (par));
		strcpy(ligne,&yytext[0]);
		int i,position,count=0,j=0,existe=0;

		//extraction du nom fct para.c
		for(i=0;i<v;i++){
					if(ligne[i]==' ') 	break;
					count++;	
				}			
		for(i=count;i<v;i++) {
			if(ligne[i] == '(') {
					position=i+1; 
					break;
					}
					if(ligne[i] == ' ')  continue;
					nomfct[j]=ligne[i];
					j++;					
				}
		//afain de savoir si cette fct est appler dans le main ou non		
		fseek(fichier5, 0, SEEK_SET);
		while (fgets(par,20, fichier5) != NULL){
			j=0;
			//nom est la variable qui contiendra le nom de inter.txt
			memset (nom, 0, sizeof (nom));
			for(i=0;i<v;i++){
					if(par[i]==' ') break;
					nom[j]=par[i];
					j++;	
				}
			existe=strcmp(nom,nomfct);

			if( existe==0 ) break;		
		}
	    char *p = strstr(ligne, "main");
	    //si nous sommes dans le main
	    if (p != NULL)
	    {	 
	    	fprintf(fichier, "\n%s ",yytext);
	    	fputs("\n",fichier);
			fputs("\tData d1;\n\t",fichier);
			inMain=1;  	
	    }
	    //si il n'est pas appeler dans le main
	    else if( existe!=0 )
	    {
	    	fprintf(fichier, "\n%s\n} \n\n ",yytext);
	    }
	    //la fct appleller dans le main
	    else{
	    	fputs("void ", fichier);	
			char chaine[20],nomfct1[20];
			char para[30],par[20];
			memset (para, 0, sizeof (para));
			memset (chaine, 0, sizeof (chaine));
			memset (nomfct1, 0, sizeof (nomfct1));		
			int k,m=0,
			ok=0,fait=0,
			fait1=0,nbr,count1,
			fait2=0,fin=0, debut=0;
			
			fprintf(fichier, "%s",nomfct );
	
			fputs(" (void * d )\t\n", fichier);
				/*code qui ne chanhe pas*/
			fputs("\t{\n", fichier);
			fputs("\tData *dd =  d; \n", fichier);	

				/*traitement du contenu de la fonction*/
			

			//debut du maping avec le fichier in
			j=0;
			//le tri de la chaine para 
			for(i=position;i<v;i++) {
					if(ligne[i] == ')') {
		                count=i+1;
		                para[j]=',';
		                para[j+1]=ligne[i];
		                break;
		            }
		        para[j]=ligne[i];
		        j++;    
		    } 
		    int taille = strlen(para)+1;    
		    m=0;				
		    fseek(fichier4, 0, SEEK_SET); 	
			while (fgets(chaine,20, fichier4) != NULL) // On lit le fichier tant qu'on ne reçoit pas d'erreur (NULL)
       			{
       				j=0;
       				count1=0;
       				memset (nomfct1, 0, sizeof (nomfct1));
					for(i=0;i<20;i++) {
						if(chaine[i] == ':')  { 
							count1=i+1; 
							break;
						}
		            	nomfct1[j]=chaine[i];
		            	j++;
					}
					if(strcmp(nomfct,nomfct1) == 0)
					{
						//le reste du traitement
	       				for(i=count1;i<20;i++){
							if(chaine[i] == ':')  { 
								count1=i+1; 
								break;
							}
						}
						j=0;
						fait2=0;
						fin=0;
						debut=count1;
						for(i=0;i<taille;i++){
							if(para[i]==')') break;
							if(para[i]==',') {
								fputs("=",fichier);
								for(j=debut;j<v;j++){
									if(fait2==0) {
										fputs("dd->",fichier);
										fait2=1;
									}
								//if(chaine[j]==' ') {break;}
								if(chaine[j]==',') {
									debut=j+1;
									fait2=0;
									fputs(";\n",fichier);
									break;
									}
								fputc(chaine[j],fichier);
								}
							continue;
						}
						fputc(para[i],fichier);
					}
       			}
			}
		   
		    //tu arrete les changement ici

			//traitement des outputs
			fseek(fichier3,0,SEEK_SET);
			memset (chaine, 0, sizeof (chaine));
			fgets(chaine,20, fichier3) ;
			
				p = strstr(ligne, "return");
				//en cas de fct
				//y a un return 
				//C'EST FINIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIii
				if(p != NULL){
					position=p-ligne;
					//réecriture du corp de la fct
					fait2=0;
					debut=0;
					fin=0;
					//calcule de la  taille exacte
					for(i=count;i<v;i++)
					{
						if(ligne[i] == '{') {
							debut=i+1;
							break;
						}
					}
					for(i=v;i>count;i--)
					{
							if(ligne[i] == '}'){ 
								fin=i;
								break;
							}
					}
					for(i=debut;i<position;i++)
					{
						fputc(ligne[i],fichier);
					}
					//fin de la réecriture
					while (fgets(chaine,20, fichier3) != NULL) {
						j=0;
       					count1=0;
       					memset (nomfct1, 0, sizeof (nomfct1));
						for(i=0;i<20;i++) {
							if(chaine[i] == ':')  { 
								count1=i+1; 
								break;
								}
			            	nomfct1[j]=chaine[i];
			            	j++;
						}
						if(strcmp(nomfct,nomfct1) == 0)
						{
							fputs("\n\tdd->",fichier);
							for(i=count1;i<20;i++){
								if(chaine[i]==',') break;
								fprintf(fichier, "%c",chaine[i] );
							}
							fputs(" = ",fichier);
							for(i=position+6;i<v;i++){
								if(ligne[i]==';') break;
								if(ligne[i]=='(') continue;
								if(ligne[i]==')') continue;
								fprintf(fichier, "%c",ligne[i] );
							}
							fputs(";",fichier);
						}
					}
				}
				//en cas de procedure 
				else{
					fait2=0;
					debut=0;
					fin=0;
					//calcule de la  taille exacte
					for(i=count;i<v;i++)
					{
						if(ligne[i] == '{') {
							debut=i+1;
							break;
						}
					}
					for(i=v;i>count;i--)
					{
							if(ligne[i] == '}'){ 
								fin=i;
								break;
							}
					}
					for(i=debut;i<fin;i++)
					{
						fputc(ligne[i],fichier);
					}
				}
			//fin du maping
			memset (chaine, 0, sizeof (chaine));
			
			//ecriture du notifier
			fseek(fichier1, 0, SEEK_SET); 	
			 while (fgets(chaine,20, fichier1) != NULL) // On lit le fichier tant qu'on ne reçoit pas d'erreur (NULL)
       			{
            		j=0;
            		memset (nomfct1, 0, sizeof (nomfct1));
					for(i=0;i<20;i++) 
					{
						if(chaine[i] == ':')  { position=i+1; break;}
		            	nomfct1[j]=chaine[i];
		            	j++;
					}
					
					if(strcmp(nomfct,nomfct1) == 0){
						if(fait1==0) {
							//fputs("\n\tpthread_mutex_lock (&dd->mutex_pile); \n\tpthread_cond_wait (&dd->cond_pile);\n",fichier);
							fait1=1;
						}
						//fprintf(fichier, "\tnotifier(\"%s\", d); \n",nomfct1);
						fputs("\n\tnotifier(\"",fichier);
						for(i=position;i<30;i++){
							if(chaine[i] == '/')  break;
							if(chaine[i] == ' ')  continue;
							fputc(chaine[i],fichier);
						}
						fputs("\" , d); \n",fichier);
						fait=1;
					}	        		
        		}
        	if(fait==1){
				//fputs("\tpthread_cond_signal (&dd->cond_pile);\n\tpthread_mutex_unlock (&dd->mutex_pile);\n}\n\n", fichier);	
				fputs("}\n",fichier);
				fait=0;
				}
			else
				fputs("\n}\n",fichier);	

		} 
	}
	

.+"return".+ {
	if(inMain==1) { 		
		fprintf(fichier2, "%s\n",yytext );
	}
}
"\n" { }



. { }
%%    
int main(){		
fichier = fopen("para.c", "a+");
fichier2 = fopen("extra.txt", "a+"); 
fichier1 = fopen("para02.txt", "a+");
fichier3 = fopen("out.txt", "a+");
fichier4 = fopen("in.txt", "a+");
fichier5 = fopen("inter.txt", "a+");
if(fichier5!=NULL)
	{
	if(fichier4!= NULL)
	{
		if(fichier3!= NULL)
		{
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
				printf("Impossible d'ouvrir le fichier sebiss2.txt");
		fclose(fichier3);
		}
		else
			printf("Impossible d'ouvrir le fichier out.txt");
	fclose(fichier4);
	}
else
	printf("Impossible d'ouvrir le fichier in.txt");
	fclose(fichier5);
}
else
	printf("Impossible d'ouvrir le fichier inter.txt");

if (fichier1 != NULL)
    {	
	yylex();
	fclose(fichier1);
	}
else
	printf("Impossible d'ouvrir le fichier extra.txt");
return EXIT_SUCCESS;
}
