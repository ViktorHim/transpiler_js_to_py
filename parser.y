%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern void yyerror(const char *s);

extern FILE *yyin;
FILE *output_file;
FILE *tokens_file;

%}

%union {
    double number;
    char *str;
    char *identifier;
}

%token LET
%token CONST
%token IF
%token ELSE
%token FOR
%token WHILE
%token DO
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET
%token SEMICOLON
%token DOT
%token COMMA
%token INCREMENT
%token DECREMENT
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token MODULO
%token ASSIGN
%token PLUS_ASSIGN
%token MINUS_ASSIGN
%token MULTIPLY_ASSIGN
%token DIVIDE_ASSIGN
%token GREATER
%token LESS
%token GREATER_EQUAL
%token LESS_EQUAL
%token EQUAL
%token STRICT_EQUAL
%token NOT_EQUAL
%token STRICT_NOT_EQUAL

%token <identifier> IDENTIFIER
%token <str> STRING_LITERAL
%token <number> NUMBER

%start program

%%
program:

%%

int main(int argc, char **argv) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s <input_js_file> <output_python_file> <tokens_file>\n", argv[0]);
        return 1;
    }

    // Открытие входного файла
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Failed to open input file");
        return 1;
    }

    // Открытие выходного файла для Python
    output_file = fopen(argv[2], "w");
    if (!output_file) {
        perror("Failed to open output file");
        fclose(yyin);
        return 1;
    }

    // Открытие файла токенов
    tokens_file = fopen(argv[3], "w");
    if (!tokens_file) {
        perror("Failed to open tokens file");
        fclose(yyin);
        fclose(output_file);
        return 1;
    }

    // Запуск парсера (он вызовет лексер)
    yyparse();

    // Закрытие файлов
    fclose(yyin);
    fclose(output_file);
    fclose(tokens_file);

    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
