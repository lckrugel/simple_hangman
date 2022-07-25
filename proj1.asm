

.data
intro_00:   .asciiz "==== Jogo da Forca ====\n"
intro_01:   .asciiz "Digite letras ou palavras para jogar. Você tera 5 vidas para acertar.\n"
intro_02:   .asciiz "Chutar uma palavra significa fim do jogo. Chute apenas quando tiver certeza.\n"
intro_03:   .asciiz "Utilize apenas letras minusculas.\n"
intro_04:   .asciiz "=======================\n"

palavra:    .asciiz "academico"
chute:      .space 30
acertos:    .space 21
erros:      .space 6




.text

.eqv SERVICO_IMPRIME_STRING 4            # DEFINE para printf("%s")
.eqv SERVICO_IMPRIME_CARACTERE 11        # DEFINE para printf("%c")
.eqv SERVICO_LE_STRING 8                 # DEFINE para fgets()
.eqv SERVICO_SAIDA 17                    # DEFINE para exit2()

.globl main


#######################################
# MAPA DE REGISTRADORES
# $t0 - palavra
# $t1 - 0
#######################################
# MAPA DA MEMORIA
# | $ra | $sp + 8
# | chutes_errados | $sp + 4
# | vidas | sp + 0
#######################################
main:
    #== prologo ==
    addiu   $sp, $sp, -12
    sw      $ra, 8($sp)

    #== corpo ==
    jal     tela_inicial


    # inicia string
    la      $s0, chute
    addiu   $t0, $zero, 30
    la      $a0, ($s0)
    la      $a1, ($t0)
    jal     inicia_string

    # copia palavra em chute
    la      $s1, palavra
    la      $a0, ($s0)
    la      $a1, ($s1)
    jal     copia_string
    
    # printa string
    la      $s0, chute
    addiu   $t1, $zero, 1
    la      $a0, ($s0)
    la      $a1, ($t1)
    jal     printa_string

    # tamanho string e printa
    #la      $s1, palavra
    #la      $a0, ($s1)
    #jal     tamanho_string
    #la      $a0, ($v0)
    #li      $v0, 1
    #syscall
        

    #== epilogo ==
    lw      $ra, 8($sp)
    addiu   $sp, $sp, 12
    li      $v0, SERVICO_SAIDA
    li      $a0, 0
    syscall


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
        li      $t4, '\0'                   # $t4 <- '\0'
        bne		$t3, $t4, printa_string_while_codigo	    
                                            # while(str[i] != '\0')

    printa_string_while_fim:
    li      $v0, SERVICO_IMPRIME_CARACTERE
    li      $a0, '\n'
    syscall                                 # printf("\n")
    jr      $ra


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
# $t4 - '\0'
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
    li      $t4, '\0'
    sb      $t4, 0($t2)                     # str[i] = '\0'
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
        li      $t4, '\0'                   # $t4 <- '\0'
        bne		$t3, $t4, tamanho_string_while_codigo	    
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
# $t4 - '\0'
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
        li      $t4, '\0'                   # $t4 <- '\0'
        bne		$t2, $t4, copia_string_while_codigo	    
                                            # while(origem[i] != '\0')

    copia_string_while_fim:
    add     $t3, $a0, $t0                   # $t3 = (*alvo) + i
    sb      $t4, 0($t3)                     # alvo[i] = '\0'
    jr      $ra
    
