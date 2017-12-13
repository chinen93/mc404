@ Pedro Hideaki Uiechi Chinen
@ 175828
@ Tarefa 11 - Jogo da Memoria

	.global _start	
	
	@ Constante de Velocidade
	.equ SPEED1, #1
	.equ SPEED2, #2	
	.equ SPEED3, #3
	.equ SPEED4, #4
	.equ SPEED5, #5

	
	@ Constante de Tempo
	.equ TIMELIG, #2
	.equ TIMEDESLIG, #1
	.equ TIMERESP, #5
	.equ TIMEACERTO, #50
	.equ TIMEERRO, #100

	
        @ Constante de Cor
        .equ VERM, 0x04 @ 00000100
        .equ AMAR, 0x02 @ 00000010
        .equ VERD, 0x01 @ 00000001

	
	@ Enderecos dos devices
        .equ ADDRLED, 0x90000
	.equ ADDRTECLA, 0x90000
        .equ ADDRBOTAO, 0xa0000
	.equ ADDRSLIDER, 0xa0000
	.equ ADDRMOSTRADOR, 0xa0000

	
	@ Enderecos das Entradas/Saidas de Dados
	.equ DADOSTECLADO, 0x80
	.equ ESTADOTECLADO, 0x81
	
	.equ DADOSTIMER, 0x82
	
	.equ DADOSLED, 0x83
	
	.equ DADOSSLIDER, 0x84
	
	.equ DADOSRELOGIO ,0x85

	// CPSR = 00010000 = 0x10
	// processador no modo usuario, FIQ e IRQ habilitadas, modo arm
	.equ MODO, 0b10010000
	
	// Inicio do vetor eh em 0x000
	.org 0x000
vetor_interrupcoes:

	// 6 posicao trata das interrupcoes IRQ
//	.org 6*0x4
//interrupcao_irq:
//	movs pc, lr

	// 7 posicao trata interrupcoes FIQ
	.org 7*0x4
interrupcao_fiq:
	add r7, #0x1
	movs pc, lr

	
	
	.org 0x1000

digitos:
	.byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4f

_start:	
	mov r0, #0	@ r0: Fase do Jogo
	mov r1, #0	@ r1: Sequencia Jogada

	// processador no modo usuario, FIQ e IRQ habilitadas
	mov r0, #MODO
	msr cpsr, r0

	// temporizador: gera interrupcoes a cada 1000ms
	ldr r0, =TIMER
	mov r1, #1000	
	str r1, [r0]
