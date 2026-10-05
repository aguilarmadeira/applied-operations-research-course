# 3.3 — Método do desvio de tempo, TDM (Python)

- Módulo: `desvio_tempo.py` — `desvios(a, b, rest)` (tabela de desvios), `tdm2(a, b, jobs=None, log=False)` (2 máquinas), `tdm(P, log=False)` (m máquinas, sobre (G, H)); usa `reduz` de 3.2
- Exemplo: `ex03_3_tdm.py` (gráfica passo a passo: construída B, F, C, D, A, E, TDM E, A, D, C, F, B com 46 h; o quadro dos três exemplos do capítulo; Exemplos 6 (63), 7 (54) e 8 (62) da aula); caderno `ex03_3_tdm.ipynb`, também no Colab. Com `log=True`, `tdm` imprime a tabela de desvios de cada iteração.
- Só em Python: `experiencia_aleatoria.py` reproduz a experiência com 500 problemas aleatórios (slides de 3.2 e 3.3). Usa o gerador `random` do Python com semente fixa, que o MATLAB/Octave não reproduz; demora cerca de 15 s.
- A versão MATLAB está em `code/matlab/03_scheduling/03_3_tdm/` e dá a mesma saída (exceto a experiência aleatória).

## A regra de desempate (ambiguidade conhecida)

O código segue a regra dos decks: quando vários trabalhos têm célula (0, 0) na mesma máquina, ordenam-se pela **maior soma dos quatro desvios** do trabalho; pela frente entram por essa ordem; **por trás, o bloco ordenado entra todo à esquerda** do que já lá está, pelo que o de maior soma fica **mais longe do fim** da sequência construída. Um trabalho com (0, 0) nas duas máquinas entra pela frente.

A frase do slide («primeiro a de maior soma») admite outra leitura para as entradas por trás: a de maior soma entra primeiro e fica **mais perto do fim**, e as seguintes entram antes dela. As duas leituras só diferem quando há empate por trás, e podem dar sequências diferentes. Na semana da plastificação, a regra do código dá 2, 3, 4, 1 com T = 40 (o valor dos slides de 3.3 e 3.4); a outra leitura daria 3, 2, 4, 1 com T = 35. O código não foi alterado: reproduz os números dos decks.

## Como correr

Só precisa de `numpy` (para imprimir vetores como o `mat2str` do MATLAB). Em qualquer pasta:

```bash
python ex03_3_tdm.py
python experiencia_aleatoria.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
