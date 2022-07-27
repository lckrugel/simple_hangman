

.data
intro_00:   .asciiz "==== Jogo da Forca ====\n"
intro_01:   .asciiz "Digite letras ou palavras para jogar. Você tera 5 vidas para acertar.\n"
intro_02:   .asciiz "Chutar uma palavra significa fim do jogo. Chute apenas quando tiver certeza.\n"
intro_03:   .asciiz "Utilize apenas letras minusculas.\n"
intro_04:   .asciiz "=======================\n"
leitura_01: .asciiz "Chute: "
estado_01:  .asciiz "Vidas: "
estado_02:  .asciiz "   |   "
estado_03:  .asciiz "_ "
estado_04:  .asciiz "|   Erros: "
outro_00:   .asciiz "\n===== FIM DE JOGO =====\n"
outro_01_A: .asciiz "GANHOU\n"
outro_01_B: .asciiz "PERDEU\n"
outro_02:   .asciiz "A palavra era: "
outro_03:   .asciiz "=======================\n"

palavra:    .asciiz "academico"
chute:      .asciiz "a"
acertos:    .asciiz "academica"
erros:      .asciiz "kgb"




.text

.eqv SERVICO_IMPRIME_STRING 4               # DEFINE para printf("%s")
.eqv SERVICO_IMPRIME_CARACTERE 11           # DEFINE para printf("%c")
.eqv SERVICO_IMPRIME_INTEIRO 1              # DEFINE para printf("%d")
.eqv SERVICO_LE_STRING 8                    # DEFINE para fgets()
.eqv SERVICO_SAIDA 17                       # DEFINE para exit2()

.globl main


#######################################
# MAPA DE REGISTRADORES
# $s0 - *chute
# $s1 - *palavra
# $s2 - *acertos
# $s3 - *erros
# $s4 - vidas
# $s5 - n_chutes_errados
#######################################
# MAPA DA MEMORIA
# | $ra            |    $sp + 0
#######################################
main:
    # == prologo ==
    addiu   $sp, $sp, -12                   # aloca x bytes na pilha
    sw      $ra, 0($sp)                     # guarda o end de retorno

    # == corpo ==
    la      $s0, chute
    la      $s1, palavra
    la      $s2, acertos
    la      $s3, erros
    li      $s4, 5                          # $s4 <- vidas

    # tela inicial
    jal     tela_inicial

    # inicia string
    #addiu   $t0, $zero, 10
    #la      $a0, ($s2)
    #la      $a1, ($t0)
    #jal     inicia_string

    # mostra estado
    la      $a0, ($s4)
    la      $a1, ($s1)
    la      $a2, ($s2)
    la      $a3, ($s3)
    jal     mostra_estado

    # letra repetida
    #la      $a0, ($s0)
    #la      $a1, ($s2)
    #la      $a2, ($s3)
    #jal     letra_repetida

    # letra certa
    #la      $a0, ($s0)
    #la      $a1, ($s1)
    #la      $a2, ($s2)
    #jal     letra_certa

    # vencedor
    la      $a0, ($s1)
    la      $a1, ($s2)
    jal     vencedor

    # tela final
    #la      $a0, ($s1)
    #li      $a1, 0
    #jal     tela_final    

    # le string
    #la      $a0, ($s0)
    #li      $a1, 30
    #jal     le_entrada

    # copia palavra em chute
    #la      $s1, palavra
    #la      $a0, ($s0)
    #la      $a1, ($s1)
    #jal     copia_string

    # remove fim de linha
    #la      $a0, ($s0)
    #jal     remove_fim_de_linha

    # printa inteiro
    la      $a0, ($v0)
    li      $v0, SERVICO_IMPRIME_INTEIRO
    syscall
    
    # printa string
    #addiu   $t1, $zero, 0                   # espaco (0 ou 1)
    #la      $a0, ($s2)
    #la      $a1, ($t1)
    #jal     printa_string

    # tamanho string
    #la      $s1, palavra
    #la      $a0, ($s1)
    #jal     tamanho_string


    # == epilogo ==
    lw      $ra, 0($sp)                     # recupera end de retorno
    addiu   $sp, $sp, 12                    # libera x bytes na pilha
    li      $v0, SERVICO_SAIDA              
    li      $a0, 0
    syscall                                 # return 0 - sai sem erros


