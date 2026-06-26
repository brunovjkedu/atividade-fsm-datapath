# Test Steps - Atividade 2

Estes testes sao para fazer na placa DE1, passo a passo.

Convencoes usadas:

- Levantar um switch significa colocar em `1`.
- Abaixar um switch significa colocar em `0`.
- `SW0` vale 1.
- `SW1` vale 2.
- `SW2` vale 4.
- `SW3` vale 8.
- `SW4` vale 16.
- `SW5` vale 32.
- `SW6` vale 64.
- `SW7` vale 128.
- `SW8` vale 256.
- `SW9` vale 512.
- `KEY0` e o clock manual da FSM.
- `KEY1` carrega o coeficiente `a`.
- `KEY2` carrega o coeficiente `b`.
- `KEY3` carrega o coeficiente `c` quando `SW9` esta abaixado.
- `KEY3` inicia a FSM quando `SW9` esta levantado.

Importante:

```text
Para carregar c: SW9 deve ficar abaixado.
Para iniciar: SW9 deve ficar levantado.
```

## Teste 1 - p(n) = 2n^2 + 3n + 1

Objetivo:

```text
a = 2
b = 3
c = 1
quantidade = 5
```

Valores esperados:

```text
n = 0 -> 1
n = 1 -> 6
n = 2 -> 15
n = 3 -> 28
n = 4 -> 45
```

Carregar `a = 2`:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Levante apenas `SW1`.
3. Confira que o valor nos switches representa `2`.
4. Aperte e solte `KEY1` para carregar o coeficiente `a`.

Carregar `b = 3`:

5. Abaixe todos os switches `SW0` ate `SW9`.
6. Levante apenas `SW0` e `SW1`.
7. Confira que o valor nos switches representa `3`.
8. Aperte e solte `KEY2` para carregar o coeficiente `b`.

Carregar `c = 1`:

9. Abaixe todos os switches `SW0` ate `SW9`.
10. Levante apenas `SW0`.
11. Confira que `SW9` esta abaixado.
12. Confira que o valor nos switches representa `1`.
13. Aperte e solte `KEY3` para carregar o coeficiente `c`.

Configurar quantidade `5` e iniciar:

14. Abaixe todos os switches `SW0` ate `SW9`.
15. Levante `SW9` para selecionar o modo de inicio.
16. Levante tambem `SW0` e `SW2`.
17. Confira que `SW0` + `SW2` representa quantidade `5`.
18. Mantenha `KEY3` apertado para ligar o sinal `inicio`.
19. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para a FSM sair do estado inicial.

Observar os valores:

20. Continue apertando e soltando `KEY0`, um pulso por vez.
21. Quando o LED de valor pronto acender, olhe os displays.
22. Continue apertando e soltando `KEY0` para passar para os proximos valores.
23. Pare quando o LED de concluido acender.
24. Solte `KEY3`.

Resultado esperado:

```text
Displays, na ordem: 0001, 0006, 0015, 0028, 0045
LED de overflow: apagado
LED de concluido: aceso no final
```

## Teste 2 - Polinomio constante: p(n) = 7

Objetivo:

```text
a = 0
b = 0
c = 7
quantidade = 4
```

Valores esperados:

```text
7, 7, 7, 7
```

Carregar `a = 0`:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Confira que o valor nos switches representa `0`.
3. Aperte e solte `KEY1` para carregar o coeficiente `a`.

Carregar `b = 0`:

4. Mantenha todos os switches `SW0` ate `SW9` abaixados.
5. Aperte e solte `KEY2` para carregar o coeficiente `b`.

Carregar `c = 7`:

6. Abaixe todos os switches `SW0` ate `SW9`.
7. Levante apenas `SW0`, `SW1` e `SW2`.
8. Confira que `SW9` esta abaixado.
9. Confira que o valor nos switches representa `7`.
10. Aperte e solte `KEY3` para carregar o coeficiente `c`.

Configurar quantidade `4` e iniciar:

11. Abaixe todos os switches `SW0` ate `SW9`.
12. Levante `SW9` para selecionar o modo de inicio.
13. Levante tambem apenas `SW2`.
14. Confira que `SW2` representa quantidade `4`.
15. Mantenha `KEY3` apertado.
16. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para iniciar.

Observar:

17. Continue apertando e soltando `KEY0`, um pulso por vez.
18. Sempre que o LED de valor pronto acender, olhe os displays.
19. Pare quando o LED de concluido acender.
20. Solte `KEY3`.

Resultado esperado:

```text
Displays, na ordem: 0007, 0007, 0007, 0007
LED de overflow: apagado
```

