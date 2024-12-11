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

void generate_indentation(char * buffer, int level)
{
    buffer[0] = '\0';
    for(int i = 0; i < level; i++)
    {
        strcat(buffer,INDENTATION);
    }
}
%}


%union {
    int intValue;
    double doubleValue;
    char str[5000];
    char operator[3];
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

%type <str> statement statements code_block
%type <str> variable_declaration_statement separate_expression assignment_statement
%type <str> branch_statement branch_condition
%type <str> expression sign

%start program

%%
program:
    statements {
        fprintf(yyout, "%s", $1);
    }
    ;

statements:
    statement {
        sprintf($$, "%s", $1);
    }
    | statements statement {
        sprintf($$, "%s%s", $1, $2);
    }
    ;

statement:
    variable_declaration_statement {  sprintf($$, "%s", $1);}
    | assignment_statement { sprintf($$, "%s", $1);}
    | branch_statement { sprintf($$, "%s", $1);}
    | separate_expression { sprintf($$, "%s", $1);}
    ;

code_block:
    statement {
        sprintf($$, "%s", $1);
    }
    | code_block statement {
        if(indentation_level < 0) indentation_level = 0;
        char indent[100];
        generate_indentation(indent, indentation_level);
        sprintf($$,"%s%s%s\n",$1,indent,$2);
    }
    ;



variable_declaration_statement:
    VARIABLE_DECLARATION_KEYWORD IDENTIFIER ASSIGN expression { 
        sprintf($$, "%s = %s\n", $2, $4);
    }
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression {
        sprintf($$, "%s = %s\n", $1, $3);
    }
    | IDENTIFIER COMPOUND_ASSIGN expression {
        sprintf($$, "%s %s %s\n", $1, $2 ,$3);
    }
    ;

branch_statement:
    branch_condition LBRACE code_block RBRACE {
        char indent[100];
        generate_indentation(indent, indentation_level);
        sprintf($$, "%s%s%s", $1, indent, $3);
        indentation_level--;
    }
    | branch_condition statement {
        char indent[100];
        generate_indentation(indent, indentation_level);
        sprintf($$, "%s%s%s", $1, indent, $2);
        indentation_level--;
    }
    ;

branch_condition:
    IF LPAREN expression RPAREN {
        indentation_level++;
        sprintf($$,"if (%s):\n", $3);
    }
    ;

separate_expression:
    expression {
        sprintf($$, "%s\n", $1);
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
