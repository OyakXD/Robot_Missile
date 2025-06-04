#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

const char Letters[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

char GenerateCode() {
    return Letters[rand() % 26];
}

bool missile(char letra, char code) {
    if(letra == code){
        printf("Achou!\n");
        return true;
    } else if(letra < code){
        printf("Depois de %c\n", letra);
    } else {
        printf("Antes de %c\n", letra);
    }
    return false;
}


int main() {
    srand(time(NULL));

    char code = GenerateCode();
    char res;
    int count = 0;
    bool acertou = false;

    printf("ROBOT MISSILE\n");
    printf(" \n");
    printf("TYPE THE CORRECT CODE\n");
    printf("LETTER (A-Z) TO\n");
    printf("DEFUSE THE MISSILE\n");
    printf("YOU HAVE 4 CHANCES\n");
    printf(" \n");

    while(count < 4 && !acertou) {
        printf("TYPE A LETTER: ");
        scanf(" %c", &res);

        if(res >= 'a' && res <= 'z') {
            res -= 32;
        }

        acertou = missile(res, code);
        if(!acertou) {
            count++;
        }
    }

    if(!acertou) {
        printf("YOU BLEW IT\n");
        printf("THE CORRET CODE WAS: %c\n", code);
    }

    return 0;
}