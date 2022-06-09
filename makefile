naja: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o naja

lex.yy.c: y.tab.c naja.l
	lex naja.l

y.tab.c: naja.y
	yacc -d naja.y

clean: 
	rm -rf lex.yy.c y.tab.c y.tab.h naja naja.dSYM
