#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

//toint
//tostring

//GC)nC(re un fichier contenant les dC)pendances

struct variable
{
  char v[10];			//Variable peut contenir jusqu'C  10 caractC(res

};

struct func
{

  char v[10];


};


struct module
{

  char func[60];
  struct variable v_in[20];	// 20 input et dans chacun une variable de 10 character
  int n_v_in;
  struct variable v_out[20];	// 20 output
  int n_v_out;
  struct func depnd[100];
};

struct etage
{

  struct module m[20];

};

struct graphe
{

  struct etage e[10];

};





int
main ()
{

  int line = 0;
  int l, n, i, j = 0;		//number of variables in input;
  struct module modules[20];
  char c;
  char word[60];
  char word1[60];
  int depend = 0;
  FILE *f, *ff;
  f = fopen ("profile.txt", "r");
  ff = fopen ("profile3.txt", "r+");


  strcpy (word, "");

  strcpy (word1, "");
  int count = 0;
  strcpy (modules[line].func, "");


  while ((c = fgetc (f)))
    {				//get name

      if (c == '\0')
	{
	  //printf("ENTERED");
	  continue;
	}
      if (c == ' ')
	{
	  //printf("Entered space");
	  if (count == 1)
	    {
	      //printf("%s\n", word);


	      strcpy (modules[line].v_in[n].v, word);
	      modules[line].n_v_in = n + 1;	//total number of variables
	      strcpy (word, "");
	      l = 0;		//new variable -> renew letter counter
	      n = 0;		//new variable
	      //printf("%d\n",n);

	    }


	  //modules[line].func = word;
	  switch (count)
	    {

	    case 0:
	      strcpy (modules[line].func, "");
	      strcpy (modules[line].func, word);
	      //printf("%s",word);
	      printf ("%s\n", modules[line].func);
	      break;		//printf("%s",modules[line].func); 
	    case 1:
	      printf ("DISPLAYING INPUT : \n");
	      for (i = 0; i < modules[line].n_v_in; i++)
		{

		  printf ("%s \n", modules[line].v_in[i].v);

		}
	      printf ("%d\n", modules[line].n_v_in);
	      printf ("END OF INPUT\n");
	      break;
	    }


	  count++;
	  printf ("%d\n", count);
	  strcpy (word, "");
	  if (count == 2)	//possibility of avoiding this check statement
	    {

	      continue;
	    }

	}

      else

	{
	  if (count == 0)
	    {
	      //printf("%d",count);
	      //printf("%c",c);
	      fprintf (ff, "%c", c);
	      strcat (word, &c);
	      //printf("%s",word);


	    }


	  if (count == 1)
	    {
	      if (c == '0')
		{
		  //No variables in input

		}

	      else

		{

		  if (c != ',' && !(c == ' '))
		    {		//There are variables in input
		      strcat (word, &c);
		      //printf("%s\n", word);
		      //printf("Lu %c\n", c);

		      //word += c;
		      //p
		      //printf("%s\n", word);
		      l++;	//means new variable letter
		    }

		  else

		    {

		      //printf("%s\n", word);
		      strcpy (modules[line].v_in[n].v, word);
		      strcpy (word, "");
		      l = 0;	//new variable -> renew letter counter
		      n++;	//new variable
		      //printf("%d\n",n);



		    }



		}
	    }

	  if (count == 2 && !(c == '\n'))
	    {			//count = 2
	      //printf("Entering count 2\n");
	      //printf("%c\n",c);
	      if (c == '0')
		{

		}
	      else
		{
		  if (c != ',')
		    {		//There are variables in input
		      strcat (word, &c);
		      //printf("%s\n", word);
		      //printf("Lu %c\n", c);

		      //word += c;
		      //p
		      //printf("%s\n", word);
		      l++;	//means new variable letter
		    }
		  else
		    {

		      //printf("%s\n", word);
		      strcpy (modules[line].v_out[n].v, word);
		      strcpy (word, "");
		      l = 0;	//new variable -> renew letter counter
		      n++;	//new variable
		      //printf("%d\n",n);

		      //c = fgetc(f);



		    }
		}





	    }
	}

      if (c == '\n' || c == EOF)


	{

	  //printf("Enetred jump");
	  if (count == 2)
	    {
	      //printf("In\n");
	      //Getting last output
	      //printf("%s\n", word);
	      strcpy (modules[line].v_out[n].v, word);
	      modules[line].n_v_out = n + 1;	//total number of variables
	      strcpy (word, "");
	      l = 0;		//new variable -> renew letter counter
	      n = 0;		//last variable, puts back to zero
	      //printf("%d\n",n);

	      printf ("DISPLAYING OUTPUT : \n");

	      for (i = 0; i < modules[line].n_v_out; i++)
		{

		  printf ("%s \n", modules[line].v_out[i].v);

		}
	      printf ("%d\n", modules[line].n_v_out);

	      printf ("END OF OUTPUT\n");

	      //Going to new line

	      //Restet the count to zero, as its concerns the number of parts of a line



	      line++;
	      count = 0;
	      word[0] = '\0';
	      //strcpy(&c, "");





	    }

	  if (c == EOF)
	    {

	      break;
	    }
	}

    }


  printf ("out of file\n");



  //printf("%d",count);
  fclose (f);
  fclose (ff);

/*
	for(i=0;i<line;i++)
	{
		for(k=0;k<line;k++)
		{
			if(i == k)
				continue;

			for(j=0;j<moudles[i].n_v_in;j++)

			{

				for(l=0;j<modules[j].n_v_out;l++)
				{
					if(strcmp(modules[i].v_in[n],modules[j].v_out[l]))
					{
						depend = 1;
						break;
					}
				}
				

			}

			if(depend) 
			{
				strcpy(modules[i].depend.v, modules[k].func);

			}

		}

	}
*/




  return 0;
}
