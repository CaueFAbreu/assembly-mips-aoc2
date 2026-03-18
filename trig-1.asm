# Programa: Implementacao de Series de Taylor (asin, acos, atan)
# Descricao: Calcula aproximacoes para funcoes trigonometricas inversas
# Arquivo: trig-1.asm

.data
    prompt_x:   .asciiz "Digite o valor de x (entre -1.0 e 1.0): "
    str_asin:   .asciiz "\nArcsin(x): "
    str_acos:   .asciiz "\nArccos(x): "
    str_atan:   .asciiz "\nArctan(x): "
    
    c_zero:     .float 0.0
    c_one:      .float 1.0
    c_two:      .float 2.0
    c_pi_2:     .float 1.57079632679  # Pi / 2 [cite: 159]
    
    iteracoes:  .word 20              # K = 20 iteracoes para precisao [cite: 161]

.text
.globl main

main:
    li      $v0, 4
    la      $a0, prompt_x
    syscall

    li      $v0, 6              # Ler float x
    syscall
    mov.s   $f12, $f0
    mov.s   $f20, $f12          # Salvar x original

    # --- CALCULAR ARCTAN --- [cite: 154]
    jal     arctan
    
    li      $v0, 4
    la      $a0, str_atan
    syscall
    
    mov.s   $f12, $f0
    li      $v0, 2
    syscall

    # --- CALCULAR ARCSIN --- [cite: 149]
    mov.s   $f12, $f20
    jal     arcsin
    
    li      $v0, 4
    la      $a0, str_asin
    syscall
    
    mov.s   $f12, $f0
    li      $v0, 2
    syscall
    
    mov.s   $f21, $f0           # Salvar arcsin(x) para o acos

    # --- CALCULAR ARCCOS --- [cite: 159]
    l.s     $f1, c_pi_2
    sub.s   $f0, $f1, $f21 
    
    li      $v0, 4
    la      $a0, str_acos
    syscall
    
    mov.s   $f12, $f0
    li      $v0, 2
    syscall

    li      $v0, 10
    syscall

# --- Funcao Arctan --- [cite: 155, 157]
arctan:
    mov.s   $f0, $f12           # Soma = x
    mov.s   $f1, $f12           # Potencia = x
    mul.s   $f2, $f12, $f12     # x^2
    l.s     $f3, c_one          # Denominador
    l.s     $f4, c_two          # Incremento
    lw      $t0, iteracoes
    li      $t1, 1              # Flag sinal

loop_atan:
    beq     $t0, $zero, end_atan
    mul.s   $f1, $f1, $f2
    add.s   $f3, $f3, $f4
    div.s   $f6, $f1, $f3
    beq     $t1, $zero, somar_atan
    sub.s   $f0, $f0, $f6
    li      $t1, 0
    j       next_iter_atan
somar_atan:
    add.s   $f0, $f0, $f6
    li      $t1, 1
next_iter_atan:
    addi    $t0, $t0, -1
    j       loop_atan
end_atan:
    jr      $ra

# --- Funcao Arcsin --- [cite: 150, 152]
arcsin:
    mov.s   $f0, $f12           # Soma = x
    mov.s   $f1, $f12           # Potencia = x
    mul.s   $f2, $f12, $f12     # x^2
    l.s     $f3, c_one          # Coeficiente
    l.s     $f4, c_one          # n = 1.0
    l.s     $f10, c_one
    l.s     $f11, c_two
    lw      $t0, iteracoes

loop_asin:
    beq     $t0, $zero, end_asin
    mul.s   $f6, $f4, $f11      # 2n
    sub.s   $f7, $f6, $f10      # 2n - 1
    div.s   $f8, $f7, $f6       # (2n-1)/2n
    mul.s   $f3, $f3, $f8       # Novo C_n
    mul.s   $f1, $f1, $f2       # x^(2n+1)
    add.s   $f9, $f6, $f10      # 2n + 1
    mul.s   $f5, $f3, $f1
    div.s   $f5, $f5, $f9
    add.s   $f0, $f0, $f5       # Soma termo
    add.s   $f4, $f4, $f10      # n++
    addi    $t0, $t0, -1
    j       loop_asin
end_asin:
    jr      $ra