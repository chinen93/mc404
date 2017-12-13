@ Pedro Hideaki Uiechi Chinen
@ 175828

@ Entrada: ABCDEF1234
@ Saida  : 4321FEDCBA


        .org 0x1000             @ Inicia na posicao 0x1000
string_beg:                     @ Rotulo para inicio do vetor

	.skip 16               @ Reservando o espaco do vetor
string_end:                     @ Rotulo para o final do vetor
        set r7, string_end

start:                          @ Inicio do Programa
        set r0, string_beg      @ Inicializa os registradores
        mov r1, r0              @ usados na troca das letras

find:                           @ Achar o final do vetor
        cmp r1, r7              @ Compara se final do vetor esperado
        jz end                  @ Se igual, pula final do programa
        
        ldb r2, [r1]            @ Carrega informacao da mem para reg

        cmp r2, 0x00            @ Compara com o end final de vetor
        jz adjust_to_switch     @ Se igual, pula para troca

        add r1, 0x01            @ Andar uma posicao no vetor
        jmp find                @ Tenta achar final do vetor novamente

adjust_to_switch:               @ Ajusta para fazer a troca
        sub r1, 0x01            @ Volta uma posicao no vetor
        jmp switch              @ executa a troca dos registradores
        
switch:                         @ Loop para troca dos registradores
        ldb r2, [r0]            @ Carrega valor do reg 0
        ldb r3, [r1]            @ Carrega valor do reg 1

        stb [r0], r3            @ Guarda valor de reg 1 em reg 0
        stb [r1], r2            @ Guarda valor de reg 0 em reg 1

        add r0, 0x01            @ Anda pra frente com reg 0
        sub r1, 0x01            @ Anda pra tras com reg 1

        cmp r0, r1              @ Compara reg 0 e reg 1
        jge end                 @ Se reg 0 > reg 1, pula final prog

        jmp switch              @ Continua trocando as posicoes

end:                            @ Rotulo para finalizar o programa
        hlt                     @ Termina o Programa
