# 8.1 — O AHP: comparações par a par e consistência (MATLAB/Octave)

- Funções: `MatrizReciproca.m`, `Prioridades.m` (`'colunas'` ou `'vetor'`; o vetor próprio usa `eig`)
- Exemplo: `ex08_1_ahp.m` (pesos das carrinhas pelo método das colunas (0,482; 0,272; 0,158; 0,088; RC = 0,005) e pelo vetor próprio, o juízo incoerente a13 = 1/2 (RC = 0,173) e o par que o denuncia, a assistência, e os Exemplos 1 (frutos) e 2 (emprego) da aula).
- Tradução da versão Python (`code/python/08_ahp/08_1_ahp/`), com a mesma saída. Os juízos dão-se como linhas `[i j a_ij]` (índices a partir de 1); os vetores devolvidos são colunas.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex08_1_ahp.m` e carregar em Run (ou `run('ex08_1_ahp.m')`).
O capítulo inteiro corre com `../ex08_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
