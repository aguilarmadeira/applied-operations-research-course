"""Experiência numérica dos decks 3.2 e 3.3: Johnson, TDM e uma ordem aleatória contra o ótimo.

500 problemas aleatórios com 7 trabalhos e tempos inteiros de 1 a 20, ótimo por força bruta
(5040 sequências): com 2 máquinas (semente 1) e com 3 máquinas sem a condição de Johnson (semente 2).
Slides: 2 máquinas — Johnson ótimo em 100%, TDM em 18% (desvio médio 7.6%, pior 27%),
ordem aleatória em 8% (13.4%); 3 máquinas — Johnson ótimo em 49% (média 3%, pior 21%),
TDM em 3% (13.5%, pior 35%), aleatória em 1% (19.6%).

Só em Python: usa o gerador do módulo random (Mersenne Twister do Python) com semente fixa;
o MATLAB/Octave não gera os mesmos problemas. Demora cerca de 15 s.
Correr (de qualquer pasta):  python experiencia_aleatoria.py

Complementos de IO — decks 3.2 e 3.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import random
import statistics

from sequenciamento import cmax, forca_bruta
from m_maquinas import condicao, johnson_m
from desvio_tempo import tdm


def experiencia(m, n, N, semente, cond=None):
    """N problemas m x n; se cond não for None, só os que têm condicao(P)[0] == cond.

    Devolve {regra: (% de vezes ótima, desvio médio %, desvio máximo %)}.
    """
    random.seed(semente)
    desvio = {"Johnson": [], "TDM": [], "aleatória": []}
    k = 0
    while k < N:
        P = {chr(65 + i): tuple(random.randint(1, 20) for _ in range(m)) for i in range(n)}
        if cond is not None and condicao(P)[0] != cond:
            continue
        k += 1
        otimo = forca_bruta(P)[0][0]
        for nome, s in [("Johnson", johnson_m(P)), ("TDM", tdm(P)[0]),
                        ("aleatória", random.sample(list(P), n))]:
            desvio[nome].append(100 * (cmax(s, P) - otimo) / otimo)
    return {nome: (100 * sum(1 for x in v if x < 1e-9) / len(v), statistics.mean(v), max(v))
            for nome, v in desvio.items()}


print("Complementos de IO — decks 3.2 e 3.3: experiência com 500 problemas aleatórios")
r2 = experiencia(2, 7, 500, 1)
r3 = experiencia(3, 7, 500, 2, cond=False)
for titulo, r in [("2 máquinas", r2), ("3 máquinas, sem a condição", r3)]:
    print("\n" + titulo)
    for nome, (pct, med, mx) in r.items():
        print("  %-10s ótima em %3.0f%%   desvio médio %4.1f%%   pior %4.1f%%" % (nome, pct, med, mx))

ok = (round(r2["Johnson"][0]) == 100 and round(r2["TDM"][0]) == 18 and round(r2["aleatória"][0]) == 8
      and round(r2["TDM"][1], 1) == 7.6 and round(r2["aleatória"][1], 1) == 13.4 and round(r2["TDM"][2]) == 27
      and round(r3["Johnson"][0]) == 49 and round(r3["Johnson"][1]) == 3 and round(r3["Johnson"][2]) == 21
      and round(r3["TDM"][0]) == 3 and round(r3["TDM"][1], 1) == 13.5 and round(r3["TDM"][2]) == 35
      and round(r3["aleatória"][0]) == 1 and round(r3["aleatória"][1], 1) == 19.6
      and round(r3["Johnson"][1], 1) == 3.1)
print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
