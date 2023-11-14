%{
    #include<stdio.h>
    #include<stdlib.h>
    #include"lex.yy.c"
    #include "SymbolTable.c"

    extern void insertIntoSymbolTable(char *name, char *type, int scope, int datatype, int lineNumber);
    extern int searchSymbolTable(char *identifier, int scope);
    extern void enterScope();
    extern void exitScope();
    void yyerror (char *s);
    int yylex();

    extern int currentScope;
    extern int lineNumber;
%}


%union{
    int intVal;
    float floatVal;
    char charVal;
    char* strVal;
}





%token INT STRING FLOAT CHAR ADAPT RETURN FOR IF WHILE ELSE TRUE FALSE 
FUNC UNARY ADD SUB DIV MUL OR LE GE EQ NE GT LT PRINT ACCEPT VOID INIT 

%start  programStart 
%type<strVal> function_body
%type<strVal> function_calls
%type<strVal> parameters
%type<strVal> parameterList
%type<strVal> parameter
%type<strVal> datatype
%type<strVal> function_name
%type<strVal> variable
%token <intVal> INT_VALUE
%token <floatVal> FLOAT_VALUE
%token <strVal> STRING_VALUE
%token <charVal> CHAR_VALUE
%token <strVal> IDENTIFIER

%left ADD SUB
%left MUL DIV

%nonassoc GE LE EQ NE GT LT OR 

%%

/*
    This would be the main starting function for the language
    Must be called at the start of the program
    func init(){
      
    }
*/

programStart: FUNC INIT'('')''{' function_declarations statements'}'
            ;

statements: statement'\n' 
          | statements statement '\n'
          ;

statement : function_calls
          | condition
          | expression
          | loops
          | RETURN IDENTIFIER    
          | PRINT'(' STRING_VALUE')'  {printf("%s\n",$3);}
          | PRINT'(' IDENTIFIER')'    {printf("%d\n",$3);}
          | PRINT'(' INT_VALUE')'     {printf("%d\n",$3);} 
          | PRINT'(' FLOAT_VALUE')'   {printf("%f\n",$3);}
          | PRINT'(' CHAR_VALUE')'    {printf("%c\n",$3);}
          | ACCEPT'(' INT_VALUE')'    {scanf("%d",&$3);}
          | ACCEPT'(' FLOAT_VALUE')'  {scanf("%f",&$3);}
          | ACCEPT'(' CHAR_VALUE')'   {scanf("%c",&$3);}
          | ACCEPT'(' STRING_VALUE')' {scanf("%s",&$3);}
        ;


function_declarations: '\n'
                    |function_declaration
                    | function_declaration  function_declarations
                    ;

function_declaration:  FUNC function_name':'datatype'{' function_body '}' 
                    ;

function_body: statements {exitScope();};

function_calls: function_name{if(searchSymbolTable($1,currentScope)==1){
                                                printf("Function %s called\n",$1);
                                            }
                                            else{
                                                printf("Function %s not declared\n",$1);
                                            }
                                            }
              ;

function_name: IDENTIFIER'('')'
             | IDENTIFIER'('parameters')'
             ;
         

variable: IDENTIFIER'\n' 
    ;

parameters: parameterList
          ;
parameterList: parameter 
            |parameter ','  parameterList
            ;

parameter: datatype IDENTIFIER {
    switch($1){
        case 'int':
            insertIntoSymbolTable($2, "identifier", currentScope, $1, lineNumber); 
            break;
        case 'float':
            insertIntoSymbolTable($2, "identifier", currentScope, $1, lineNumber); 
            break;
        case 'string':
            insertIntoSymbolTable($2,"identifier", currentScope, $1, lineNumber); 
            break;
        case 'char':
            insertIntoSymbolTable($2,"identifier", currentScope, $1, lineNumber); 
            break;
        default:
            printf("Error in parameter\n");
            break;
    }
};



datatype: INT { $$ = "int"; }
        | FLOAT { $$ = "float"; }
        | STRING { $$ = "string"; }
        | CHAR { $$ = "char"; }
        | ADAPT { $$ = "adapt"; }
        | VOID { $$ = "void"; }
        ;

atom: INT_VALUE
    | FLOAT_VALUE
    | CHAR_VALUE
    | STRING_VALUE
    | variable
    | TRUE
    | FALSE
    ;

paren_expr: '('expression')';

binary_expr: variable ADD expression {$$ = $1 + $3;}
           | variable SUB expression {$$ = $1 - $3;}
           | variable MUL expression {$$ = $1 * $3;}
           | variable DIV expression {$$ = $1 / $3;}
           | variable OR expression  {$$ = $1 || $3;}
           | variable LE expression  {$$ = $1 <= $3;}
           | variable GE expression  {$$ = $1 >= $3;}
           | variable EQ expression  {$$ = $1 == $3;}
           | variable NE expression  {$$ = $1 != $3;}
           | variable GT expression  {$$ = $1 > $3;}
           | variable LT expression  {$$ = $1 < $3;}
           ;

expression: atom
          | paren_expr
          | binary_expr
          ;

condition: IF expression'{' statements '}'  {enterScope();};
         | IF expression'{' statements '}' ELSE'{' statements '}' {enterScope();}
         ;

loops: loop
    |  loop loops
    ;

loop: forLoop
    | whileLoop
    ;

forLoop: FOR'('expression';' condition';' expression')''{' statements '}' {enterScope();};

whileLoop: WHILE'(' condition')''{' statements '}' {enterScope();};




%%
int main(void){
  return yyparse();



 
  printf("Symbol Table\n");
  printf("Name\tType\tScope\tDataType\tLine Number\n");
  for(int i=0;i<100;i++){
    printf("%s %s %d %d %d\n",symbolTable[i].name,symbolTable[i].type,symbolTable[i].scope,symbolTable[i].datatype,symbolTable[i].lineNumber);
  }
}
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 


