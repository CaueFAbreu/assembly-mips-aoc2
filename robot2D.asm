# Programa: Controlador de Braço Robótico 2D (Cinemática Inversa)
# Descrição: Calcula os ângulos theta1 e theta2 dado Px, Py, L1, L2
# Arquivo: robot2D.asm

.data
    prompt_px:      .asciiz "Digite Px (coordenada X do end-effector): "
    prompt_py:      .asciiz "Digite Py (coordenada Y do end-effector): "
    prompt_l1:      .asciiz "Digite L1 (comprimento do segmento 1): "
    prompt_l2:      .asciiz "Digite L2 (comprimento do segmento 2): "

    str_theta1:     .asciiz "\nTheta1 (graus): "
    str_theta2:     .asciiz "\nTheta2 (graus): "
    str_unreachable:.asciiz "\nPonto FORA DE ALCANCE do robo!\n"
    newline:        .asciiz "\n"

    c_zero:         .float 0.0
    c_one:          .float 1.0
    c_two:          .float 2.0
    c_pi_2:         .float 1.57079632679   # Pi/2
    c_pi:           .float 3.14159265358   # Pi
    c_rad2deg:      .float 57.2957795131   # 180 / Pi

    iteracoes:      .word 20

.text
.globl main

main:
    # --- Leituras de Entrada ---
    li      $v0, 4
    la      $a0, prompt_px
    syscall
    li      $v0, 6
    syscall
    mov.s   $f20, $f0          # Px [cite: 197]

    li      $v0, 4
    la      $a0, prompt_py
    syscall
    li      $v0, 6
    syscall
    mov.s   $f21, $f0          # Py [cite: 197]

    li      $v0, 4
    la      $a0, prompt_l1
    syscall
    li      $v0, 6
    syscall
    mov.s   $f22, $f0          # L1 [cite: 198]

    li      $v0, 4
    la      $a0, prompt_l2
    syscall
    li      $v0, 6
    syscall
    mov.s   $f23, $f0          # L2 [cite: 198]

    # Passo 1: Calcular D^2 = Px^2 + Py^2 [cite: 201]
    mul.s   $f1, $f20, $f20    # Px^2
    mul.s   $f2, $f21, $f21    # Py^2
    add.s   $f24, $f1, $f2     # $f24 = D^2
    sqrt.s  $f25, $f24         # $f25 = D

    # Passo 2: Verificação de Alcance [cite: 202]
    add.s   $f3, $f22, $f23    # $f3 = L1 + L2
    sub.s   $f4, $f22, $f23    # $f4 = L1 - L2
    abs.s   $f4, $f4           # $f4 = |L1 - L2|

    c.gt.s  $f25, $f3          # D > L1 + L2?
    bc1t    out_of_range
    c.lt.s  $f25, $f4          # D < |L1 - L2|?
    bc1t    out_of_range

    # Passo 3: Calcular theta2 (Lei dos Cossenos) [cite: 224, 225]
    mul.s   $f5, $f22, $f22    # L1^2
    mul.s   $f6, $f23, $f23    # L2^2
    sub.s   $f7, $f24, $f5
    sub.s   $f7, $f7, $f6      # $f7 = D^2 - L1^2 - L2^2
    l.s     $f8, c_two
    mul.s   $f8, $f8, $f22
    mul.s   $f8, $f8, $f23     # $f8 = 2*L1*L2
    div.s   $f12, $f7, $f8
    jal     arccos             # Chama arccos [cite: 225]
    mov.s   $f26, $f0          # $f26 = theta2

    # Passo 4: Calcular theta1 [cite: 231, 239]
    mov.s   $f12, $f20         # Px
    mov.s   $f13, $f21         # Py
    jal     atan2_func         # beta = atan2(Py, Px) [cite: 231]
    mov.s   $f27, $f0          # $f27 = beta

    add.s   $f9, $f24, $f5     # D^2 + L1^2
    sub.s   $f9, $f9, $f6      # D^2 + L1^2 - L2^2
    l.s     $f10, c_two
    mul.s   $f10, $f10, $f25   # 2*D
    mul.s   $f10, $f10, $f22   # 2*D*L1
    div.s   $f12, $f9, $f10
    jal     arccos             # phi = arccos(...) [cite: 235]
    mov.s   $f28, $f0          # $f28 = phi
    sub.s   $f29, $f27, $f28   # theta1 = beta - phi [cite: 239]

    # Passo 5: Conversão para graus e Saída [cite: 242, 245]
    l.s     $f30, c_rad2deg
    li      $v0, 4
    la      $a0, str_theta1
    syscall
    mul.s   $f12, $f29, $f30   # theta1 em graus
    li      $v0, 2
    syscall

    li      $v0, 4
    la      $a0, str_theta2
    syscall
    mul.s   $f12, $f26, $f30   # theta2 em graus
    li      $v0, 2
    syscall
    j       fim

