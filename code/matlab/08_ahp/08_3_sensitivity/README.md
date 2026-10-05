# 8.3 — Análise de sensibilidade (MATLAB/Octave)

- Funções: `PesosCom.m`, `Sensibilidade.m`, `Viragem.m` (devolve `[]` se não houver empate em [0, 1]), `Perturba.m`, `SimulaJuizos.m`; usa as funções de `08_1_ahp/` e `08_2_attributes/`
- Exemplo: `ex08_3_sensitivity.m` (carrinhas: retas no peso de cada critério, C passa B quando o custo pesa 0,704; o juízo a12 de 1 a 9; a simulação de todos os juízos (B em 100%); Exemplos 6 e 7 da aula (F2 passa F3 a 0,268 no custo da MP e abaixo de 0,426 no transporte; F3 enquanto o rendimento pesar pelo menos 0,484)).
- Tradução da versão Python (`code/python/08_ahp/08_3_sensitivity/`), com a mesma saída, exceto nas linhas das simulações (ver abaixo).

## Como correr

No MATLAB ou no GNU Octave, abrir `ex08_3_sensitivity.m` e carregar em Run (ou `run('ex08_3_sensitivity.m')`).
O capítulo inteiro corre com `../ex08_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.
As três simulações (20 000 repetições cada) demoram cerca de 30 s no GNU Octave.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

## Simulações

`SimulaJuizos` fixa a semente com `rng(seed)` (1 por omissão), mas o gerador do MATLAB/Octave não é o do `numpy`: as frequências não são iguais às do Python, só próximas (p. ex. 89,8% em Octave e 89,9% em Python no Exemplo 6; RC > 0,1 em 1,0% e 1,1% nas carrinhas). O exemplo compara-as com uma tolerância de simulação (±1 ponto percentual, ou ≥ 99,5% quando o slide diz 100%). `Perturba` usa `randi` e o gerador global (o `perturba` do Python recebe o gerador `rng`).
