%{
#include <stdlib.h>
#include<stdio.h>
#include<string.h>
#include<ctype.h>
FILE* fichier=NULL; 
int inMain=0,fait=0;
%}

var    [&]?[*]?[a-zA-Z][0-9a-zA-Z]*
nbr    [0-9]+

%%


"addJobToPool(pool, &"{var}", &d1);" {
	if(fait==0){
		fputs("int size,size2;\n",fichier);
		fputs("scanf(\"%d\",&size);\n",fichier);
		fputs("ThreadPool *pool = createPool(size);\n",fichier);
		fputs("d1.pool=pool;\n",fichier);
		fait=1;
	}
		fprintf(fichier, "%s\n",yytext );		
	}

"return".+ {
	fputs("printf(\"POL\");\n",fichier);
	fputs("scanf(\"%d\" , &size2);\n",fichier);
	fprintf(fichier, "%s\n}",yytext );
}


. {}

"\n" {} 
%%    
int main(){		
fichier = fopen("sebiss.c", "a+"); 
if (fichier != NULL)
    {	
	yylex();
	fclose(fichier);
	}
else
	printf("Impossible d'ouvrir le fichier sebiss.c");

return EXIT_SUCCESS;
}
