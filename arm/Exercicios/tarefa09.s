@ Pedro Hideaki Uiechi Chinen
@ 175828
@ Tarefa 09 - Semaforo

        .global _start
        .org 0x1000

        @ Constante de Cor
        .set VERM, 0x04 @ 00000100
        .set AMAR, 0x02 @ 00000010
        .set VERD, 0x01 @ 00000001
        
        @ Enderecos dos devices
        .set ADDRLED01,0x90000
        .set ADDRLED02,0x90001
        .set ADDRTECLA, 0xa0000
        
_start:
        
        mov r0, #0              @ r0: o estados dos semaforos
        ldr r1, =ADDRLED01      @ r1: o Semaforo 01
        ldr r2, =ADDRLED02      @ r2: o Semaforo 02
        ldr r3, =ADDRTECLA      @ r3: a Tecla que muda o estado

estado00:
        ldr r4, =VERD           @ r4: os leds a serem acessos de r1
        ldr r5, =VERM           @ r5: os leds a serem acessos de r2
        
        str r1, [r4]            @ acende os leds do semaforo 01
        str r2, [r5]            @ acende os leds do semaforo 02

estado00_loop:
        ldr r6, [r3]            @ r6: estado da tecla
        cmp r6, 1               @ tecla foi pressionada?
        bne estado00_loop       @ nem foi, retorna loop

estado01:
        ldr r4, =AMAR           @ r4: os leds a serem acessos de r1
        ldr r5, =AMAR           @ r5: os leds a serem acessos de r2

        str r1, [r4]            @ acende os leds do semaforo 01
        str r2, [r5]            @ acende os leds do semaforo 02
        
estado01_loop:
        ldr r6, [r3]            @ r6: estado da tecla
        cmp r6, 1               @ tecla foi pressionada?
        bne estado01_loop       @ nem foi, retorna loop


estado02:
        ldr r4, =VERM           @ r4: os leds a serem acessos de r1
        ldr r5, =VERD           @ r5: os leds a serem acessos de r2

        str r1, [r4]            @ acende os leds do semaforo 01
        str r2, [r5]            @ acende os leds do semaforo 02
        
estado02_loop:
        ldr r6, [r3]            @ r6: estado da tecla
        cmp r6, 1               @ tecla foi pressionada?
        bne estado02_loop       @ nem foi, retorna loop

estado03:
        ldr r4, =AMAR           @ r4: os leds a serem acessos de r1
        ldr r5, =AMAR           @ r5: os leds a serem acessos de r2

        str r1, [r4]            @ acende os leds do semaforo 01
        str r2, [r5]            @ acende os leds do semaforo 02
        
estado03_loop:
        ldr r6, [r3]            @ r6: estado da tecla
        cmp r6, 1               @ tecla foi pressionada?
        bne estado03_loop       @ nem foi, retorna loop

        b estado00              @ volta para o primeiro estado
