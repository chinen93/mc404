@ Tarefa 06
@ Pedro H Chinen
@ RA: 175828

        .org 0x60000
        .skip 16                @ alguns parametros serao empilhados
inicio_pilha:   
        
        .org  0x2000    
inicio_vetor:
        .skip 256               @ vetor a ser transformado
        
init:
        set sp, inicio_pilha    @ Inicializa a pilha
        set r10, 0              @ Inicializar o contador de letras transformadas
        
read:
        set r0, 0               @ Inicializar a quantidade lida
        set r1, inicio_vetor    @ Guarda em r1 o inicio do vetor a ser lido
        set r2, 256             @ Quantidade de valores a serem lidas
        set r7, 3               @ Tipo READ

        sys 0x55                @ Chama interrupcao para READ

        
        set r9, 0               @ Inicializa contador de posicoes
        
loop:
        ldb r3, [r1]            @ Carrega valor na posicao atual
        cmp r3, 0x61            @ Compara com 'a'
        jl next                 @ Menor, vai pra proxima iteracao
        cmp r3, 0x7A            @ Compara com 'z'
        jg next                 @ Maior, vai pra proxima iteracao 

        sub r3, 0x20            @ Transforma em maiscula
        stb [r1], r3            @ Salva valor transformado
        add r10, 1              @ Soma em contador de letras transformadas
        
next:
        add r1, 1               @ Anda uma posicao no vetor escrito
        add r9, 1               @ Mostra que andou uma posicao
        
        cmp r9, r0              @ Compara com a quantidade lida
        jz write                @ terminou, vai escreve

        jmp loop                @ ainda nao terminou, volta para o loop
        
        
write:
        set r1, inicio_vetor    @ Guarda em r1 o inicio do vetor a ser lido     
        mov r2, r0              @ Quantidade de valores a serem escritas
        set r0, 1               
        set r7, 4               @ Tipo WRITE

        sys 0x55                @ Chama interrupcao para WRITE

exit:
        set r0, 0               @ Programa terminou sem problemas                       
        set r7, 1               @ Tipo EXIT

        sys 0x55                @ Chama interrupcao para EXIT
