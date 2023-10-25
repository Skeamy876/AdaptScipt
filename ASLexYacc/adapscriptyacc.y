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
    char* strVal;
}

%token INT STRING FLOAT ADAPT RETURN FOR IF WHILE ELSE TRUE FALSE FUNC UNARY ADD SUB DIV MUL OR LE GE EQ NE GT LT PRINT ACCEPT

%token <intVal> INT_VALUE
%token <floatVal> FLOAT_VALUE
%token <strVal> STRING_VALUE
%token <strVal> IDENTIFIER

%type <strVal> func_decl
%type <strVal> decl
%type <strVal> expr
%type <strVal> datatype
%type <strVal> arithmetic
%type <strVal> statement
%type <strVal> condition
%type <strVal> else

%left '+' '-'
%left '*' '/'

%%

/*
samples:
int num = 3-done

for(i=0,i<num, i++){
  //code block
}

adap count=0
while(count<=num){
  //code block
  count++
}

if(i<num){
  print("hi")
}else-if(i==0){
  adap num =accept()
}else{
  prrint("bye")
}

func addnum(int num, int num2)int {
  adap sum=num + num2-done
  return sum
}
*/
decl: decl expr
  |expr
  |datatype expr
  |func_decl
  ;



/*support for only one or two parameters*/
func_decl: FUNC IDENTIFIER'('datatype_list')'datatype '{'expr'}'
  |
  ;

datatype_list: datatype IDENTIFIER
  | datatype IDENTIFIER ',' datatype IDENTIFIER
  |
  ;
            
datatype: INT
  |STRING
  |FLOAT
  |ADAPT
  ;

expr: FOR '('statement ';' condition ';' statement ')' '{' expr'}'
  |WHILE '('condition')' '{'expr statement'}'
  |IF '('condition')' '{'expr'}' else
  |statement
  |expr expr
  |PRINT'('STRING_VALUE')'
  |IDENTIFIER '=' ACCEPT'('')'
  ;


else: ELSE '{'expr'}'
  |
  ;

condition: value relop value 
| TRUE 
| FALSE
;


statement: datatype IDENTIFIER init 
| IDENTIFIER '=' expression 
| IDENTIFIER relop expression
| IDENTIFIER UNARY 
| UNARY IDENTIFIER
;

init: '=' value 
|
;

expression: expression arithmetic expression
| value
;

arithmetic: ADD 
| SUB 
| MUL
| DIV
;

relop: LT
| GT
| LE
| GE
| EQ
| NE
;

value: INT_VALUE
| FLOAT_VALUE
| STRING_VALUE
| IDENTIFIER
;

return: RETURN value ';' 
|
;


%%
int main(){
  yyparse();
  printf("No Errors!!\n");
  return 0;
}


