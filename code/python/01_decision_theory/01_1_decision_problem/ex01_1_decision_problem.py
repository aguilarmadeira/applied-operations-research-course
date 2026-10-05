"""Reproduz os exemplos do deck 1.1 (o problema de decisão).

Slide «Boa decisão ≠ boa consequência»: moeda, +30 € / -10 €  =>  10 € por jogada.
Slide «Quantas tendas alugar?»: L(t, d) = 500 min(t, d) - 300 t, t, d em {2, 3, 4}.
Para discutir na aula: Exemplo 2 (dado)  =>  15 € por lançamento;
Exemplo 3 (investimento): os títulos do tesouro são dominados pelas obrigações.

No fim compara com os slides.
Correr (de qualquer pasta):  python ex01_1_decision_problem.py

Complementos de IO — deck 1.1.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from decisao import matriz, dominadas

ok = True
print("Complementos de IO — deck 1.1: o problema de decisão")

# ------------------------------------------------------------ a moeda
ve_moeda = 0.5 * 30 + 0.5 * (-10)
print("\nMoeda: 1/2 x 30 + 1/2 x (-10) = %g € por jogada" % ve_moeda)

# ------------------------------------------------------------ as tendas
t = d = [2, 3, 4]
L = matriz(lambda t, d: 500 * min(t, d) - 300 * t, t, d)
print("\nTendas: L(t, d) = 500 min(t, d) - 300 t")
print("  alugar t \\ precisas d:      2      3      4")
for ti, linha in zip(t, L):
    print("  %d                       " % ti + "  ".join("%5.0f" % v for v in linha))
print("  ações dominadas:", dominadas(L) or "nenhuma")

# ------------------------------------------------------------ Exemplo 2: o dado
ve_dado = 5 / 6 * 20 - 1 / 6 * 10
print("\nExemplo 2 (dado): 5/6 x 20 - 1/6 x 10 = %g € por lançamento" % ve_dado)

# ------------------------------------------------------------ Exemplo 3: investimento
nomes = ["comprar ações", "comprar obrigações", "comprar títulos do tesouro"]
C = [[1000, 0, -1500], [350, 200, 300], [220, 100, 0]]
dom = dominadas(C)
print("\nExemplo 3 (investimento; subida, estável, descida):")
for i, k in dom:
    print("  %s é dominada por %s" % (nomes[i], nomes[k]))

c = [ve_moeda == 10,
     np.array_equal(L, [[400, 400, 400], [100, 600, 600], [-200, 300, 800]]),
     dominadas(L) == [], abs(ve_dado - 15) < 1e-12, dom == [(2, 1)]]
ok = all(c)
print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
