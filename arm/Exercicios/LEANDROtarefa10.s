  @ MC404 -- Tarefa 10 -- Semáforos com temporizador
  @ Leandro H. Ribeiro
  @ RA: 171845
  @ Turma B

  .global _start

  // CPSR = 00010000 = 0x10
  // processador no modo usuario, FIQ e IRQ habilitadas, modo arm
  .equ MODO, 0b10010000

  // constantes com as cores
  .equ RED, 0x04                @ 0x04 = 00000100
  .equ YELLOW, 0x02             @ 0x02 = 00000010
  .equ GREEN, 0x01              @ 0x01 = 00000001

  // portas do semaforo1 e do painel1
  .equ SEMAFORO1, 0x90000
  .equ PAINEL1_MSB, 0x90011
  .equ PAINEL1_LSB, 0x90010

  // portas do semaforo2 e do painel2
  .equ SEMAFORO2, 0x90001
  .equ PAINEL2_MSB, 0x90021
  .equ PAINEL2_LSB, 0x90020

  // portas do contador
  .equ TIMER, 0x90030

  // vetor de interrupcoes
vetor_interrupcoes:
  // trata a interrupcao FIQ
  .org 7*0x4
trata_fiq:
  // atualiza quantidade de interrupcoes
  add r7, #0x1
  // retorno da interrupcao FIQ
  // restaura o registrador de estado do processador
  // e volta para a posicao de memoria anterior a interrupcao
  movs pc,lr

  .org 0x1000
  // vetor com os digitos do painel de 7 segmentos
digitos:
  .byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f
  .align 2

altera_valor_painel:
  // se tiver 10 ou menos interrupcoes,
  // MSB = 2
  // LSB = 10 - numero interrupcoes
DezOuMenos:
  cmp r7, #0xa
  bhi VinteOuMenos              @ se houver mais de 10 interrupcoes

  ldr r2, =digitos              @ pega o endereco do digito 0
  add r2, #2                    @ pega o endereco do digito 2
  ldr r1, [r2]                  @ pega o valor do digito 2
  ldr r0, =PAINEL1_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel

  mov r5, #0xa                  @ r5 recebe o valor 10
  sub r5, r7                    @ r5 recebe o valor  10 - num de interrupcoes
  ldr r2, =digitos              @ pega o endereco do digito 0
  add r2, r5                    @ pega o endereco do (10 - num de interrupcoes)
  ldr r1, [r2]                  @ pega o valor do digito
  ldr r0, =PAINEL1_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel

  b Retorno

VinteOuMenos:
  cmp r7, #0x14
  bhi TrintaOuMenos             @ se houver mais de 20 interrupcoes

  ldr r2, =digitos              @ pega o endereco do digito 0
  add r2, #1                    @ pega o endereco do digito 1
  ldr r1, [r2]                  @ pega o valor do digito 2
  ldr r0, =PAINEL1_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel

  mov r5, #0x14                 @ r5 recebe o valor 20
  sub r5, r7                    @ r5 recebe o valor  20 - num de interrupcoes
  ldr r2, =digitos              @ pega o endereco do digito 0
  add r2, r5                    @ pega o endereco do (20 - num de interrupcoes)
  ldr r1, [r2]                  @ pega o valor do digito
  ldr r0, =PAINEL1_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel

  b Retorno

TrintaOuMenos:
  cmp r7, #0x1e
  bhi Retorno                   @ se houver mais de 30 interrupcoes

  ldr r2, =digitos              @ pega o endereco do digito 0
  ldr r1, [r2]                  @ pega o valor do digito 0
  ldr r0, =PAINEL1_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel

  mov r5, #0x1e                 @ r5 recebe o valor 30
  sub r5, r7                    @ r5 recebe o valor  30 - num de interrupcoes
  ldr r2, =digitos              @ pega o endereco do digito 0
  add r2, r5                    @ pega o endereco do (30 - num de interrupcoes)
  ldr r1, [r2]                  @ pega o valor do digito
  ldr r0, =PAINEL1_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel

Retorno:
  bx lr                         @ retorno da funcao


  /* ~Inicio do Programa~ */
_start:

  // processador no modo usuario, FIQ e IRQ habilitadas
  mov r0, #MODO
  msr cpsr, r0

  // temporizador: gera interrupcoes a cada 1000ms
  ldr r0, =TIMER
  mov r1, #1000
  str r1, [r0]

  // Estado 1
