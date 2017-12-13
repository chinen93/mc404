@ Pedro Hideaki Uiechi Chinen
@ 175828

        KEY_DATA  .equ 0x80     @ Porta de Data do teclado
        KEY_STATE .equ 0x81     @ Porta de Estado do teclado
        LEDS .equ 0x40          @ Porta dos LEDS
	
        .org 0x1000             @ Posicao da pilha
        .skip 12                @ Guarda 12 bytes = 3 palavras na pilha
inicio_pilha:
	
multiplica:
        set r0, 0x0             @ Retorno da soma 0
        ld r1, [sp+4]           @ Pega primeiro parametro
        ld r2, [sp+8]           @ Pega segundo parametro

        cmp r1, 0x0             @ Se um for 0 retorna 0
        jz fim_mult

        cmp r2, 0x0             @ Se um for 0 retorna 0
        jz fim_mult

        cmp r1, r2              @ Coloca em r2 o menor valor
        jge loop_mult

troca_mult:
        mov r3, r2              @ Mov r2 pra auxiliar
        mov r2, r1              @ Troca r2 e r1
        mov r1, r3              @ Troca r1 e auxiliar

loop_mult:
        add r0, r1              @ Soma em r0, o valor de r1
        sub r2, 0x1             @ Subtrai 1 em r2

        cmp r2, 0x0             @ Compara r2 com 0
        jz fim_mult

        jmp loop_mult           @ volta para o loop da multiplicacao

fim_mult:
        ret                     @ Fim da Multiplicao

read:
        in r1, KEY_STATE        @ Carrega estado do teclado
        cmp r1, 1               @ Digitou 1 valor?
        jnz read                @ Nao, espera 1 valor
        in r0, KEY_DATA         @ Pega 1 valor
        shl r0, 4               @ Deixar 1 valor como mais significativo

seg_input:
        in r1, KEY_STATE        @ Carrega estado do teclado
        cmp r1, 1               @ Digitou 2 valor?
        jnz seg_input           @ Nao, espera 2 valor
        in r1, KEY_DATA         @ Pega 2 valor
        add r0, r1              @ Adiciona 2 valor deixando como o menos significativo

ter_input:
        in r1, KEY_STATE        @ Carrega estado do teclado
        cmp r1, 1               @ Digitou 3 valor?
        jnz ter_input           @ Nao, espera 3 valor
        in r1, KEY_DATA         @ Pega 3 valor
        ret                     @ Retorno da Funcao

init:
        set sp, inicio_pilha    @ Inicia o endereco pilha
        set r2, 0x1             @ Valor inicial da multiplicacao
        out LEDS, r2            @ Atualiza LEDS

loop_prog:
        call read               @ Pega os valores do teclado
        mov r4, r1              @ Salva em registrador a operacao digitada
        push r2                 @ Passa o valor corrente como parametro
        push r0                 @ Passa o valor digitado como parametro
        call multiplica         @ Realiza a multiplicacao
        mov r2, r0              @ Atualiza valor corrente
        out LEDS, r2            @ Atualiza o LEDS
        cmp r4, 0xa             @ Continuar Multiplicando?
        jz loop_prog            @ Continua

fim_programa:
        hlt                     @ Termino Programa