## Teste 3 - Polinomio linear: p(n) = 5n + 2

Objetivo:

```text
a = 0
b = 5
c = 2
quantidade = 5
```

Valores esperados:

```text
2, 7, 12, 17, 22
```

Carregar `a = 0`:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Aperte e solte `KEY1` para carregar `a = 0`.

Carregar `b = 5`:

3. Abaixe todos os switches `SW0` ate `SW9`.
4. Levante apenas `SW0` e `SW2`.
5. Confira que o valor nos switches representa `5`.
6. Aperte e solte `KEY2` para carregar `b = 5`.

Carregar `c = 2`:

7. Abaixe todos os switches `SW0` ate `SW9`.
8. Levante apenas `SW1`.
9. Confira que `SW9` esta abaixado.
10. Confira que o valor nos switches representa `2`.
11. Aperte e solte `KEY3` para carregar `c = 2`.

Configurar quantidade `5` e iniciar:

12. Abaixe todos os switches `SW0` ate `SW9`.
13. Levante `SW9`.
14. Levante tambem `SW0` e `SW2`.
15. Mantenha `KEY3` apertado.
16. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para iniciar.

Observar:

17. Continue apertando e soltando `KEY0`, um pulso por vez.
18. Sempre que o LED de valor pronto acender, olhe os displays.
19. Pare quando o LED de concluido acender.
20. Solte `KEY3`.

Resultado esperado:

```text
Displays, na ordem: 0002, 0007, 0012, 0017, 0022
LED de overflow: apagado
```

## Teste 4 - Quantidade zero

Objetivo:

```text
quantidade = 0
```

A FSM deve concluir sem mostrar uma sequencia de valores.

Carregar `a = 2`:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Levante apenas `SW1`.
3. Aperte e solte `KEY1`.

Carregar `b = 3`:

4. Abaixe todos os switches `SW0` ate `SW9`.
5. Levante apenas `SW0` e `SW1`.
6. Aperte e solte `KEY2`.

Carregar `c = 1`:

7. Abaixe todos os switches `SW0` ate `SW9`.
8. Levante apenas `SW0`.
9. Confira que `SW9` esta abaixado.
10. Aperte e solte `KEY3`.

Configurar quantidade `0` e iniciar:

11. Abaixe todos os switches `SW0` ate `SW9`.
12. Levante apenas `SW9`.
13. Confira que `SW0`, `SW1`, `SW2` e `SW3` estao abaixados, representando quantidade `0`.
14. Mantenha `KEY3` apertado.
15. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para iniciar.
16. Continue apertando e soltando `KEY0` ate o LED de concluido acender.
17. Solte `KEY3`.

Resultado esperado:

```text
LED de concluido: aceso
Nenhuma sequencia de valores deve ser exibida como valor pronto
```

## Teste 5 - Overflow

Objetivo:

```text
p(n) = 300n^2 + 300n + 300
quantidade = 3
```

Valores matematicos:

```text
n = 0 -> 300
n = 1 -> 900
n = 2 -> 2100
```

Como `2100` passa de `1023`, deve ocorrer overflow.

Carregar `a = 300`:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Levante apenas `SW8`, `SW5`, `SW3` e `SW2`.
3. Confira que o valor nos switches representa `300`.
4. Aperte e solte `KEY1` para carregar `a`.

Carregar `b = 300`:

5. Mantenha apenas `SW8`, `SW5`, `SW3` e `SW2` levantados.
6. Aperte e solte `KEY2` para carregar `b`.

Carregar `c = 300`:

7. Mantenha apenas `SW8`, `SW5`, `SW3` e `SW2` levantados.
8. Abaixe `SW9`, caso ele esteja levantado.
9. Aperte e solte `KEY3` para carregar `c`.

Configurar quantidade `3` e iniciar:

10. Abaixe todos os switches `SW0` ate `SW9`.
11. Levante `SW9` para selecionar o modo de inicio.
12. Levante tambem `SW0` e `SW1`.
13. Confira que `SW0` + `SW1` representa quantidade `3`.
14. Mantenha `KEY3` apertado.
15. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para iniciar.

Observar:

16. Continue apertando e soltando `KEY0`, um pulso por vez.
17. Observe os valores exibidos quando o LED de valor pronto acender.
18. Pare quando o LED de concluido acender.
19. Solte `KEY3`.

Resultado esperado:

```text
Valores matematicos: 0300, 0900, 2100
Como o datapath tem 10 bits, valores acima de 1023 ficam truncados.
LED de overflow: aceso
```