#######################################
# mostra a tela inicial com o nome e instrucoes do jogo
# argumentos:
#   nao utiliza
# retorno:
#   nao retorna nada
#######################################
# MAPA DE REGISTRADORES
# $v0 - servico usado no syscall
# $a0 - string que sera usada no syscall
#######################################
# PROCEDIMENTO FOLHA, NAO REQUER AJUSTE EM $ra
#######################################
tela_inicial:
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, intro_00
    syscall
    la      $a0, intro_01
    syscall
    la      $a0, intro_02
    syscall
    la      $a0, intro_03
    syscall
    la      $a0, intro_04
    syscall

    jr		$ra


#######################################
# mostra a tela final e informa se o jogador venceu ou nao
# argumentos:
#   $a0 - *palavra
#   $a1 - vencedor (flag)
# retorno:
#   nao retorna nada
#######################################
# MAPA DE REGISTRADORES
# $v0 - servico usado no syscall
# $a0 - string que sera usada no syscall
# $t0 - 1
#######################################
# MAPA DE MEMORIA
# |    $ra   |          $sp+0
# | *palavra |          $sp+4
#######################################
tela_final:
    # == prologo ==
    addiu   $sp, $sp, -8                    # aloca 8 bytes na pilha
    sw      $ra, 0($sp)                     # guarda end de retorno
    sw      $a0, 4($sp)                     # guarda end de *palavra

    # == corpo ==
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, outro_00
    syscall                                 # printf("===== FIM DE JOGO =====\n")

    final_if_condicao:
    li      $t0, 1
    bne     $a1, $t0, final_else            # if(vencedor==1)

    final_if_codigo:
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, outro_01_A
    syscall                                 # printf("GANHOU!\n")
    j       final_if_else_fim

    final_else:
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, outro_01_B
    syscall                                 # printf("PERDEU.\n")

    final_if_else_fim:
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, outro_02
    syscall                                 # printf("A palavra era: ")

    lw      $a0, 4($sp)                     # carrega *palavra em $a0
    li      $a1, 0
    jal     printa_string                   # printa_string(palavra, 0)
    # ax = ??? tx = ???

    li      $v0, SERVICO_IMPRIME_CARACTERE
    li      $a0, '\n'
    syscall                                 # printf("\n")
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, outro_03
    syscall                                 # printf("=======================\n")

    # == epilogo ==
    lw      $ra, 0($sp)                     # carrega end de retorno
    addiu   $sp, $sp, 8                     # retira 8 bytes da pilha
    jr      $ra


#######################################
# mostra o estado do jogo: n de vidas, acertos e erros ao jogador  
# argumentos:
#   $a0 - vidas
#   $a1 - *palavra
#   $a2 - *acertos
#   $a3 - *erros
# retorno:
#   nao retorna nada
#######################################
# $a0 - string utilizada no syscall
# $v0 - codigo do syscall
# $t0 - i
# $t1 - endereco de palavra[i]
# $t2 - palavra[i]
# $t3 - endereco de acertos[i]
# $t4 - acertos[i]
#######################################
# MAPA DE MEMORIA
# | vidas |             $sp+4
# | $ra   |             $sp+0
#######################################
mostra_estado:
    # == prologo ==
    addiu   $sp, $sp, -8                    # aloca 8 bytes na pilha
    sw      $ra, 0($sp)                     # guarda end de retorno
    sw      $a0, 4($sp)                     # guarda end de vidas

    # == corpo ==
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, estado_01
    syscall                                 # printf("Vidas: ")
    lw      $a0, 4($sp)
    li      $v0, SERVICO_IMPRIME_INTEIRO
    syscall                                 # printf("%d", vidas)
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, estado_02
    syscall                                 # printf("    |    ")

    li      $t0, 0                          # int i = 0;
    estado_while_inicio:    
        j       estado_while_condicao

    estado_while_codigo:
        estado_if_condicao:
            add     $t3, $a2, $t0           # $t2 = (*palavra) + i
            lbu     $t4, 0($t3)             # palavra[i]
            bne     $t2, $t4, estado_else        
                                            # if(palavra[i]==acertos[i])

        # se acertou uma letra, mostra ela
        estado_if_codigo:
            li      $v0, SERVICO_IMPRIME_CARACTERE
            la      $a0, ($t4)
            syscall                         # printf("%c", palavra[i])
            li      $v0, SERVICO_IMPRIME_CARACTERE
            li      $a0, ' '
            syscall                         # printf(" ")
            j       estado_if_else_fim

        # se nao acertou, mostra um '_'
        estado_else:
            li      $v0, SERVICO_IMPRIME_STRING
            la      $a0, estado_03
            syscall                         # printf("_ ")

        estado_if_else_fim:
        addiu   $t0, $t0, 1                 # i++

    estado_while_condicao:
        add     $t1, $a1, $t0               # $t2 = (*palavra) + i
        lbu     $t2, 0($t1)                 # palavra[i]
        bne		$t2, $zero, estado_while_codigo	    
                                            # while(palavra[i]!='\0')

    estado_while_fim:
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, estado_04
    syscall                                 # printf("| Erros: ")
    
    la      $a0, ($a3)
    li		$a1, 1
    jal     printa_string                   # printa_string(erros, 1)
    # $tx = ??? $ax = ???

    li      $v0, SERVICO_IMPRIME_CARACTERE
    li      $a0, '\n'
    syscall                                 # printf("\n")

    # == epilogo ==
    lw      $ra, 0($sp)                     # carrega o end de retorno
    addiu   $sp, $sp, 8                     # retira 8 bytes da pilha
    jr		$ra


