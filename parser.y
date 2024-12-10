%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern void yyerror(const char *s);

extern FILE *yyin;
extern FILE *yyout;
FILE *tokens_file;

%}


%union {
    int intValue;
    double doubleValue;
    char str[100];
    char identifier[100];
}

%token VARIABLE_DECLARATION_KEYWORD

%token IF ELSE FOR WHILE DO

%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET

%token SEMICOLON DOT COMMA

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
%token <intValue> INT_NUMBER
%token <doubleValue> DOUBLE_NUMBER

%type <str> statement expression variable_declaration_statement 

%start program

%%
program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    variable_declaration_statement
    ;

variable_declaration_statement:
    VARIABLE_DECLARATION_KEYWORD IDENTIFIER ASSIGN expression SEMICOLON { 
        sprintf($$, "%s = %s\n", $2, $4);
        fprintf(yyout, "%s = %s\n", $2, $4);
    }
    | VARIABLE_DECLARATION_KEYWORD IDENTIFIER ASSIGN expression {
        sprintf($$, "%s = %s\n", $2, $4);
        fprintf(yyout, "%s = %s\n", $2, $4);
    }
    ;

expression:
    IDENTIFIER { sprintf($$, "%s", $1); }
    | INT_NUMBER { sprintf($$, "%d", $1); }
    | DOUBLE_NUMBER { sprintf($$, "%lf", $1); }
    ;

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
    yyout = fopen(argv[2], "w");
    if (!yyout) {
        perror("Failed to open output file");
        fclose(yyin);
        return 1;
    }

    // Открытие файла токенов
    tokens_file = fopen(argv[3], "w");
    if (!tokens_file) {
        perror("Failed to open tokens file");
        fclose(yyin);
        fclose(yyout);
        return 1;
    }

    // Запуск парсера (он вызовет лексер)
    yyparse();

    // Закрытие файлов
    fclose(yyin);
    fclose(yyout);
    fclose(tokens_file);

    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
