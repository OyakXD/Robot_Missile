#include <stdlib.h>
#include <stdio.h>


extern char GenerateCode(char vetor[]) {
    return vetor[rand() % 26];
}


void printfRand(char c) {
    printf("Letra aleatória: %c\n", c);
}
