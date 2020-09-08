#!/bin/sh

# le grof
rm s1
gcc -Wall -pg s1.c  -o s1
./s1
gprof s1 gmon.out > profile_data.txt
#obtention du temps d'execution 


flex Final3.l
gcc lex.yy.c -ll
./a.out < profile_data.txt
#obtention de teste.txt
rm ./a.out

flex trad.l
gcc lex.yy.c -ll
./a.out < s1.c 
#le fichier obtenu sont sebiss.txt et sebiss1.txt et pp.txt et in.txt
rm ./a.out

gcc v.c -o v
./v
#obtentoinde extra.txt et td.dot et out.txt

flex trad1.l
gcc lex.yy.c -ll
./a.out < extra.txt 
rm ./a.out
rm tmp.txt

#pas touche se qu'il y a en haut
flex tard2_2.l
gcc lex.yy.c -ll
./a.out < sebiss1.txt
rm ./a.out

flex trad3.l
gcc lex.yy.c -ll
./a.out < extra.txt 

#affiche le dag
xdot td.dot

gcc sebiss.c mythreads.c -lpthread -o p4 -lm
./p4

#supprimer lesfichier en trop
#rm sebiss1.txt
#rm sebiss2.txt
#rm extra.txt
#rm pp.txt
#rm in.txt
#rm out.txt
#rm teste.txt
rm ./a.out
