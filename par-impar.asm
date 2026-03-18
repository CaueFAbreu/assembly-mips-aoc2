# Programa: Filtro de Paridade em Vetores
# Arquivo: par-impar.asm

.data
    size:    .word 10           # Tamanho do vetor conforme o exemplo
    vetor:   .word 15, 22, 30, 41, 55, 60, 78, 81, 90, 100
    pares:   .space 40          # Espaco para 10 inteiros (10 * 4 bytes)
    impares: .space 40

.text
.globl main

main:
    la      $s0, vetor          # Ponteiro para o vetor original
    la      $s1, pares          # Ponteiro para o vetor de pares
    la      $s2, impares        # Ponteiro para o vetor de impares
    
    li      $t0, 0              # i = 0
    lw      $t1, size           # limite do loop (n = 10)

loop_principal:
    beq     $t0, $t1, encerrar  # Se i == size, encerra
    
    lw      $t2, 0($s0)         # Carrega V[i]
    
    li      $t3, 2
    div     $t2, $t3            # Divide V[i] por 2
    mfhi    $t4                 # Resto da divisao vai para $t4
    
    beq     $t4, $zero, eh_par  # Se resto == 0, vai para eh_par

    # --- Bloco Impar ---
    sw      $t2, 0($s2)         # Salva em impares
    addi    $s2, $s2, 4         # Avanca ponteiro impares
    j       proximo

eh_par:
    # --- Bloco Par ---
    sw      $t2, 0($s1)         # Salva em pares
    addi    $s1, $s1, 4         # Avanca ponteiro pares

proximo:
    addi    $s0, $s0, 4         # Avanca ponteiro vetor original
    addi    $t0, $t0, 1         # i++
    j       loop_principal

encerrar:
    li      $v0, 10
    syscall