state1:
  // 1o semaforo verde, 2o semaforo vermelho
  ldr r0, =GREEN                @ r0 recebe o valor da cor verde
  ldr r1, =SEMAFORO1            @ r1 recebe o endereco do 1o semaforo
  str r0, [r1]                  @ altera a cor do 1o semaforo para verde
  ldr r0, =RED                  @ r0 recebe o valor da cor vermelha
  ldr r1, =SEMAFORO2            @ r1 recebe o endereco do 2o semaforo
  str r0, [r1]                  @ altera a cor do 2o semaforo para vermelho
  // paineis com o valor 30
  ldr r2, =digitos              @ pega o endereco do digito 0
  ldr r1, [r2]                  @ pega o valor do digito 0
  ldr r0, =PAINEL1_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  add r2, #3                    @ pega o endereco do digito 3
  ldr r1, [r2]                  @ pega o valor do digito 3
  ldr r0, =PAINEL1_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  // prepara para o proximo estado
  mov r6, #1                   @ atualiza ultimo estado com o state1
  mov r7, #0                   @ zera o contador de interrupcoes

  // verifica se as interrupcoes ja comecaram
espera_interrupcao:
  cmp r7, #0x1
  blt espera_interrupcao

  // decresce o valor dos paineis
  // ate chegar no valor 5 (25 interrupcoes)
first_loop:
  bl altera_valor_painel        @ altera os valores dos paineis
  cmp r7, #0x19                 @ compara o numero de interrupcoes com 25
  blt first_loop                @ se for menor do que 25, continua no loop

  // Estado 2:
state2:
  // 1o semaforo amarelo, 2o semaforo amarelo
  ldr r0, =YELLOW               @ r0 recebe o valor da cor amarela
  ldr r1, =SEMAFORO1            @ r1 recebe o endereco do 1o semaforo
  str r0, [r1]                  @ altera a cor do 1o semaforo para amarelo
  ldr r1, =SEMAFORO2            @ r1 recebe o endereco do 2o semaforo
  str r0, [r1]                  @ altera a cor do 2o semaforo para amarelo

  // decresce o valor dos paineis
  // ate chegar no valor 0 (30 interrupcoes)
second_loop:
  bl altera_valor_painel        @ altera os valores dos paineis
  cmp r7, #0x1e                 @ compara o numero de interrupcoes com 30
  blt second_loop               @ se for menor do que 30, continua no loop

  // prepara para o proximo estado
  mov r7, #0                    @ zera o contador de interrupcoes

  // se o ultimo estado foi o state3, muda para o state1
  // se o ultimo estado foi o state1, muda para o state3
  cmp r6, #3                    @ verifica se o ultimo estado foi o state3
  beq state1                    @ se foi, muda para o state1

   // Estado 3:
state3:
  // 1o semaforo vermelho, 2o semaforo verde
  ldr r0, =RED                  @ r0 recebe o valor da cor vermelha
  ldr r1, =SEMAFORO1            @ r1 recebe o endereco do 1o semaforo
  str r0, [r1]                  @ altera a cor do 1o semaforo para vermelho
  ldr r0, =GREEN                @ r0 recebe o valor da cor verde
  ldr r1, =SEMAFORO2            @ r1 recebe o endereco do 2o semaforo
  str r0, [r1]                  @ altera a cor do 2o semaforo para verde
  // paineis em 30
  ldr r2, =digitos              @ pega o endereco do digito 0
  ldr r1, [r2]                  @ pega o valor do digito 0
  ldr r0, =PAINEL1_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_LSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  add r2, #3                    @ pega o endereco do digito 3
  ldr r1, [r2]                  @ pega o valor do digito 3
  ldr r0, =PAINEL1_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  ldr r0, =PAINEL2_MSB          @ salva endereco do painel
  str r1, [r0]                  @ coloca valor no painel
  //prepara para o proximo estado
  mov r6, #3                    @ atualiza ultimo estado com o state3
  mov r7, #0                    @ zera o contador de interrupcoes

  // verifica se as interrupcoes ja comecaram
espera_interrupcao2:
  cmp r7, #0x1                 @ compara o numero de interrupcoes com 1
  blt espera_interrupcao2      @ se for menor do que 1, continua no loop

  // decresce o valor dos paineis
  // ate chegar no valor 5 (25 interrupcoes)
third_loop:
  bl altera_valor_painel        @ altera os valores dos paineis
  cmp r7, #0x19                 @ compara o numero de interrupcoes com 25
  blt third_loop                @ se for menor do que 25, continua no loop
  b state2                      @ pula para o state2
