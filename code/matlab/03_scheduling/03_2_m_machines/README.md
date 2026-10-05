# 3.2 — Três ou mais máquinas (MATLAB/Octave)

- Funções: `Reduz.m`, `Condicao.m`, `JohnsonM.m` (usam `Johnson` de 3.1)
- Exemplo: `ex03_2_m_machines.m` (gráfica com corte: condição verificada, D, E, A, F, B, C com 47 h, ordem de chegada 55 h; plastificação: a condição falha, Johnson dá 39 h e o ótimo 3, 2, 4, 1 dá 35 h; Exemplos 3 (51), 4 (52) e 5 (cinco máquinas, 51) da aula).
- Tradução da versão Python (`code/python/03_scheduling/03_2_m_machines/`), com a mesma saída.
- A experiência com 500 problemas aleatórios (slide «E agora?») está só em Python (`code/python/03_scheduling/03_3_tdm/experiencia_aleatoria.py`): usa o gerador aleatório do Python, que o MATLAB/Octave não reproduz.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex03_2_m_machines.m` e carregar em Run (ou `run('ex03_2_m_machines.m')`).
O capítulo inteiro corre com `../ex03_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
