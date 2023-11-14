#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#define MAX_SYMBOLS 100
#define MAX_SCOPES 50

/* Structure for symbol table entry */
struct Symbol {
    char name[20];
    char type[20];
    int scope;
    char datatype[20]; // For datatype identification (e.g., 1: INT, 2: FLOAT, 3: STRING, etc.)
    int lineNumber; // For tracking the line number where the identifier appears
    // Additional attributes as needed
};

struct Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;
int currentScope = 0;

/* Function to search for an identifier in the symbol table within a specific scope */
int searchSymbolTable(char *identifier, int scope) {
    for (int i = symbolCount - 1; i >= 0; --i) {
        if (strcmp(symbolTable[i].name, identifier) == 0 && symbolTable[i].scope == scope) {
            return i;  // Found the identifier in the table within the specified scope
        }
    }
    return -1;  // Identifier not found in the specified scope
}

/* Function to insert a new identifier into the symbol table */
void insertIntoSymbolTable(char *name, char *type, int scope, char *datatype, int lineNumber) {
    if (symbolCount < MAX_SYMBOLS) {
        strcpy(symbolTable[symbolCount].name, name);
        strcpy(symbolTable[symbolCount].type, type);
        symbolTable[symbolCount].scope = scope;
        strcpy(symbolTable[symbolCount].datatype, datatype);
        symbolTable[symbolCount].lineNumber = lineNumber;
        symbolCount++;
    } else {
        printf("Symbol table full. Cannot insert %s\n", name);
    }
}

/* Function to enter a new scope */
void enterScope() {
    currentScope++;
    if (currentScope >= MAX_SCOPES) {
        printf("Maximum scope limit exceeded.\n");
        currentScope--;
    }
}

/* Function to exit the current scope */
void exitScope() {
    for (int i = symbolCount - 1; i >= 0; --i) {
        if (symbolTable[i].scope == currentScope) {
            symbolCount--;
        } else {
            break;
        }
    }
    currentScope--;
}