#######################################
# preenche o vetor str de vetor tam com '@' e o finaliza com '\0' 
# argumentos:
#   $a0 - str (string a ser inicializada)
#   $a1 - tam (tamanho da string)
# retorno:
#   nao retorna nada
#######################################
# MAPA DE REGISTRADORES
# $t0 - i
# $t1 - endereco de str[i]
# $t2 - str[i]
# $t3 - '@'
# $t5 - i<(tam-1)
# $t6 - tam-1
# $t7 - 1
#######################################
# PROCEDIMENTO FOLHA, NAO REQUER AJUSTES EM $ra
#######################################
inicia_string:
    inicia_string_inicio_for:
        li      $t0, 0                      # int i = 0
        addiu   $t6, $a1, -1                # $t6 <- tam-1
        j       inicia_string_condicao_for        

    inicia_string_codigo_for:
        add     $t1, $a0, $t0               # $t1 = (*str) + offset
        la      $t2, 0($t1)                 # str[i]
        li      $t3, '@'                    # $t7 <- '@'
        sb      $t3, 0($t2)                 # str[i] = '@'
        addiu   $t0, $t0, 1                 # i++

    inicia_string_condicao_for:
        li      $t7, 1                      # $t7 <- 1
        slt     $t5, $t0, $t6               # $t5=1 se 1<(tam-1)
        beq     $t5, $t7, inicia_string_codigo_for
                                            # ($t5==$t7)

    inicia_string_fim_for:
    sb      $zero, 0($t2)                     # str[i] = '\0'
    jr      $ra


#######################################
# printa a string str, caso espaco seja true (1) vai adicionar um espaco
# entre os caracteres.
# argumentos:
#   $a0 - str (string a ser printada)
#   $a1 - espaco (flag para saber se vai ou nao printar um espaco)
# retorno:
#   nao retorna nada
#######################################
# MAPA DE REGISTRADORES
# $t0 - *str
# $t1 - i
# $t2 - endereco de str[i]
# $t3 - str[i]
# $t4 - '\0'
# $t5 - 1
# $v0 - servico usado no syscall
# $a0 - char que sera usado no syscall
#######################################
# PROCEDIMENTO FOLHA, NAO REQUER AJUSTES EM $ra
#######################################
printa_string:
    la      $t0, ($a0)                      # $t0 <- *str
    li      $t1, 0                          # int i = 0

    printa_string_while_inicio:    
        j       printa_string_while_condicao

    printa_string_while_codigo:
        li      $v0, SERVICO_IMPRIME_CARACTERE
        la      $a0, ($t3)
        syscall                             # printf("%c", str[i])
        
        printa_string_if_condicao:
            li      $t5, 1                  # $t5 <- 1
            bne     $a1, $t5, printa_string_if_fim        
                                            # if(space==1)

        printa_string_if_codigo:
            li      $v0, SERVICO_IMPRIME_CARACTERE
            li      $a0, ' '
            syscall                         # printf(" ")     

        printa_string_if_fim:
        addiu   $t1, $t1, 1                 # i++

    printa_string_while_condicao:
        add     $t2, $t0, $t1               # $t2 = (*str) + i
        lbu     $t3, 0($t2)                 # str[i]
        bne		$t3, $zero, printa_string_while_codigo	    
                                            # while(str[i] != '\0')

    printa_string_while_fim:
    li      $v0, SERVICO_IMPRIME_CARACTERE
    li      $a0, '\n'
    syscall                                 # printf("\n")
    jr      $ra


