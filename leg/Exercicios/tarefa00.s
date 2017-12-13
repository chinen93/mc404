@ Pedro Hideaki Uiechi Chinen
@ 175828

@ Codificar essa instrucao: 4*(0x5000 + 0x200)
@ Usando apenas os registradores: r0, r1

	.org 0x200		@ Iniciar programa na posicao 0x200
start: 	     	     		@ Rotulo para o inicio do programa
	set r0, 0x200		@ Setar valores no registrador 0
	set r1, 0x5000		@ Setar valores no registrador 1

	add r0, r1		@ Soma os valores 0x5000 e 0x200
	add r0, r0		@ Soma os valores 0x5200 e 0x5200
	add r0, r0		@ Soma os valores 0x10400 e 0x10400
	    			@ O que eh a mesma coisa que 4*(0x5000 + 0x200)

	hlt 			@ Termina o programa
