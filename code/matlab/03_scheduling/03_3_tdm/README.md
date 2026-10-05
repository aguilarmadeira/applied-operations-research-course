# 3.3 — Método do desvio de tempo, TDM (MATLAB/Octave)

- Funções: `Desvios.m`, `Tdm2.m`, `Tdm.m` (usam `Reduz` de 3.2). `Tdm(P, nomes, true)` imprime a tabela de desvios de cada iteração.
- Exemplo: `ex03_3_tdm.m` (gráfica passo a passo: construída B, F, C, D, A, E, TDM E, A, D, C, F, B com 46 h; o quadro dos três exemplos do capítulo; Exemplos 6 (63), 7 (54) e 8 (62) da aula).
- Tradução da versão Python (`code/python/03_scheduling/03_3_tdm/`), com a mesma saída.
- A experiência com 500 problemas aleatórios está só em Python (`experiencia_aleatoria.py`): usa o gerador aleatório do Python, que o MATLAB/Octave não reproduz.

## A regra de desempate (ambiguidade conhecida)

Como nos decks: várias células (0, 0) na mesma máquina ordenam-se pela maior soma dos quatro desvios; por trás, o bloco ordenado entra todo à esquerda do que já lá está (o de maior soma fica mais longe do fim). A outra leitura possível da regra (o de maior soma mais perto do fim) só difere quando há empate por trás; na plastificação daria 3, 2, 4, 1 com T = 35 em vez de 2, 3, 4, 1 com T = 40. Ver o README da versão Python.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex03_3_tdm.m` e carregar em Run (ou `run('ex03_3_tdm.m')`).
O capítulo inteiro corre com `../ex03_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
