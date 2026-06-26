# Atividade 1 - Multiplicacao por Somas e Deslocamentos

Este README explica a atividade como uma aula direta: o que o circuito precisa fazer, como o datapath fornecido e usado, qual e a ideia da FSM e como ler os arquivos da solucao.

## 1. O problema

A atividade pede uma multiplicacao de dois numeros sem sinal de 10 bits, mas com uma restricao importante: nao podemos simplesmente usar a operacao de multiplicacao da ULA.

A multiplicacao deve ser feita usando:

- soma;
- deslocamento para a esquerda;
- deslocamento para a direita;
- teste de bit.

Isso e o mesmo raciocinio da multiplicacao binaria feita "na mao".

Exemplo:

```text
13 * 6

13 = 0000001101
 6 = 0000000110

Como 6 em binario tem bits 1 nas posicoes 1 e 2:

13 * 6 = (13 << 1) + (13 << 2)
       = 26 + 52
       = 78
```

Entao a FSM percorre os bits do multiplicador. Quando encontra bit 1, soma o multiplicando deslocado no acumulador. Quando encontra bit 0, so desloca e continua.

## 2. O datapath fornecido

O arquivo `../datapath.v` integra:

- banco de registradores;
- ULA;
- mux de escrita.

O banco tem 8 registradores de 10 bits:

```text
R0 ate R7
```

A ULA recebe dois valores do banco:

```text
VA = registrador selecionado por sel_ra
VB = registrador selecionado por sel_rb
```

E produz:

```text
S = resultado da operacao
Z = flag de zero
C = carry / overflow / borrow, dependendo da operacao
```

O resultado pode voltar para o banco quando `mux_w_sel = 0`. Tambem e possivel escrever um valor externo quando `mux_w_sel = 1`.

Um detalhe muito importante: o banco de registradores fornecido escreve na borda de subida do sinal `escreve`. Ele nao escreve diretamente na borda do `clk`. Por isso, no controle da atividade, cada estado que grava no banco gera um pulso em `escreve`.

## 3. Registradores usados

Na solucao, os registradores foram usados assim:

| Registrador | Funcao |
|---|---|
| R0 | Operando A, carregado antes do inicio |
| R1 | Operando B, carregado antes do inicio |
| R2 | Acumulador, onde fica o resultado parcial |
| R3 | Multiplicando deslocado |
| R4 | Multiplicador deslocado |
| R5 | Constante 1 |

Exemplo com `A=13` e `B=6`:

```text
R0 = 13
R1 = 6
R2 = 0
R3 = 13
R4 = 6
R5 = 1
```

Depois, a cada repeticao:

```text
se (R4 AND 1) != 0:
    R2 = R2 + R3

R3 = R3 << 1
R4 = R4 >> 1
```

## 4. Por que testar `R4 AND 1`

O menor bit de um numero binario diz se ele e par ou impar.

```text
R4 AND 1
```

mantem apenas o bit menos significativo.

Exemplo:

```text
6 = 0000000110
1 = 0000000001
---------------- AND
0 = 0000000000
```

O bit menor de 6 e 0, entao naquele passo nao soma.

Depois:

```text
R4 = R4 >> 1
```

O 6 vira 3:

```text
0000000110 >> 1 = 0000000011
```

Agora:

```text
3 AND 1 = 1
```

Entao soma.

## 5. Exemplo passo a passo

Vamos multiplicar:

```text
13 * 6
```

Estado inicial de trabalho:

```text
R2 = 0
R3 = 13
R4 = 6
```

Passo 1:

```text
R4 = 6, bit0 = 0
Nao soma.

R3 = 13 << 1 = 26
R4 = 6 >> 1 = 3
```

Passo 2:

```text
R4 = 3, bit0 = 1
Soma:
R2 = 0 + 26 = 26

R3 = 26 << 1 = 52
R4 = 3 >> 1 = 1
```

Passo 3:

```text
R4 = 1, bit0 = 1
Soma:
R2 = 26 + 52 = 78

R3 = 52 << 1 = 104
R4 = 1 >> 1 = 0
```

Como `R4` virou zero, acabou:

```text
resultado = R2 = 78
```

## 6. Estados da FSM

A FSM tem estados simples:

| Estado | Papel |
|---|---|
| IDLE | Espera carregar operandos e receber `inicio` |
| INIT_RES | Coloca zero no acumulador R2 |
| INIT_UM | Coloca 1 em R5 |
| COPIA_A | Copia A para R3 |
| COPIA_B | Copia B para R4 |
| TESTA | Testa se R4 acabou e testa o bit 0 |
| SOMA | Soma R3 no acumulador R2 |
| DESL_A | Desloca R3 para a esquerda |
| DESL_B | Desloca R4 para a direita |
| INC | Incrementa o contador interno |
| FIM | Resultado pronto |

O desenho mental e:

```text
prepara tudo
enquanto ainda houver bit para testar:
    olha bit0 do multiplicador
    se bit0 for 1, soma
    desloca multiplicando para esquerda
    desloca multiplicador para direita
fim
```

## 7. Overflow

Como tudo tem 10 bits, o maior valor representavel e:

```text
1023
```

Se o produto real passar disso, o resultado que aparece em 10 bits fica truncado. Por exemplo:

```text
32 * 32 = 1024
```

Em 10 bits, 1024 vira:

```text
0
```

Por isso a FSM precisa acender o LED de overflow.

Existem dois jeitos de perceber overflow nesta solucao:

1. quando a soma `R2 + R3` gera carry;
2. quando um termo deslocado fica maior que 10 bits e depois precisa ser somado.

O segundo caso evita erro em exemplos como:

```text
600 * 1 = 600
```

Mesmo que deslocamentos futuros possam perder bits, isso nao deve virar overflow se esses termos nao forem usados na soma.

## 8. Arquivos da atividade

| Arquivo | Funcao |
|---|---|
| `multiplicador_somas_deslocamentos.v` | FSM principal da atividade |
| `atividade1_top.v` | Topo para a DE1 |
| `bin10_para_bcd.v` | Converte o resultado binario para decimal |
| `hex7seg.v` | Converte cada digito decimal para display de 7 segmentos |
| `tb_atividade1.v` | Testbench da atividade |
| `relatorio_atividade1.md` | Relatorio com diagrama, tabelas e respostas |

Os arquivos do professor ficam na pasta de cima:

```text
../datapath.v
../ula.v
../register_file.v
```

Eles nao foram alterados.

## 9. Como simular

Com Icarus Verilog instalado:

```sh
iverilog -o tb_atividade1.out ../register_file.v ../ula.v ../datapath.v multiplicador_somas_deslocamentos.v tb_atividade1.v
vvp tb_atividade1.out
```

O testbench verifica casos comuns e casos de overflow:

```text
3 * 5 = 15
0 * 789 = 0
31 * 33 = 1023
32 * 32 = overflow
600 * 1 = 600 sem overflow falso
512 * 2 = overflow
```

## 10. Como explicar para o professor

Uma explicacao curta e boa:

```text
Eu implementei multiplicacao binaria por somas parciais. O multiplicador fica em R4 e vai sendo deslocado para a direita. O multiplicando fica em R3 e vai sendo deslocado para a esquerda. Em cada ciclo eu testo o bit menos significativo de R4 com AND 1. Se o bit for 1, somo R3 no acumulador R2. Quando R4 vira zero, nao ha mais parcelas para somar, entao a FSM termina. O overflow e indicado quando alguma soma estoura 10 bits ou quando um termo deslocado que ja perdeu bits precisa ser usado no acumulador.
```

