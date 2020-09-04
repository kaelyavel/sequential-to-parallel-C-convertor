#!/bin/sh

# le grof
gcc -Wall -pg seq.c  -o seq
./seq
gprof seq gmon.out > profile_data.txt
#obtention du temps d'execution 


flex Final3.l
gcc lex.yy.c -ll
./a.out < profile_data.txt
#obtention de teste.txt


flex trad.l
gcc lex.yy.c -ll
./a.out < seq.c 
#le fichier obtenu sont sebiss.txt et sebiss1.txt et pp.txt et in.txt



gcc v.c -o v
./v
#obtentoinde extra.txt et td.dot et out.txt

flex trad1.l
gcc lex.yy.c -ll
./a.out < extra.txt 

#pas touche se qu'il y a en haut
flex tard2_2.l
gcc lex.yy.c -ll
./a.out < sebiss1.txt

flex trad3.l
gcc lex.yy.c -ll
./a.out < extra.txt 

#supprimer lesfichier en trop
#rm sebiss1.c