#######################################
# retorna o tamanho da string nao incluindo o caractere de fim de linha e '@' 
# argumentos:
#   $a0 - str (string a ser inicializada)
# retorno:
#   $v0 - tamanho
#######################################
# MAPA DE REGISTRADORES
# $t0 - i
# $t1 - tam
# $t2 - endereco de str[i]
# $t3 - str[i]
# $t4 - '\0'
# $t5 - '@'
#######################################
# PROCEDIMENTO FOLHA, NAO REQUER AJUSTES EM $ra
#######################################
tamanho_string:
    li      $t0, 0                          # int i = 0
    li      $t1, 0                          # int tam = 0  

    tamanho_string_while_inicio:    
        j       tamanho_string_while_condicao

    tamanho_string_while_codigo:
        tamanho_string_if_condicao:
            li      $t5, '@'                # $t5 <- '@'
            beq     $t3, $t5, tamanho_string_if_fim        
                                            # if(str[i]!='@')

        tamanho_string_if_codigo:
            addiu $t1, $t1, 1               # tam++                 

        tamanho_string_if_fim:
        addiu   $t0, $t0, 1                 # i++

    tamanho_string_while_condicao:
        add     $t2, $a0, $t0               # $t2 = (*str) + i
        lbu     $t3, 0($t2)                 # str[i]
        bne		$t3, $zero, tamanho_string_while_codigo	    
                                            # while(str[i] != '\0')

    tamanho_string_while_fim:
    la      $v0, ($t1)                      # return tam
    jr      $ra


#######################################
# copia a segunda string para a primeira. nao utilizar quando alvo<origem
# argumentos:
#   $a0 - alvo
#   $a1 - origem
# retorno:
#   nao retorna nada
#######################################
# MAPA DE REGISTRADORES
# $t0 - i
# $t1 - endereco de origem[i]
# $t2 - origem[i]
# $t3 - endereco de alvo[i]
#######################################
# PROCEDIMENTO FOLHA, NAO REQUER AJUSTES EM $ra
#######################################
copia_string:
    li      $t0, 0                          # int i = 0

    copia_string_while_inicio:    
        j       copia_string_while_condicao

    copia_string_while_codigo:
        add     $t3, $a0, $t0               # $t3 = (*alvo) + i
        sb      $t2, 0($t3)                 # alvo[i] = origem[i]
        addiu   $t0, $t0, 1                 # i++

    copia_string_while_condicao:
        add     $t1, $a1, $t0               # $t1 = (*origem) + i
        lbu     $t2, 0($t1)                 # origem[i]
        bne		$t2, $zero, copia_string_while_codigo	    
                                            # while(origem[i] != '\0')

    copia_string_while_fim:
    add     $t3, $a0, $t0                   # $t3 = (*alvo) + i
    sb      $t4, 0($t3)                     # alvo[i] = '\0'
    jr      $ra
    

#######################################
# remove o caractere '\n' e o substitui por '\0' 
# argumentos:
#   $a0 - *str
# retorno:
#   nao retorna nada
#######################################
# $t0 - i
# $t1 - tam
# $t2 - endereco de str[i]
# $t3 - str[i]
# $t4 - '\n'
#######################################
# PROCEDIMENTO FOLHA, NAO REQUER AJUSTES EM $ra
#######################################
remove_fim_de_linha:
    li      $t0, 0                          # int i = 0

    fim_linha_while_inicio:    
        j       fim_linha_while_condicao

    fim_linha_while_codigo:
        fim_linha_if_condicao:
            li      $t4, '\n'               # $t4 <- '\n'
            bne     $t3, $t4, fim_linha_if_fim        
                                            # if(str[i]=='\n')

        fim_linha_if_codigo:
            sb      $zero, 0($t2)           # str[i]='\0'

        fim_linha_if_fim:
        addiu   $t0, $t0, 1                 # i++

    fim_linha_while_condicao:
        add     $t2, $a0, $t0               # $t2 = (*str) + i
        lbu     $t3, 0($t2)                 # str[i]
        bne		$t3, $zero, fim_linha_while_codigo	    
                                            # while(str[i] != '\0')

    fim_linha_while_fim:
    jr      $ra


