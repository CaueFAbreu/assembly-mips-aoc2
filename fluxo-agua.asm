# Programa: Diagnostico de Redes (Sistema de Distribuicao de Agua)
# Descrição: Calcula x = B . f e realiza diagnostico de cada no
# Arquivo: fluxo-agua.asm

.data
    # Matriz B - Matriz de Incidencia (5 nos x 7 arestas) conforme PDF [cite: 134]
    matrizB: .word -1, -1,  0,  0,  0,  0,  0    # No 0
             .word  1,  0, -1, -1,  0,  0,  0    # No 1
             .word  0,  1,  1,  0, -1, -1,  0    # No 2
             .word  0,  0,  0,  1,  1,  0, -1    # No 3
             .word  0,  0,  0,  0,  0,  1,  1    # No 4
    
    # Vetor f - Fluxo das arestas (A0 ate A6) em L/s
    vetorF:  .word 100, 50, 80, 30, 80, 20, 10
    
    # Vetor x - Resultado do Balanço Liquido
    vetorX:  .word 0, 0, 0, 0, 0
    
    # Mensagens para o console [cite: 92, 93, 95]
    msg_titulo:    .asciiz "\n=== DIAGNOSTICO DE REDE DE AGUA ===\n"
    msg_no:        .asciiz "No "
    msg_valor:     .asciiz " = "
    msg_ls:        .asciiz " L/s  ->  "
    msg_fonte:     .asciiz "FONTE (Enviando)\n"
    msg_sumidouro: .asciiz "SUMIDOURO (Recebendo)\n"
    msg_equilibrio:.asciiz "PASSAGEM/EQUILIBRIO\n"

.text
.globl main

main:
    li      $t0, 0              # i = indice da linha (no)

loop_linha:
    bge     $t0, 5, imprimir_resultados
    
    li      $t1, 0              # j = indice da coluna (aresta)
    li      $t2, 0              # soma acumulada para x[i]

loop_coluna:
    bge     $t1, 7, salvar_x    # Processar as 7 arestas
    
    mul     $t3, $t0, 7         # offset: i * 7
    add     $t3, $t3, $t1       # + j
    sll     $t3, $t3, 2         # * 4 (bytes)
    
    la      $t4, matrizB
    add     $t4, $t4, $t3
    lw      $t5, 0($t4)         # B[i][j]
    
    sll     $t6, $t1, 2         # offset vetor f (j * 4)
    la      $t4, vetorF
    add     $t4, $t4, $t6
    lw      $t7, 0($t4)         # f[j]
    
    mul     $t8, $t5, $t7       # B[i][j] * f[j]
    add     $t2, $t2, $t8       # soma += t8
    
    addi    $t1, $t1, 1
    j       loop_coluna

salvar_x:
    sll     $t3, $t0, 2
    la      $t4, vetorX
    add     $t4, $t4, $t3
    sw      $t2, 0($t4)         # Salva resultado em vetorX[i]
    
    addi    $t0, $t0, 1
    j       loop_linha

imprimir_resultados:
    li      $v0, 4
    la      $a0, msg_titulo
    syscall
    
    li      $t0, 0              # i = 0

loop_diag:
    bge     $t0, 5, encerrar
    
    li      $v0, 4
    la      $a0, msg_no
    syscall
    
    li      $v0, 1
    move    $a0, $t0
    syscall
    
    li      $v0, 4
    la      $a0, msg_valor
    syscall
    
    sll     $t1, $t0, 2
    la      $t2, vetorX
    add     $t2, $t2, $t1
    lw      $t3, 0($t2)         # t3 = x[i]
    
    li      $v0, 1
    move    $a0, $t3
    syscall
    
    li      $v0, 4
    la      $a0, msg_ls
    syscall
    
    beq     $t3, $zero, eh_equilibrio
    bgtz    $t3, eh_sumidouro

eh_fonte:
    li      $v0, 4
    la      $a0, msg_fonte
    syscall
    j       prox_no

eh_sumidouro:
    li      $v0, 4
    la      $a0, msg_sumidouro
    syscall
    j       prox_no

eh_equilibrio:
    li      $v0, 4
    la      $a0, msg_equilibrio
    syscall

prox_no:
    addi    $t0, $t0, 1
    j       loop_diag

encerrar:
    li      $v0, 10
    syscall