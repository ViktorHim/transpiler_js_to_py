
ALL:
	bison -d parser.y
	flex lexer.l
	gcc  -o transpiler lex.yy.c parser.tab.c
	./transpiler test.js output.py tokens.txt

