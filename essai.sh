#!/bin/sh

# le grof
gcc -Wall -pg B2.c  -o s1
./s1
gprof s1 gmon.out > profile_data.txt
#obtention du temps d'execution 

flex fct_time.l
gcc lex.yy.c -ll
./a.out < profile_data.txt
#obtention de teste.txt

flex trad.l
gcc lex.yy.c -ll
./a.out < B2.c 
#le fichier obtenu sont para01.c et para01.txt et pp.txt et in.txt

gcc v.c -o v 
./v
#obtentoinde extra.txt et td.dot et out.txt

flex trad1.l
gcc lex.yy.c -ll
./a.out < extra.txt 
rm ./a.out
rm tmp.txt

#pas touche se qu'il y a en haut
flex tard2.l
gcc lex.yy.c -ll
./a.out < para01.txt

flex trad3.l
gcc lex.yy.c -ll
./a.out < extra.txt 

#affiche le dag
#xdot td.dot &

#gcc para.c mythreads.c -lpthread -o p4 -lm
#./p4

#supprimer lesfichier en trop
rm lex.yy.c
rm profile_data.txt
rm gmon.out
rm para01.txt
rm para02.txt
rm extra.txt
rm inter.txt
rm v
rm in.txt
rm out.txt
rm teste.txt
rm ./a.out
