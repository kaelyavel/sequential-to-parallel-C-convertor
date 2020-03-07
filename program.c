#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//toint
//tostring

//Génère un fichier contenant les dépendances

struct variable {
	char v[10]; //Variable peut contenir jusqu'à 10 caractères

};

struct module {

	char func[60];
	struct variable v_in[20]; // 20 input et dans chacun une variable de 10 character
	int n_v_in;
	struct variable v_out[20]; // 20 output
	int n_v_out;
};

struct etage {

	struct module m[20];

};

struct graphe {

struct etage e[10];

};




int main () 
{ 

	int line = 0;
	int l,n,i = 0; //number of variables in input;
	struct module modules[20];
	char c;
	char word[60];
	char word1[60];
	FILE *f;
	f = fopen("/home/refl/Desktop/profile.txt","r");


	strcpy(word, "");

	strcpy(word1, "");
	int count = 0;
	strcpy(modules[line].func, "");


	while((c = fgetc(f)) != EOF)
	{ //get name
		if(c == ' ')
		{
			if(count == 1) 
				{
							//printf("%s\n", word);

							strcpy(modules[line].v_in[n].v,word);
							modules[line].n_v_in = n + 1; //total number of variables
							strcpy(word, "");
							l=0; //new variable -> renew letter counter
							n=0; //new variable
							//printf("%d\n",n);
							
				}
			
			
			//modules[line].func = word;
			switch(count){

				case 0 : strcpy(modules[line].func, "");
						 strcpy(modules[line].func, word);
						 printf("%s",word);
						 printf("%s\n",modules[line].func);
						 break; //printf("%s",modules[line].func); 
				case 1 : for(i=0;i<modules[line].n_v_in;i++){
							
							printf("%s \n",modules[line].v_in[i].v);
							
							} printf("%d\n", modules[line].n_v_in);  break;
			}
			

			++count;
			strcpy(word, "");
			if(count ==2 ) //possibility of avoiding this check statement
			{	

				continue;
			}

		}

		else

		{	
			if(count == 0)
			{
				if(line == 1)
				{
					printf("entered\n");
					strcat(word1, &c); 
					printf("%s\n",word1);

				}
				else
				{
					strcat(word, &c); 
					printf("%s",word);
				}
				
			}
			

			if(count == 1)
			{
				if(c == '0')
				{
					//No variables in input

				}

				else
				
				{

					if(c != ',' && !(c == ' '))
					{	//There are variables in input
						strcat(word, &c);
						//printf("%s\n", word);
						//printf("Lu %c\n", c);
						
						//word += c;
						//p
						//printf("%s\n", word);
						l++; //means new variable letter
					}

					else
					
					{	
						
							//printf("%s\n", word);
							strcpy(modules[line].v_in[n].v,word);
							strcpy(word, "");
							l=0; //new variable -> renew letter counter
							n++; //new variable
							//printf("%d\n",n);
						
						
						
					}

				
				
				}
			} 
			
			if(count == 2 && !(c == '\n'))
			{ //count = 2
				//printf("Entering count 2\n");
				//printf("%c\n",c);
				if(c == '0')
				{

				}
				else
				{
					if(c != ',')
					{	//There are variables in input
						strcat(word, &c);
						//printf("%s\n", word);
						//printf("Lu %c\n", c);
						
						//word += c;
						//p
						//printf("%s\n", word);
						l++; //means new variable letter
					}
					else
					{	
						
							//printf("%s\n", word);
							strcpy(modules[line].v_out[n].v,word);
							strcpy(word, "");
							l=0; //new variable -> renew letter counter
							n++; //new variable
							//printf("%d\n",n);
						
						
						
					}
				}

				

				

			} 
		}

		if(c == '\n')
		{
			if(count == 2)
				{
							//printf("In\n");
							//Getting last output
							//printf("%s\n", word);
							strcpy(modules[line].v_out[n].v,word);
							modules[line].n_v_out = n + 1; //total number of variables
							strcpy(word, "");
							l=0; //new variable -> renew letter counter
							n=0; //last variable, puts back to zero
							//printf("%d\n",n);

							for(i=0;i<modules[line].n_v_out;i++){
							
							printf("%s \n",modules[line].v_out[i].v);
							
							} printf("%d\n", modules[line].n_v_out);


							//Going to new line
							
							//Restet the count to zero, as its concerns the number of parts of a line
							
							
							
							line++;
							count = 0;
							strcpy(word, "");

							

				}

			
		}
		
	}

	printf("out of file\n");

	
	
	//printf("%d",count);
	fclose(f);
	return 0;
}
