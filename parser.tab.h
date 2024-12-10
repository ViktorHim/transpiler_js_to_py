/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    VARIABLE_DECLARATION_KEYWORD = 258, /* VARIABLE_DECLARATION_KEYWORD  */
    IF = 259,                      /* IF  */
    ELSE = 260,                    /* ELSE  */
    FOR = 261,                     /* FOR  */
    WHILE = 262,                   /* WHILE  */
    DO = 263,                      /* DO  */
    LPAREN = 264,                  /* LPAREN  */
    RPAREN = 265,                  /* RPAREN  */
    LBRACE = 266,                  /* LBRACE  */
    RBRACE = 267,                  /* RBRACE  */
    LBRACKET = 268,                /* LBRACKET  */
    RBRACKET = 269,                /* RBRACKET  */
    SEMICOLON = 270,               /* SEMICOLON  */
    DOT = 271,                     /* DOT  */
    COMMA = 272,                   /* COMMA  */
    INCREMENT = 273,               /* INCREMENT  */
    DECREMENT = 274,               /* DECREMENT  */
    PLUS = 275,                    /* PLUS  */
    MINUS = 276,                   /* MINUS  */
    MULTIPLY = 277,                /* MULTIPLY  */
    DIVIDE = 278,                  /* DIVIDE  */
    MODULO = 279,                  /* MODULO  */
    ASSIGN = 280,                  /* ASSIGN  */
    PLUS_ASSIGN = 281,             /* PLUS_ASSIGN  */
    MINUS_ASSIGN = 282,            /* MINUS_ASSIGN  */
    MULTIPLY_ASSIGN = 283,         /* MULTIPLY_ASSIGN  */
    DIVIDE_ASSIGN = 284,           /* DIVIDE_ASSIGN  */
    GREATER = 285,                 /* GREATER  */
    LESS = 286,                    /* LESS  */
    GREATER_EQUAL = 287,           /* GREATER_EQUAL  */
    LESS_EQUAL = 288,              /* LESS_EQUAL  */
    EQUAL = 289,                   /* EQUAL  */
    STRICT_EQUAL = 290,            /* STRICT_EQUAL  */
    NOT_EQUAL = 291,               /* NOT_EQUAL  */
    STRICT_NOT_EQUAL = 292,        /* STRICT_NOT_EQUAL  */
    IDENTIFIER = 293,              /* IDENTIFIER  */
    STRING_LITERAL = 294,          /* STRING_LITERAL  */
    INT_NUMBER = 295,              /* INT_NUMBER  */
    DOUBLE_NUMBER = 296            /* DOUBLE_NUMBER  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 16 "parser.y"

    int intValue;
    double doubleValue;
    char str[100];
    char identifier[100];

#line 112 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
