
ALL:
	clear
	bison -d parser.y
	flex lexer.l
	gcc  -o transpiler lex.yy.c parser.tab.c
	./transpiler cond.js output.py tokens.txt

