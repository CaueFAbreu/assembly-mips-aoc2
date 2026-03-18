# 🖥️ Programas em Assembly MIPS — Trabalho 1

![Assembly](https://img.shields.io/badge/Assembly-MIPS-red?style=for-the-badge)
![Simulator](https://img.shields.io/badge/Simulador-MARS%2FSPIM-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Concluído-brightgreen?style=for-the-badge)

> Coleção de programas implementados em **Assembly MIPS32**, desenvolvidos como primeiro trabalho prático da disciplina de Arquitetura e Organização de Computadores. Os programas abordam operações matemáticas, manipulação de vetores, funções trigonométricas e aplicações de engenharia.

---

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Programas Implementados](#-programas-implementados)
- [Pré-requisitos](#-pré-requisitos)
- [Como Executar](#-como-executar)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Autor](#-autor)

---

## 📖 Sobre o Projeto

Este repositório reúne implementações em Assembly MIPS32 que exploram conceitos fundamentais de arquitetura de computadores: manipulação de registradores de ponto flutuante, endereçamento de vetores e matrizes, implementação de séries de Taylor e operações condicionais. Inclui também o Memorial Descritivo com a análise teórica de cada programa.

---

## 🗂️ Programas Implementados

### 1. 🔢 Filtro de Paridade — `par-impar.asm`
Percorre um vetor de 10 inteiros e separa os elementos em dois vetores: um com os números pares e outro com os ímpares.

- Uso de ponteiros para navegação nos vetores (`$s0`, `$s1`, `$s2`)
- Divisão por 2 com `div` e verificação do resto via `mfhi`
- Desvios condicionais para separação dos elementos

---

### 2. ⚡ Potenciação — `potencia.asm`
Implementa e compara dois algoritmos de potenciação para calcular `base^expoente`:

| Algoritmo | Complexidade | Técnica |
|---|---|---|
| Simples | O(n) | Multiplicação repetida |
| Rápido | O(log n) | Exponenciação por quadratura com `andi` e `srl` |

---

### 3. 📐 Funções Trigonométricas Inversas — `trig-1.asm`
Calcula as funções trigonométricas inversas **arcsin**, **arccos** e **arctan** para um valor de entrada via **Séries de Taylor** com 20 iterações.

- Operações com registradores de ponto flutuante (`$f0–$f20`)
- `arccos(x) = π/2 − arcsin(x)`
- Precisão controlada pelo número de iterações (`K = 20`)

---

### 4. 🤖 Braço Robótico 2D — `robot2D.asm`
Calcula os ângulos `θ1` e `θ2` de um braço robótico de dois segmentos a partir das coordenadas do end-effector (Px, Py) — **cinemática inversa**.

- Leitura de entrada em ponto flutuante (syscall 6)
- Verificação de alcance com `c.gt.s` e `c.lt.s`
- Usa as sub-funções `arcsin`, `arccos`, `arctan` e `atan2`
- Lei dos Cossenos e conversão de radianos para graus

---

### 5. 💧 Diagnóstico de Rede de Água — `fluxo-agua.asm`
Realiza o diagnóstico de uma rede de distribuição de água calculando o balanço líquido de cada nó através da multiplicação **x = B · f**, onde B é a matriz de incidência (5×7) e f é o vetor de fluxos.

- Multiplicação matriz-vetor com laços aninhados
- Classificação de cada nó como **FONTE**, **SUMIDOURO** ou **PASSAGEM**
- Endereçamento manual de matriz 2D com `mul`, `add` e `sll`

---

## ⚙️ Pré-requisitos

- Simulador **MARS** (Missouri Academic RISC Simulator) — recomendado
  - Download: [courses.missouristate.edu/KenVollmar/MARS](http://courses.missouristate.edu/KenVollmar/MARS/)
- Ou **SPIM** como alternativa

---

## 🚀 Como Executar

**No MARS (interface gráfica):**
1. Abra o MARS
2. Vá em `File → Open` e selecione o arquivo `.asm` desejado
3. Clique em `Run → Assemble` (F3)
4. Clique em `Run → Go` (F5) para executar

**No MARS (linha de comando):**
```bash
java -jar Mars.jar <arquivo>.asm
```

---

## 📁 Estrutura do Projeto

```
📦 assembly-mips-aoc-t1
 ┣ 📄 par-impar.asm     # Separação de números pares e ímpares
 ┣ 📄 potencia.asm      # Potenciação O(n) e O(log n)
 ┣ 📄 trig-1.asm        # Arcsin, Arccos e Arctan via Séries de Taylor
 ┣ 📄 robot2D.asm       # Cinemática inversa de braço robótico 2D
 ┣ 📄 fluxo-agua.asm    # Diagnóstico de rede de distribuição de água
 ┗ 📄 Memorial Descritivo - Arquitetura e Organização de Computadores.pdf
                        # Relatório com análise teórica e decisões de projeto
```

---

## 👤 Autor

**Cauê F. Abreu**

[![GitHub](https://img.shields.io/badge/GitHub-CaueFAbreu-181717?style=flat&logo=github)](https://github.com/CaueFAbreu)

---

<p align="center">Feito com ☕ e Assembly MIPS</p>
