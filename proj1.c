#include <stdio.h>


void inicia_jogo();

void mostra_estado(int vidas, char* palavra, char* chute, char* erros);

void le_entrada(char* str);

void remove_fim_de_linha(char* str);

int tamanho_string(char* str);

void copia_string(char* alvo, char* origem);

void printa_string(char* str);

int testa_letra(char* palavra, char* chute, char* acertos);

int vencedor(char* palavra, char* acertos);



int main(void) {
    char palavra[20] = "academico";
    char acertos[30];
    char erros[6];
    int vidas = 5;

    inicia_jogo();
    while (vidas > 0 && !vencedor(palavra, acertos)) {
        mostra_estado(vidas, palavra, acertos, erros);
        char chute[30];
        le_entrada(chute);
        /*
        printa_string(chute);
        copia_string(acertos, chute);
        printa_string(acertos);
        printf("\n");
        */
        if (tamanho_string(chute) > 1) {
            copia_string(acertos, chute);
            break;
        } else {
            if (testa_letra(palavra, chute, acertos) == 0) {
                // adiciona ao erro
                vidas--;
            }
        }
    }

    printf("\n==== FIM DE JOGO ====\n");
    if (vencedor(palavra, acertos)) {
        printf("GANHOU!\n");
    } else {
        printf("PERDEU.\n");
    }

    return 0;
}


void inicia_jogo()
{
    printf("==== Jogo da Forca ====\n");
    printf("Digite letras ou palavras para jogar. Você tera 5 vidas para acertar.\n");
    printf("Chutar uma palavra significa fim do jogo. Chute apenas quando tiver certeza.\n");
    printf("Utilize apenas letras minusculas\n");
    printf("=======================\n");
}


/* mostra o estado do jogo: n de vidas, acertos e erros ao usuario */
void mostra_estado(int vidas, char* palavra, char* acertos, char* erros)
{
    printf("Vidas: %d    |    ", vidas);

    int i = 0;
    while (palavra[i] != '\0') {
        if (acertos[i] == palavra[i]) {
            printf("%c ", palavra[i]);
        } else {
            printf("_ ");
        }
        i++;
    }
    printf("| Erros: ");
    i = 0;
    while (erros[i] != '\0') {
        printf("%c ", erros[i]);
        i++;
    }
    printf("\n");
}


/* le o chute do usuario */
void le_entrada(char* chute)
{
    //printf("Chute: ");
    fgets(chute, sizeof(chute), stdin);

    remove_fim_de_linha(chute);
}


/* remove o caractere de fim de linha lido pelo fgets */
void remove_fim_de_linha(char* str)
{
    int i = 0;
    while (str[i] != '\0' && str[i] != '\n') {
        i++;
    }
    str[i] = '\0';
}


/* testa se a letra do chute existe na palavra, retorna 1 se existir.
   caso exista, adiciona a letra em acertos */
int testa_letra(char* palavra, char* chute, char* acertos)
{
    int flag = 0;
    int i = 0;
    while (palavra[i] != '\0') {
        if (chute[0] == palavra[i]) {
            acertos[i] = chute[0];
            flag = 1;
        }
        i++;
    }
    return flag;
}


/* retorna o tamanho de uma dada string */
int tamanho_string(char* str)
{
    int i = 0;
    while (str[i] != '\0') i++;
    return i;
}


/* copia a segunda string para a primeira */
void copia_string(char* alvo, char* origem)
{
    int i = 0;
    while (origem[i] != '\0') {
        alvo[i] = origem[i];
        i++;
    }
    alvo[i] = '\0';
}


void printa_string(char* str)
{
    int i = 0;
    while (str[i] != '\0') {
        printf("%c", str[i]);
        i++;
    }
    printf("   ");
}


/* verifica se os acertos correspondem a palavra. retorna 1 quando vencedor. */
int vencedor(char* palavra, char* acertos)
{
    if (tamanho_string(palavra) != tamanho_string(acertos)) return 0;

    printf("\nOlá\n");
    int i = 0;
    while (palavra[i] != '\0'){
        if (acertos[i] != palavra[i]) return 0;
        i++;
    }

    return 1;
}
