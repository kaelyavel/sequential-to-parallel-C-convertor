#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct variable {
	char v;
};

struct module {

	char func[20];
	struct variable v_in[20]; // 20 input
	struct variable v_out[20];  // 20 output
};


int main () 
{ 

	int line = 0;
	int n = 0; //number of variables in input;
	struct module modules[20];
	char c;
	char word[20];

	FILE *f;
	f = fopen("/home/refl/Desktop/profile.txt","r");



	int count = 0;
	while((c = fgetc(f)) != EOF)
	{ //get name
		if(c == ' ')
		{
			
			
			//modules[line].func = word;
			switch(count){

				case 0 : strcpy(modules[line].func, word); break;
				case 1 : 
			}
			

			++count;
			strcpy(word, "");
		}
		else
		{	//Append
			strncat(word, &c, 1); 

			if(count == 1)
			{
				if(c == "0")
				{
					//No variables in input

				}
				else
				{	//There are variables in input

					strcpy(modules[line].v_in[n],c);
					n++;
				}
				

			}
		}

		if(c == '\n')
		{
			line++;
			count++;
		}
		
	}

	
	printf("%d",count);
	fclose(f);
	return 0;
}