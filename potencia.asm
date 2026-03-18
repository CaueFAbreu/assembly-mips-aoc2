# Programa: Algoritmos de Potenciacao (Simples e Quadratico)
# Arquivo: potencia.asm

.data
    base:    .word 2
    expo:    .word 10
    res1:    .word 0
    res2:    .word 0
    msg1:    .asciiz "Resultado Algoritmo 1 (O(n)): "
    msg2:    .asciiz "\nResultado Algoritmo 2 (O(log n)): "

.text
.globl main

main:
    # --- ALGORITMO 1 (Fragmento 1 - Simples) ---
    lw      $t0, base           # Carrega base
    lw      $t1, expo           # Carrega expoente
    li      $t2, 1              # result = 1

loop_simples:
    blez    $t1, fim_simples    # Se n <= 0, encerra
    mul     $t2, $t2, $t0       # result *= x
    addi    $t1, $t1, -1        # n--
    j       loop_simples

fim_simples:
    sw      $t2, res1           # Salva resultado 1

    # --- ALGORITMO 2 (Fragmento 2 - Quadratico) ---
    lw      $t0, base           # x
    lw      $t1, expo           # n
    li      $t2, 1              # result = 1

loop_quadratico:
    beqz    $t1, fim_quadratico # Se n == 0, encerra
    
    # if (n % 2 == 1)
    andi    $t3, $t1, 1         # Verifica se impar
    beqz    $t3, skip_mul
    mul     $t2, $t2, $t0       # result *= x

skip_mul:
    srl     $t1, $t1, 1         # n /= 2
    mul     $t0, $t0, $t0       # x *= x
    j       loop_quadratico

fim_quadratico:
    sw      $t2, res2           # Salva resultado 2

    # Encerrar programa
    li      $v0, 10
    syscall