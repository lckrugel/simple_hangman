#include <stdio.h>


void inicia_jogo();

void mostra_estado(int vidas, char* palavra, char* chute, char* erros);

void le_entrada(char* str);

void remove_fim_de_linha(char* str);

int tamanho_string(char* str);

void inicia_string(char* str, int tam);

void copia_string(char* alvo, char* origem);

void printa_string(char* str, int espaco);

int letra_repetida(char* chute, char* acertos, char* erros);

int letra_certa(char* palavra, char* chute, char* acertos);

int vencedor(char* palavra, char* acertos);



int main(void) {
    char palavra[20] = "academico";
    char acertos[30];
    char erros[6];
    int vidas = 5;

    inicia_string(acertos, 30);
    inicia_string(erros, 6);

    inicia_jogo();
    while (vidas > 0 && !vencedor(palavra, acertos)) {
        mostra_estado(vidas, palavra, acertos, erros);
        char chute[30];
        le_entrada(chute);
        if (tamanho_string(chute) > 1) {
            copia_string(acertos, chute);
            break;
        } else {
            if (letra_repetida(chute, acertos, erros)) {
                printf("Voce ja tentou isso.\n");
                continue;
            }
            if (!letra_certa(palavra, chute, acertos) && chute[0] != '\0') {
                // adiciona ao erro
                vidas--;
            }
        }
    }

    printf("\n==== FIM DE JOGO ====\n");
    if (vencedor(palavra, acertos)) {
        printa_string(acertos, 0);
        printf("\n");
        printf("GANHOU!\n");
        printf("=======================\n");
    } else {
        printf("PERDEU.\n");
        printf("A palavra era: ");
        printa_string(palavra, 0);
        printf("\n");
        printf("=======================\n");
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
    printa_string(erros, 1);
    printf("\n");
}


/* le o chute do usuario */
void le_entrada(char* chute)
{
    printf("Chute: ");
    fgets(chute, 30, stdin);

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


/* checa se a letra do chute esta contida nos acertos ou erros */
int letra_repetida(char* chute, char* acertos, char* erros)
{
    int i = 0;
    while (erros[i] != '\0') {
        if (erros[i] == chute[0]) {
            return 1;
        }
        i++;
    }

    i = 0;
    while (acertos[i] != '\0') {
        if (acertos[i] == chute[0]) {
            return 1;
        }
        i++;
    }
    return 0;
}


/* testa se a letra do chute existe na palavra, retorna 1 se existir.
   caso exista, adiciona a letra em acertos */
int letra_certa(char* palavra, char* chute, char* acertos)
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


/* preenche o vetor str de vetor tam com ' ' e o finaliza com '\0' */
void inicia_string(char* str, int tam)
{
    int i = 0;
    for (i = 0; i < tam-1; i++) {
        str[i] = ' ';
    }
    str[i] = '\0';
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


/* printa a string str, caso espaco seja true (1) vai adicionar um espaco
   entre os caracteres. */
void printa_string(char* str, int espaco)
{
    int i = 0;
    while (str[i] != '\0') {
        printf("%c", str[i]);
        if(espaco) printf(" ");
        i++;
    }
    printf("");
}


/* verifica se os acertos correspondem a palavra. retorna 1 quando vencedor. */
int vencedor(char* palavra, char* acertos)
{
    int i = 0;
    while (palavra[i] != '\0') {
        if (acertos[i] != palavra[i]) return 0;
        i++;
    }

    return 1;
}
