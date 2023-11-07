%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"

    int yylex();
    int yywrap();
%}


%union{
    int intVal;
    float floatVal;
    char charVal;
    char* strVal;
}

%token INT STRING FLOAT CHAR ADAPT RETURN FOR IF WHILE ELSE TRUE FALSE 
FUNC UNARY ADD SUB DIV MUL OR LE GE EQ NE GT LT PRINT ACCEPT VOID INIT 

%token <intVal> INT_VALUE
%token <floatVal> FLOAT_VALUE
%token <strVal> STRING_VALUE
%token <charVal> CHAR_VALUE
%token <strVal> IDENTIFIER

%start  programStart datatype arithmetic statement condition else methodinit methodbody
%left '+' '-'
%left '*' '/'

%%

/*
    This would be the main starting function for the language
    func init(){
      
    }
*/

programStart: FUNC INIT'(' ')''{' statement '}' ;

statement: statement
    | methodinit methodbody
    | condition
    | arithmetic
    | loop
    | PRINT'(' STRING_VALUE')'
    | PRINT'(' IDENTIFIER')'
    | PRINT'(' INT_VALUE')'
    | PRINT'(' FLOAT_VALUE')'
    | PRINT'(' CHAR_VALUE')'
    | ACCEPT'(' INT_VALUE')'
    | ACCEPT'(' FLOAT_VALUE')'
    | ACCEPT'(' CHAR_VALUE')'
    | ACCEPT'(' STRING_VALUE')'
    ;

methodinit: IDENTIFIER'('parameters ')' ':' datatype'{' methodbody '}' ;
parameters: parameterList
          | /* Empty */
          ;

parameterList: parameter 
            |parameterList ',' parameter
            ;

parameter: datatype IDENTIFIER;

methodbody: methodbody 
          | statement
          | condition
          | arithmetic
          | RETURN IDENTIFIER
          | RETURN value
          ;

datatype: INT
    |FLOAT
    |STRING
    |CHAR
    |ADAPT
    |VOID
    ;
    
condition: IF condition'{' statement '}' 
         | IF condition'{' statement '}' ELSE'{' statement '}'
         |IF '{' statement '}'
         |IF '{' statement '}' ELSE'{' statement '}'
         ;

arithmetic: datatype IDENTIFIER
          | datatype IDENTIFIER '=' value
          | IDENTIFIER '=' value
          | IDENTIFIER EQ value
          | IDENTIFIER EQ IDENTIFIER
          | value ADD value
          | value SUB value
          | value MUL value
          | value DIV value
          | value OR value
          | value LE value
          | value GE value
          | value EQ value
          | value NE value
          | value GT value
          | value LT value
          | UNARY value
          | value UNARY
          ;

loop: whileLoop
    | forLoop
    ;

forLoop: FOR'('arithmetic';' condition';' arithmetic')''{' statement '}';

whileLoop: WHILE'(' condition')''{' statement '}';

value: INT_VALUE
     | FLOAT_VALUE
     | CHAR_VALUE
     | STRING_VALUE
     | IDENTIFIER
     | TRUE
     | FALSE
     ;
%%
int main(){
  yyparse();
  printf("No Errors!!\n");
  return 0;
}