#######################################
# remove o caractere '\n' e o substitui por '\0' 
# argumentos:
#   $a0 - *buffer
#   $a1 - tamanho
# retorno:
#   nao retorna nada
#######################################
# $a0 - string utilizada no syscall
# $v0 - codigo do syscall
#######################################
# MAPA DE MEMORIA
# | $ra     |           $sp+4
# | *buffer |           $sp+0
#######################################
le_entrada:
    # == prologo ==
    addiu   $sp, $sp, -8                    # aloca 8 bytes na pilha
    sw      $ra, 4($sp)                     # guarda end de retorno
    sw      $a0, 0($sp)                     # guarda end do *buffer

    # == corpo ==
    li      $v0, SERVICO_IMPRIME_STRING
    la      $a0, leitura_01
    syscall                                 # printf("Chute: ")
    lw      $a0, 0($sp)                     # carrega *buffer para $a0
    li      $v0, SERVICO_LE_STRING
    syscall                                 # fgets(*buffer, tamanho, stdin)
    
    # $a0 ja contem a string
    jal     remove_fim_de_linha
    # $ax = ??? $tx = ???

    # == epilogo ==
    lw      $ra, 4($sp)                     # carrega o end de retorno
    addiu   $sp, $sp, 8                     # retira 8 bytes da pilha
    jr      $ra


#######################################
# checa se a letra do chute esta contida nos acertos ou erros.
# retorna 1 se for repetida 
# argumentos:
#   $a0 - *chute
#   $a1 - *acertos
#   $a2 - *erros
# retorno:
#   $v0 - flag
#######################################
# $t0 - i
# $t1 - end de erros[i] / end de acertos[i]
# $t2 - erros[i] / acertos[i]
# $t3 - chute[0]
#######################################
# PROCEDIMENTO FOLHA, NAO REQUER AJUSTES EM $ra
#######################################
letra_repetida:
    li      $t0, 0                          # int i = 0
    li      $v0, 0                          # int flag = 0
    lbu     $t3, 0($a0)                     # $t3 <- chute[0]

    # procura se a letra ja esta nos erros
    repetida_while_erros_inicio:
    j   repetida_while_erros_condicao

    repetida_while_erros_codigo:

        repetida_if_erros_condicao:
            bne     $t3, $t2, repetida_if_erros_fim
                                            # if(erros[i]==chute[0])

        # se for repetida retorna do procedimento
        repetida_if_erros_codigo:
            addiu   $v0, $v0, 1             # flag=1
            j       repetida_while_acertos_fim
                                            # return flag

        repetida_if_erros_fim:
        addiu   $t0, $t0, 1                 # i++

    repetida_while_erros_condicao:
        add     $t1, $a2, $t0               # $t1 = (*erros) + i
        lbu     $t2, 0($t1)                 # erros[i]
        bne		$t2, $zero, repetida_while_erros_codigo
                                            # while(erros[i]!='\0')

    repetida_while_erros_fim:
    li      $t0, 0                          # i = 0


    # procura se a letra ja esta nos acertos
    repetida_while_acertos_inicio:
        j   repetida_while_acertos_condicao        

    repetida_while_acertos_codigo:

        repetida_if_acertos_condicao:
            bne     $t3, $t2, repetida_if_acertos_fim
                                            # if(acertos[i]==chute[0])

        # se for repetida retorna do procedimento
        repetida_if_acertos_codigo:
            addiu   $v0, $v0, 1             # flag=1
            j       repetida_while_acertos_fim
                                            # return flag

        repetida_if_acertos_fim:
        addiu   $t0, $t0, 1                 # i++

    repetida_while_acertos_condicao:
        add     $t1, $a1, $t0               # $t1 = (*acertos) + i
        lbu     $t2, 0($t1)                 # acertos[i]
        bne		$t2, $zero, repetida_while_acertos_codigo
                                            # while(acertos[i]!='\0')

    repetida_while_acertos_fim:
    jr     $ra


