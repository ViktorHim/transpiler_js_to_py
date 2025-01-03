%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

extern FILE *tokens_file;

%}

%%
"true"              {
                        fprintf(tokens_file, "%s\n", yytext);
                        yylval.bool = 1;
                        return BOOLEAN;
                    }

"false"             {
                        fprintf(tokens_file, "%s\n", yytext);
                        yylval.bool = 0;
                        return BOOLEAN;
                    }

"let"|"var"|"const" {
                        fprintf(tokens_file, "%s\n", yytext);
                        return VARIABLE_DECLARATION_KEYWORD;
                    }

"if"                {
                        fprintf(tokens_file, "IF\n");
                        return IF;
                    }

"else"              {
                        fprintf(tokens_file, "ELSE\n");
                        return ELSE;
                    }

"for"               {
                        fprintf(tokens_file, "FOR\n");
                        return FOR;
                    }

"while"             {
                        fprintf(tokens_file, "WHILE\n");
                        return WHILE;
                    }

"do"                {
                        fprintf(tokens_file, "DO\n");
                        return DO;
                    }

"console"           {
                        fprintf(tokens_file, "CONSOLE\n");
                        return CONSOLE;
                    }

"log"           {
                        fprintf(tokens_file, "LOG\n");
                        return LOG;
                    }

"("                 {
                        fprintf(tokens_file, "LPAREN\n");
                        return LPAREN;
                    }

")"                 {
                        fprintf(tokens_file, "RPAREN\n");
                        return RPAREN;
                    }

"{"                 {
                        fprintf(tokens_file, "LBRACE\n");
                        return LBRACE;
                    }

"}"                 {
                        fprintf(tokens_file, "RBRACE\n");
                        return RBRACE;
                    }

"["                 {
                        fprintf(tokens_file, "LBRACKET\n");
                        return LBRACKET;
                    }

"]"                 {
                        fprintf(tokens_file, "RBRACKET\n");
                        return RBRACKET;
                    }

"."                 {
                        fprintf(tokens_file, "DOT\n");
                        return DOT;
                    }

","                 {
                        fprintf(tokens_file, "COMMA\n");
                        return COMMA;
                    }
"++"                {
                        fprintf(tokens_file, "INCREMENT\n");
                        return INCREMENT;
                    }

"--"                {
                        fprintf(tokens_file, "DECREMENT\n");
                        return DECREMENT;
                    }

"+"                 {
                        fprintf(tokens_file, "PLUS\n");
                        return PLUS;
                    }

"-"                 {
                        fprintf(tokens_file, "MINUS\n");
                        return MINUS;
                    }

"*"                 {
                        fprintf(tokens_file, "MULTIPLY\n");
                        return MULTIPLY;
                    }

"/"                 {
                        fprintf(tokens_file, "DIVIDE\n");
                        return DIVIDE;
                    }

"%"                 {
                        fprintf(tokens_file, "MODULO\n");
                        return MODULO;
                    }

"="                 {
                        fprintf(tokens_file, "ASSIGN\n");
                        return ASSIGN;
                    }

"+="|"-="|"/="|"*=" {
                        fprintf(tokens_file, "PLUS_ASSIGN\n");
                        strcpy(yylval.str, yytext);
                        return COMPOUND_ASSIGN;
                    }

">"                 {
                        fprintf(tokens_file, "GREATER\n");
                        return GREATER;
                    }

"<"                 {
                        fprintf(tokens_file, "LESS\n");
                        return LESS;
                    }

">="                {
                        fprintf(tokens_file, "GREATER_EQUAL\n");
                        return GREATER_EQUAL;
                    }

"<="                {
                        fprintf(tokens_file, "LESS_EQUAL\n");
                        return LESS_EQUAL;
                    }

"=="                {
                        fprintf(tokens_file, "EQUAL\n");
                        return EQUAL;
                    }

"==="               {
                        fprintf(tokens_file, "STRICT_EQUAL\n");
                        return STRICT_EQUAL;
                    }

"!="                {
                        fprintf(tokens_file, "NOT_EQUAL\n");
                        return NOT_EQUAL;
                    }

"!=="               {
                        fprintf(tokens_file, "STRICT_NOT_EQUAL\n");
                        return STRICT_NOT_EQUAL;
                    }

";"                 {
                        fprintf(tokens_file, "SEMICOLON\n");
                        return SEMICOLON;
                    }

"!"                 {
                        fprintf(tokens_file, "NOT\n");
                        return NOT;
                    }

"||"                 {
                        fprintf(tokens_file, "OR\n");
                        return OR;
                    }

"&&"                {
                        fprintf(tokens_file, "AND\n");
                        return AND;
                    }

[0-9]+              {
                        fprintf(tokens_file, "INT NUMBER: %s\n", yytext);
                        yylval.intValue = atoi(yytext);
                        return INT_NUMBER; 
                    }

[0-9]+\.[0-9]+      {
                        fprintf(tokens_file, "INT NUMBER: %s\n", yytext);
                        yylval.doubleValue = atof(yytext);
                        return DOUBLE_NUMBER;
                    }

[a-zA-Z_][a-zA-Z0-9_]* {
                        fprintf(tokens_file, "IDENTIFIER: %s\n", yytext);
                        strcpy(yylval.identifier, yytext);
                        return IDENTIFIER; 
                    }

["][^"].*["]        {
                        fprintf(tokens_file, "STRING_LITERAL: %s\n", yytext);
                        strcpy(yylval.str, yytext);
                        return STRING_LITERAL; 
                    }

^\s*$               {
                        fprintf(tokens_file, "EMPTY LINE\n");
                        return EMPTY;
                    }

[\t\r\n ]+          {
                        //skip
                    }

.                   {
                        fprintf(tokens_file, "Unknown character: %s\n", yytext);
                        exit(-1);
                    }
%%

int yywrap(void) {
    return 1;
}