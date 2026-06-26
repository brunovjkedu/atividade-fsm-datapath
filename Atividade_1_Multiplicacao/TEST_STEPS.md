# Test Steps - Atividade 1

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
- `KEY1` carrega o operando A.
- `KEY2` carrega o operando B.
- `KEY3` e o sinal de inicio.

## Teste 1 - Multiplicacao simples: 3 * 5

Objetivo:

```text
3 * 5 = 15
```

Passos:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Levante apenas `SW0` e `SW1`.
3. Confira que o valor nos switches representa `3`.
4. Aperte e solte `KEY1` para carregar o operando A.

5. Abaixe todos os switches `SW0` ate `SW9`.
6. Levante apenas `SW0` e `SW2`.
7. Confira que o valor nos switches representa `5`.
8. Aperte e solte `KEY2` para carregar o operando B.

9. Mantenha `KEY3` apertado para ligar o sinal `inicio`.
10. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para a FSM sair do estado inicial.
11. Continue apertando e soltando `KEY0`, um pulso por vez, ate o LED de concluido acender.
12. Solte `KEY3`.
13. Confira o resultado nos displays.

Resultado esperado:

```text
Display: 0015
LED de concluido: aceso
LED de overflow: apagado
```

## Teste 2 - Multiplicacao por zero: 0 * 789

Objetivo:

```text
0 * 789 = 0
```

Passos:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Confira que o valor nos switches representa `0`.
3. Aperte e solte `KEY1` para carregar o operando A.

4. Abaixe todos os switches `SW0` ate `SW9`.
5. Levante apenas `SW9`, `SW8`, `SW4` e `SW2`.
6. Confira que o valor nos switches representa `789`.
7. Aperte e solte `KEY2` para carregar o operando B.

8. Mantenha `KEY3` apertado para ligar o sinal `inicio`.
9. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para iniciar.
10. Continue apertando e soltando `KEY0` ate o LED de concluido acender.
11. Solte `KEY3`.
12. Confira o resultado nos displays.

Resultado esperado:

```text
Display: 0000
LED de concluido: aceso
LED de overflow: apagado
```

## Teste 3 - Maior resultado sem overflow: 31 * 33

Objetivo:

```text
31 * 33 = 1023
```

Passos:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Levante apenas `SW0`, `SW1`, `SW2`, `SW3` e `SW4`.
3. Confira que o valor nos switches representa `31`.
4. Aperte e solte `KEY1` para carregar o operando A.

5. Abaixe todos os switches `SW0` ate `SW9`.
6. Levante apenas `SW0` e `SW5`.
7. Confira que o valor nos switches representa `33`.
8. Aperte e solte `KEY2` para carregar o operando B.

9. Mantenha `KEY3` apertado.
10. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para iniciar.
11. Continue apertando e soltando `KEY0` ate o LED de concluido acender.
12. Solte `KEY3`.
13. Confira o resultado nos displays.

Resultado esperado:

```text
Display: 1023
LED de concluido: aceso
LED de overflow: apagado
```

## Teste 4 - Overflow: 32 * 32

Objetivo:

```text
32 * 32 = 1024
```

Como o datapath tem apenas 10 bits, o resultado visivel fica truncado para `0`, mas o LED de overflow deve acender.

Passos:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Levante apenas `SW5`.
3. Confira que o valor nos switches representa `32`.
4. Aperte e solte `KEY1` para carregar o operando A.

5. Mantenha apenas `SW5` levantado.
6. Confira que o valor nos switches representa `32`.
7. Aperte e solte `KEY2` para carregar o operando B.

8. Mantenha `KEY3` apertado.
9. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para iniciar.
10. Continue apertando e soltando `KEY0` ate o LED de concluido acender.
11. Solte `KEY3`.
12. Confira o resultado nos displays e LEDs.

Resultado esperado:

```text
Display: 0000
LED de concluido: aceso
LED de overflow: aceso
```

## Teste 5 - Sem overflow falso: 600 * 1

Objetivo:

```text
600 * 1 = 600
```

Este teste confirma que a FSM nao marca overflow apenas porque deslocamentos futuros perderiam bits. Como o multiplicador e `1`, so o termo inicial e realmente somado.

Passos:

1. Abaixe todos os switches `SW0` ate `SW9`.
2. Levante apenas `SW9`, `SW6`, `SW4` e `SW3`.
3. Confira que o valor nos switches representa `600`.
4. Aperte e solte `KEY1` para carregar o operando A.

5. Abaixe todos os switches `SW0` ate `SW9`.
6. Levante apenas `SW0`.
7. Confira que o valor nos switches representa `1`.
8. Aperte e solte `KEY2` para carregar o operando B.

9. Mantenha `KEY3` apertado.
10. Com `KEY3` ainda apertado, aperte e solte `KEY0` uma vez para iniciar.
11. Continue apertando e soltando `KEY0` ate o LED de concluido acender.
12. Solte `KEY3`.
13. Confira o resultado nos displays e LEDs.

Resultado esperado:

```text
Display: 0600
LED de concluido: aceso
LED de overflow: apagado
```