#######################################
# testa se a letra do chute existe na palavra, retorna 1 se existir.
# caso exista, adiciona a letra em acertos. 
# argumentos:
#   $a0 - *chute
#   $a1 - *palavra
#   $a2 - *acertos
# retorno:
#   $v0 - flag
#######################################
# $t0 - i
# $t1 - end de palavra[i]
# $t2 - palavra[i]
# $t3 - chute[0]
# $t4 - end de acertos[i]
#######################################
# PROCEDIMENTO FOLHA, NAO REQUER AJUSTES EM $ra
#######################################
letra_certa:
    li      $t0, 0                          # int i = 0
    li      $v0, 0                          # int flag = 0
    lbu     $t3, 0($a0)                     # $t3 <- chute[0]

    certa_while_inicio:
    j       certa_while_condicao

    certa_while_codigo:

        certa_if_condicao:
            bne     $t3, $t2, certa_if_fim
                                            # if(palavra[i]==chute[0])

        certa_if_codigo:
            addiu   $v0, $v0, 1             # flag=1
            add     $t4, $a2, $t0           # $t4 = (*acertos) + i
            sb      $t3, ($t4)              # acertos[i] = chute[0]

        certa_if_fim:
        addiu   $t0, $t0, 1                 # i++

    certa_while_condicao:
        add     $t1, $a1, $t0               # $t1 = (*palavra) + i
        lbu     $t2, 0($t1)                 # palavra[i]
        bne		$t2, $zero, certa_while_codigo
                                            # while(palavra[i]!='\0')

    certa_while_fim:
    jr      $ra


#######################################
# verifica se os acertos correspondem a palavra. 
# retorna true (1) quando vencedor.
# argumentos:
#   $a0 - *palavra
#   $a1 - *acertos
# retorno:
#   $v0 - flag
#######################################
# $t0 - i
# $t1 - end de palavra[i]
# $t2 - palavra[i]
# $t3 - end de acertos[i]
# $t4 - acertos[i]
# $t5 - retorno de tamanho_string(palavra)
# $t6 - retorno de tamanho_string(acertos)
#######################################
# MAPA DA MEMORIA
# | $ra |               $sp+0
# | $a0 |               $sp+4
# | $a1 |               $sp+8
# | $t5 |               $sp+12
#######################################
vencedor:
    # == prologo ==
    addiu   $sp, $sp, -16                   # aloca 16 bytes na pilha
    sw      $ra, 0($sp)                     # guarda end de retorno
    sw      $a0, 4($sp)                     # guarda end de palavra
    sw      $a1, 8($sp)                     # guarda end de acertos

    # == corpo ==   
    vencedor_if_tamanho_condicao:
        jal     tamanho_string              # tamanho_string(palavra)
        # $ax = ???  $tx = ???
        la      $t5, ($v0)                  # t1 = tamanho_string(palavra)
        sw      $t5, 12($sp)                # guarda retorno da func

        lw      $a1, 8($sp)                 # carrega end de acertos
        la      $a0, ($a1)
        jal     tamanho_string              # tamanho_string(acertos)
        # $ax = ???  $tx = ???
        la      $t6, ($v0)                  # t2 = tamanho_string(acertos)

        lw      $t5, 12($sp)                # carrega retorno da 1a chamada
        beq     $t5, $t6, vencedor_if_tamanho_fim
                                            # if(t1!=t2)

    vencedor_if_tamanho_codigo:
        li      $v0, 0                      # flag = 0
        j       vencedor_while_fim

    vencedor_if_tamanho_fim:
    lw      $a0, 4($sp)                     # carrega *palavra em $a0
    lw      $a1, 8($sp)                     # carrega *acertos em $a1
    li      $t0, 0                          # int i = 0

    vencedor_while_inicio:
    j       vencedor_while_condicao

    vencedor_while_codigo:

        vencedor_if_condicao:
            add     $t3, $a1, $t0           # $t3 = (*acertos) + i
            lbu     $t4, 0($t3)             # acertos[i]
            beq     $t4, $t2, vencedor_if_fim
                                            # if(palavra[i]!=chute[0])

        vencedor_if_codigo:
            li      $v0, 0                  # flag = 0
            j       vencedor_while_fim

        vencedor_if_fim:
        li      $v0, 1                      # flag = 1
        addiu   $t0, $t0, 1                 # i++

    vencedor_while_condicao:
        add     $t1, $a0, $t0               # $t1 = (*palavra) + i
        lbu     $t2, 0($t1)                 # palavra[i]
        bne		$t2, $zero, vencedor_while_codigo
                                            # while(palavra[i]!='\0')

    vencedor_while_fim:

    # == epilogo ==
    lw      $ra, 0($sp)                     # carrega end de retorno
    addiu   $sp, $sp, 12                    # libera 16 bytes da pilha
    jr      $ra

