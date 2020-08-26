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
flex v2_presentation.l
gcc lex.yy.c -ll
./a.out < teste.c

flex trad.l
gcc lex.yy.c -ll
./a.out < seq.c 
#le fichier obtenu sont sebiss.c et sebiss1.c et pp.txt

#pp.txt est vide actuellement je ne sais pk

#la je suis cence ecrire la cmd pour executer le fichier v.c qui s'execute sur pp.txt
gcc v.c -o v
./v
#obtentoinde extra.txt et td.dot

flex trad1.l
gcc lex.yy.c -ll
./a.out < extra.txt 

#pas touche se qu'il y a en haut
flex trad2.l
gcc lex.yy.c -ll
./a.out < sebiss1.c
./a.out < extra.txt

flex trad3.l
gcc lex.yy.c -ll
./a.out < extra.txt 

#supprimer lesfichier en trop
#rm sebiss1.c