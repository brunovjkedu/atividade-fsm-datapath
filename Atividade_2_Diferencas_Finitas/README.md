# Atividade 2 - Metodo das Diferencas Finitas

Esta atividade calcula valores sucessivos de um polinomio de grau 2 usando apenas somas depois da preparacao inicial.

## 1. O problema

O polinomio tem a forma:

```text
p(n) = a*n^2 + b*n + c
```

Uma forma direta de calcular seria:

```text
calcular n^2
multiplicar por a
multiplicar b por n
somar tudo com c
```

Mas isso usa multiplicacao. A ideia da atividade e evitar isso usando diferencas finitas.

## 2. A ideia central

Para polinomios de grau 2, a segunda diferenca e constante.

Exemplo:

```text
p(n) = 2n^2 + 3n + 1
```

Valores diretos:

```text
n=0 -> 1
n=1 -> 6
n=2 -> 15
n=3 -> 28
n=4 -> 45
```

Primeiras diferencas:

```text
6 - 1  = 5
15 - 6 = 9
28 - 15 = 13
45 - 28 = 17
```

Segundas diferencas:

```text
9 - 5 = 4
13 - 9 = 4
17 - 13 = 4
```

A segunda diferenca ficou constante. Entao, depois de preparar os valores iniciais, basta ir somando.

## 3. Formulas usadas

Para:

```text
p(n) = a*n^2 + b*n + c
```

os valores iniciais sao:

```text
y  = c
d1 = a + b
d2 = 2*a
```

Depois:

```text
mostra y
y  = y + d1
d1 = d1 + d2
repete
```

## 4. Exemplo completo

Para:

```text
p(n) = 2n^2 + 3n + 1
```

temos:

```text
a = 2
b = 3
c = 1

y  = c     = 1
d1 = a + b = 5
d2 = 2*a   = 4
```

Agora a tabela:

| n | y mostrado | calculo do proximo y | proximo d1 |
|---:|---:|---|---:|
| 0 | 1 | 1 + 5 = 6 | 5 + 4 = 9 |
| 1 | 6 | 6 + 9 = 15 | 9 + 4 = 13 |
| 2 | 15 | 15 + 13 = 28 | 13 + 4 = 17 |
| 3 | 28 | 28 + 17 = 45 | 17 + 4 = 21 |
| 4 | 45 | fim | fim |

Resultado exibido:

```text
1, 6, 15, 28, 45
```

## 5. Registradores usados

| Registrador | Uso |
|---|---|
| R0 | coeficiente `a` |
| R1 | coeficiente `b` |
| R2 | valor atual `y` |
| R3 | primeira diferenca `d1` |
| R4 | segunda diferenca `d2` |

O coeficiente `c` entra direto em `R2`, porque:

```text
p(0) = c
```

## 6. Estados principais

| Estado | O que faz |
|---|---|
| IDLE | Espera carregar `a`, `b`, `c` e receber `inicio` |
| PREP_D2 | Calcula `d2 = a + a` |
| PREP_D1 | Calcula `d1 = a + b` |
| MOSTRA | Deixa o valor atual `y` disponivel na saida |
| PROX_Y | Calcula `y = y + d1` |
| PROX_D1 | Calcula `d1 = d1 + d2` |
| INC | Incrementa o indice interno |
| FIM | Encerra a sequencia |

## 7. Arquivos

| Arquivo | Funcao |
|---|---|
| `diferencas_finitas_grau2.v` | FSM principal |
| `atividade2_top.v` | Topo simples para DE1 |
| `bin10_para_bcd.v` | Conversao do valor para decimal |
| `hex7seg.v` | Controle dos displays HEX |
| `tb_atividade2.v` | Testbench |
| `relatorio_atividade2.md` | Diagrama, tabelas e respostas |

Os arquivos comuns do professor ficam na pasta de cima:

```text
../datapath.v
../ula.v
../register_file.v
```

## 8. Como simular

Com Icarus Verilog instalado:

```sh
iverilog -o tb_atividade2.out ../register_file.v ../ula.v ../datapath.v diferencas_finitas_grau2.v tb_atividade2.v
vvp tb_atividade2.out
```

## 9. Como explicar para o professor

Uma explicacao curta:

```text
Eu usei diferencas finitas para evitar multiplicacoes. O valor atual do polinomio fica em R2, a primeira diferenca fica em R3 e a segunda diferenca fica em R4. Primeiro a FSM calcula d2=2a e d1=a+b. Depois, para gerar cada novo valor, ela faz y=y+d1 e d1=d1+d2. Como o polinomio e de grau 2, d2 permanece constante.
```

