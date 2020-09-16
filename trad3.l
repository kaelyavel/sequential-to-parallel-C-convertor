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
		fputs("\tint size,size2;\n\tprintf(\"Introduisez le nombre de threads\\n \");\n\tscanf(\"%d\",&size);\n\tThreadPool *pool = createPool(size);\n\td1.pool=pool;\n",fichier);
		fait=1;
	}
		fprintf(fichier, "\t%s\n",yytext );		
	}

"return".+  {
	fputs("\tprintf(\"POL\");\n",fichier);
	fputs("\tscanf(\"%d\" , &size2);\n",fichier);
	fprintf(fichier, "\t%s\n",yytext );
}


. {}

"\n" {} 
%%    
int main(){		
fichier = fopen("para.c", "a+"); 
if (fichier != NULL)
    {	
	yylex();
	fclose(fichier);
	}
else
	printf("Impossible d'ouvrir le fichier sebiss.c");

return EXIT_SUCCESS;
}
