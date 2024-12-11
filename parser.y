%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern void yyerror(const char *s);

extern FILE *yyin;
extern FILE *yyout;
FILE *tokens_file;

int indentation_level = 0;
#define INDENTATION "    "

void print_indentation(int level)
{
    for(int i = 0; i < level; i++)
    {
        fprintf(yyout, INDENTATION);
    }
}
%}


%union {
    int intValue;
    double doubleValue;
    char str[200];
    char operator[3];
    char identifier[100];
}

%token VARIABLE_DECLARATION_KEYWORD

%token IF ELSE FOR WHILE DO

%token EMPTY

%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET

%token DOT COMMA

%token INCREMENT
%token DECREMENT

%token PLUS MINUS MULTIPLY DIVIDE MODULO

%token ASSIGN
%token <operator> COMPOUND_ASSIGN

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

%type <str> variable_declaration_statement separate_expression assignment_statement
%type <str> branch_statement if_syntax else_syntax else_if_syntax
%type <str> cycle_statement
%type <str> expression sign open_area close_area

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
    EMPTY { fprintf(yyout, "\n");}
    | variable_declaration_statement 
    | assignment_statement
    | branch_statement
    | cycle_statement
    | separate_expression 
    ;

variable_declaration_statement:
    VARIABLE_DECLARATION_KEYWORD IDENTIFIER ASSIGN expression { 
        print_indentation(indentation_level);
        fprintf(yyout, "%s = %s\n", $2, $4);
    }
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression {
        print_indentation(indentation_level);
        fprintf(yyout, "%s = %s\n", $1, $3);
    }
    | IDENTIFIER COMPOUND_ASSIGN expression {
        print_indentation(indentation_level);
        fprintf(yyout, "%s %s %s\n", $1, $2 ,$3);
    }
    ;

branch_statement:
    if_syntax
    | else_syntax
    | else_if_syntax
    ;

if_syntax:
    IF LPAREN expression RPAREN open_area {
        print_indentation(indentation_level - 1);
        fprintf(yyout, "if (%s):\n", $3);
    }
    | IF LPAREN expression RPAREN {
        print_indentation(indentation_level);
        fprintf(yyout, "if (%s):", $3);
    }
    ;

else_syntax:
    ELSE open_area {
        print_indentation(indentation_level - 1);
        fprintf(yyout, "else:\n");
    }
    | ELSE {
        print_indentation(indentation_level);
        fprintf(yyout, "else:");
    }
    ;

else_if_syntax:
    ELSE IF LPAREN expression RPAREN open_area {
        print_indentation(indentation_level - 1);
        fprintf(yyout, "elif (%s):\n", $4);
    }
    | ELSE IF LPAREN expression RPAREN {
        print_indentation(indentation_level);
        fprintf(yyout, "elif (%s):", $4);
    }
    ;

cycle_statement:
    WHILE LPAREN expression RPAREN open_area {
        print_indentation(indentation_level - 1);
        fprintf(yyout, "while (%s):\n", $3);
    }
    | WHILE LPAREN expression RPAREN {
        print_indentation(indentation_level);
        fprintf(yyout, "while (%s):", $3);
    }
    ;

separate_expression:
    expression {
        if(strlen($$) != 0)
        {
            print_indentation(indentation_level);
            fprintf(yyout, "%s\n", $1);
        }
    }
    ;

expression:
    IDENTIFIER { sprintf($$, "%s", $1);}
    | STRING_LITERAL { sprintf($$, "%s", $1); }
    | INT_NUMBER { sprintf($$, "%d", $1); }
    | DOUBLE_NUMBER { sprintf($$, "%lf", $1); }
    | expression sign expression { sprintf($$, "%s %s %s", $1, $2, $3);}
    | LPAREN expression RPAREN {sprintf($$, "(%s)", $2);}
    | INCREMENT IDENTIFIER {sprintf($$, "%s += 1", $2);}
    | IDENTIFIER INCREMENT {sprintf($$, "%s += 1", $1);}
    | DECREMENT IDENTIFIER {sprintf($$, "%s -= 1", $2);}
    | IDENTIFIER DECREMENT {sprintf($$, "%s -= 1", $1);}
    | open_area
    | close_area
    ;

sign:
    PLUS {sprintf($$, "+");}
    | MINUS {sprintf($$, "-");}
    | MULTIPLY {sprintf($$, "*");}
    | DIVIDE {sprintf($$, "/");}
    | GREATER {sprintf($$, ">");}
    | GREATER_EQUAL {sprintf($$, ">=");}
    | LESS {sprintf($$, "<");}
    | LESS_EQUAL {sprintf($$, "<=");}
    | EQUAL {sprintf($$, "==");}
    | STRICT_EQUAL {sprintf($$, "==");}
    | NOT_EQUAL {sprintf($$, "!=");}
    | STRICT_NOT_EQUAL {sprintf($$, "!=");}
    ;

open_area:
    LBRACE {
        indentation_level++;
        sprintf($$, "");
    }
    ;
close_area:
    RBRACE {
        indentation_level--;
        sprintf($$, "");
    }
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
