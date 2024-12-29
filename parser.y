%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern void yyerror(const char *s);

extern FILE *yyin;
extern FILE *yyout;
FILE *tokens_file;

#define INDENTATION "    "

int indentation_level = 0;

void print_indentation(int level)
{
    for(int i = 0; i < level; i++)
    {
        fprintf(yyout, INDENTATION);
    }
}

%}

%code requires {
    typedef struct  
    {
        char full [100];
        char id [100];
        char value [100];
    } Expr;
}


%union {
    int intValue;
    double doubleValue;
    int bool;
    char str[200];
    Expr expr;
    char identifier[100];
}

%token CONSOLE LOG

%token VARIABLE_DECLARATION_KEYWORD

%token IF ELSE FOR WHILE DO

%token EMPTY

%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET

%token DOT COMMA SEMICOLON

%token INCREMENT DECREMENT

%token PLUS MINUS MULTIPLY DIVIDE MODULO

%token OR AND NOT

%token ASSIGN

%token GREATER LESS GREATER_EQUAL LESS_EQUAL EQUAL STRICT_EQUAL NOT_EQUAL STRICT_NOT_EQUAL

%token <identifier> IDENTIFIER
%token <str> STRING_LITERAL
%token <str> COMPOUND_ASSIGN
%token <bool> BOOLEAN
%token <intValue> INT_NUMBER
%token <doubleValue> DOUBLE_NUMBER

%type <str> statement statement_optional_semicolon as_print vds_print expression_print log args
%type <str> branch_statement if_syntax else_syntax else_if_syntax
%type <str> cycle_statement while_syntax for_syntax
%type <str>  sign compare_sign open_area close_area
%type <expr> variable_declaration_statement assignment_statement expression

%start program

%%
program:
    statements
    ;

statements:
    statement_optional_semicolon 
    | statements statement_optional_semicolon
    ;

statement:
    vds_print
    | as_print
    | branch_statement
    | cycle_statement
    | expression_print
    | log
    | open_area
    | close_area
    ;

statement_optional_semicolon:
    statement SEMICOLON
    | statement
    ;

variable_declaration_statement:
    VARIABLE_DECLARATION_KEYWORD IDENTIFIER ASSIGN expression { 
        sprintf($$.full, "%s = %s", $2, $4.full);
        sprintf($$.id, "%s", $2);
        sprintf($$.value, "%s", $4.full);
    }
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression {
        sprintf($$.full, "%s = %s", $1, $3.full);
        sprintf($$.id, "%s", $1);
        sprintf($$.value, "%s", $3.full);
    }
    | IDENTIFIER COMPOUND_ASSIGN expression {
        sprintf($$.full, "%s %s %s", $1, $2 ,$3.full);
        sprintf($$.id, "%s", $1);
        sprintf($$.value, "%s", $3.full);
    }
    | INCREMENT IDENTIFIER {
        sprintf($$.full, "%s += 1", $2);
        sprintf($$.id, "%s", $2);
        sprintf($$.value, "1");
    }
    | IDENTIFIER INCREMENT {
        sprintf($$.full, "%s += 1", $1);
        sprintf($$.id, "%s", $1);
        sprintf($$.value, "1");
    }
    | DECREMENT IDENTIFIER {
        sprintf($$.full, "%s -= 1", $2);
        sprintf($$.id, "%s", $2);
        sprintf($$.value, "-1");
    }
    | IDENTIFIER DECREMENT {
        sprintf($$.full, "%s -= 1", $1);
        sprintf($$.id, "%s", $1);
        sprintf($$.value, "-1");
    }
    ;

vds_print:
    variable_declaration_statement {print_indentation(indentation_level); fprintf(yyout, "%s\n", $1.full);}
as_print:
    assignment_statement {print_indentation(indentation_level); fprintf(yyout, "%s\n", $1.full);}