out_of_range:
    li      $v0, 4
    la      $a0, str_unreachable
    syscall

fim:
    li      $v0, 10
    syscall

# --- Sub-funções de Cálculo ---

arccos:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)
    jal     arcsin             # acos(x) = pi/2 - asin(x) [cite: 159]
    l.s     $f1, c_pi_2
    sub.s   $f0, $f1, $f0
    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra

arcsin:
    mov.s   $f0, $f12          # soma = x
    mov.s   $f1, $f12          # potencia = x
    mul.s   $f2, $f12, $f12    # x^2
    l.s     $f3, c_one         # coeficiente
    l.s     $f4, c_one         # n = 1.0
    l.s     $f10, c_one
    l.s     $f11, c_two
    lw      $t0, iteracoes
loop_asin:
    beq     $t0, $zero, end_asin
    mul.s   $f6, $f4, $f11     # 2n
    sub.s   $f7, $f6, $f10     # 2n - 1
    div.s   $f8, $f7, $f6      # (2n-1)/2n
    mul.s   $f3, $f3, $f8      # novo C_n
    mul.s   $f1, $f1, $f2      # x^(2n+1)
    add.s   $f9, $f6, $f10     # 2n + 1
    mul.s   $f15, $f3, $f1
    div.s   $f15, $f15, $f9
    add.s   $f0, $f0, $f15     # acumular
    add.s   $f4, $f4, $f10     # n = n + 1
    addi    $t0, $t0, -1       # i--
    j       loop_asin
end_asin:
    jr      $ra

arctan:
    mov.s   $f0, $f12          # soma = x
    mov.s   $f1, $f12          # potencia = x
    mul.s   $f2, $f12, $f12    # x^2
    l.s     $f3, c_one         # denominador
    l.s     $f4, c_two         # incremento
    lw      $t0, iteracoes
    li      $t1, 1             # flag sinal
loop_atan:
    beq     $t0, $zero, end_atan
    mul.s   $f1, $f1, $f2
    add.s   $f3, $f3, $f4
    div.s   $f6, $f1, $f3
    beq     $t1, $zero, somar_atan
subtrair_atan:
    sub.s   $f0, $f0, $f6
    li      $t1, 0
    j       prox_atan
somar_atan:
    add.s   $f0, $f0, $f6
    li      $t1, 1
prox_atan:
    addi    $t0, $t0, -1
    j       loop_atan
end_atan:
    jr      $ra

atan2_func:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)
    l.s     $f16, c_zero
    l.s     $f17, c_pi
    l.s     $f18, c_pi_2
    c.eq.s  $f12, $f16
    bc1t    atan2_x_zero
    div.s   $f12, $f13, $f12
    jal     arctan             # atan(y/x)
    l.s     $f16, c_zero
    c.lt.s  $f20, $f16
    bc1f    atan2_done
    c.lt.s  $f21, $f16
    bc1t    atan2_sub_pi
    add.s   $f0, $f0, $f17
    j       atan2_done
atan2_sub_pi:
    sub.s   $f0, $f0, $f17
    j       atan2_done
atan2_x_zero:
    c.lt.s  $f16, $f13
    bc1t    atan2_pos_pi2
    c.lt.s  $f13, $f16
    bc1t    atan2_neg_pi2
    mov.s   $f0, $f16
    j       atan2_done
atan2_pos_pi2:
    mov.s   $f0, $f18
    j       atan2_done
atan2_neg_pi2:
    neg.s   $f0, $f18
atan2_done:
    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra