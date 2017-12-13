@ Pedro Hideaki Uiechi Chinen
@ 175828
        
        .org 0x1000
@ *********
@ addr64
@ *********
addr64:
        ld r0, [sp+4]   @ menos sig valor 1
        ld r1, [sp+8]   @ mais  sig valor 1
        
        ld r2, [sp+12]  @ menos sig valor 2
        ld r3, [sp+16]  @ mais  sig valor 2

addMenosSig:    
        add r0, r2      @ adiciona os valores menos sig 
        jnc addMaisSig  @ se não der overflow adiciona os mais

        add r1, 0x1     @ houve overflow, soma 1 em um dos mais sig
addMaisSig:
        add r1, r3      @ adiciona os valores mais sig
        ret             @ retorno funcao addr64

        .org 0x100
n_elem:
        .skip 4         @ pula 1 byte
vetor:
        .skip 800       @ pula 800 bytes, tamanho vetor
        
        .org 0x2000
init:
        set r1, 0x0     @ parte mais significativa do resultado
        set r0, 0x0     @ parte menos significativa do resultado
        set sp, 0x8000  @ apontador para o topo da pilha
        ld  r5, n_elem  @ guarda a quantidade de elementos
        set r6, vetor   @ posicao do inicio do vetor

loop:
        ld r7, [r6]     @ menos sig valor 2
        ld r8, [r6+4]   @ mais  sig valor 2

        push r1         @ empilha mais  sig valor 1
        push r0         @ empilha menos sig valor 1

        push r8         @ empilha mais  sig valor 2
        push r7         @ empilha menos sig valor 2


        call addr64     @ chama funcao addr64 com os parametros empilhados
        
        cmp r5, 0x0     @ se num_elem acabou
        jz fim          @ ir para o final do programa

        sub r5, 0x1     @ diminui o numero de elementos a somar
        add r6, 8       @ anda com a posicao no vetor
        add sp, 16      @ retornar o inicio da pilha pra posicao inicial
        jmp loop        @ volta no loop

fim:
        hlt             @ final do programa
        
        