expression_print:
    expression {print_indentation(indentation_level); fprintf(yyout, "%s\n", $1.full);}

branch_statement:
    if_syntax
    | else_syntax
    | else_if_syntax
    ;

if_syntax:
    IF LPAREN expression RPAREN open_area {
        print_indentation(indentation_level-1);
        fprintf(yyout, "if (%s):\n", $3.full);
    }
    | IF LPAREN expression RPAREN {
        print_indentation(indentation_level);
        sprintf($$, "if (%s):", $3.full);
    }
    ;

else_syntax:
    ELSE open_area {
        print_indentation(indentation_level-1);
        fprintf(yyout, "else:\n");
    }
    | ELSE {
        print_indentation(indentation_level);
        fprintf(yyout, "else:");
    }
    ;

else_if_syntax:
    ELSE IF LPAREN expression RPAREN open_area {
        print_indentation(indentation_level-1);
        fprintf(yyout, "elif (%s):\n", $4.full);
    }
    | ELSE IF LPAREN expression RPAREN {
        print_indentation(indentation_level);
        fprintf(yyout, "elif (%s):", $4.full);
    }
    ;

cycle_statement:
    while_syntax
    | for_syntax
    ;

while_syntax:
    WHILE LPAREN expression RPAREN open_area {
        print_indentation(indentation_level-1);
        fprintf(yyout, "while (%s):\n", $3.full);
    }
    | WHILE LPAREN expression RPAREN {
        print_indentation(indentation_level);
        fprintf(yyout, "while (%s):", $3.full);
    }
    ;

for_syntax:
    FOR LPAREN variable_declaration_statement SEMICOLON expression SEMICOLON assignment_statement RPAREN open_area {
        print_indentation(indentation_level-1);
        fprintf(yyout, "for %s in range(%s,%s,%s):\n", $3.id, $3.value, $5.value, $7.value);
    }
    | FOR LPAREN variable_declaration_statement SEMICOLON expression SEMICOLON assignment_statement RPAREN {
        print_indentation(indentation_level);
        fprintf(yyout, "for %s in range(%s,%s,%s): ", $3.id, $3.value, $5.value, $7.value);
    }

expression:
    IDENTIFIER {sprintf($$.full, "%s", $1);}
    | STRING_LITERAL {sprintf($$.full, "%s", $1);}
    | INT_NUMBER {sprintf($$.full, "%d", $1);}
    | DOUBLE_NUMBER {sprintf($$.full, "%lf", $1);}
    | BOOLEAN {
        if($1)
        {
            sprintf($$.full, "True");
        }
        else
        {
            sprintf($$.full, "False");
        }
    }
    | expression sign expression {sprintf($$.full, "%s %s %s", $1.full, $2, $3.full);}
    | expression compare_sign expression {
        sprintf($$.full, "%s %s %s", $1.full, $2, $3.full);
        sprintf($$.value, "%s", $3.full);
    }
    | expression AND expression {sprintf($$.full, "%s and %s", $1.full, $3.full);}
    | expression OR expression {sprintf($$.full, "%s or %s", $1.full, $3.full);}
    | NOT expression {sprintf($$.full, "not %s", $2.full);}
    | MINUS expression {sprintf($$.full, "-%s", $2.full);}
    | LPAREN expression RPAREN {sprintf($$.full, "(%s)", $2.full);}
    ;

sign:
    PLUS {sprintf($$, "+");}
    | MINUS {sprintf($$, "-");}
    | MULTIPLY {sprintf($$, "*");}
    | DIVIDE {sprintf($$, "/");}
    ;

compare_sign:
    GREATER {sprintf($$, ">");}
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

log:
    CONSOLE DOT LOG LPAREN args RPAREN {fprintf(yyout, "print(%s)\n", $5);}
    ;

args:
    expression {sprintf($$, "%s", $1.full);}
    | args COMMA expression {sprintf($$, "%s,%s", $1, $3.full);}
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