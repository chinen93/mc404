@ Pedro Hideaki Uiechi Chinen
@ 175828

        .org 0x100              @ Inicio do programa nesta posicao
divisor:                        @ Rotulo divisor
        .skip 4                 @ 32 bits / 8 bits = 4 bytes
num_elem:                       @ Rotulo numero de elementos
        .skip 4                 @ 32 bits / 8 bits = 4 bytes
vetor:                          @ Rotulo do inicio do vetor
        .skip 32                @ (16 elementos)(16 bits)/8 bits = 32 bytes

init:                           @ Rotulo de inicio do programa
        set r0, 0x0             @ r0 => soma = 0
        set r1, vetor           @ r1 => posicao = inicio vetor
        ld  r8, num_elem        @ r8 => numero de elementos

loop:                           @ Rotulo do loop
        ld r3, [r1]             @ r3 => carrega uma palavra, 2 elem
        mov r4, r3              @ copia palavra

        set r5, 0x0000ffff      @ cria um bitmask pro elem1
        and r3, r5              @ r3 = elem1

        set r5, 0xffff0000      @ cria bitmask pro elem2
        and r4, r5              @ valor como 0x000b0000
        shr r4, 16              @ anda 2 bytes pra direita r4 = elem2

        ld r6, divisor          @ r6 => carrega divisor

        cmp r6, 0x8             @ se divisor eh 8
        jz dividir_8            @ executa divisao por 8
        cmp r6, 0x4             @ se divisor eh 4
        jz dividir_4            @ executa divisao por 4
        cmp r6, 0x2             @ se divisor eh 2
        jz dividir_2            @ executa divisao por 2

soma:                           @ Rotulo da soma
        add r0, r3              @ soma = soma + elem1
        sub r8, 0x1             @ diminui o num de elementos

        cmp r8, 0x0             @ acabou o num de elementos
        jz fim                  @ vai para fim do programa

        add r0, r4              @ soma = soma + elem2
        sub r8, 0x1             @ diminui o num de elementos

        cmp r8, 0x0             @ acabou o num de elementos
        jz fim                  @ vai para fim do programa

        add r1, 4               @ Anda 4 bytes no vetor
        jmp loop                @ volta para o loop

dividir_8:                      @ Divisao por 8, 3 shifts
        shr r3, 1               @ shift direita 1 bit em r3
        shr r4, 1               @ shift direita 1 bit em r4
dividir_4:                      @ Divisao por 4, 2 shifts
        shr r3, 1               @ shift direita 1 bit em r3
        shr r4, 1               @ shift direita 1 bit em r4
dividir_2:                      @ Divisao por 2, 1 shift
        shr r3, 1               @ shift direita 1 bit em r3
        shr r4, 1               @ shift direita 1 bit em r4

        jmp soma                @ vai para a soma

fim:                            @ Rotulo de fim do programa
        hlt                     @ Termino programa
