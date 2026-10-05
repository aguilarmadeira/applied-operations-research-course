"""Reproduz os exemplos do deck 1.4 (probabilidades subjetivas).

Linha de produção: «alta tão provável como média» e «média 3 vezes mais provável do que baixa»
=> P = (1/7, 3/7, 3/7); VE = 325/7, 440/7, 470/7 -> a3 grande.
Resposta a mais «alta 2 vezes mais provável do que baixa»: as respostas implicam 3 -> incoerente.
Para resolver na aula: vantagens 3 para 1 e 2 para 1 => P = (6/9, 2/9, 1/9);
no investimento, VE = 500, 311.1, 168.9 -> ações; com «1 para 3» e «1 para 2»,
P = (1/10, 3/10, 6/10) e VE = -800, 275, 52 -> obrigações.

Correr (de qualquer pasta):  python ex01_4_subjective_probabilities.py

Complementos de IO — deck 1.4.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from risco import risco
from subjetivas import prob_razoes


def frac(P):
    """Probabilidades como frações com denominador comum (como nos slides: 6/9, 2/9, 1/9)."""
    d = next(d for d in range(1, 101) if np.allclose(np.asarray(P) * d, np.round(np.asarray(P) * d)))
    return ", ".join("%d/%d" % (round(x * d), d) for x in P)


ok = True
print("Complementos de IO — deck 1.4: probabilidades subjetivas")

# ------------------------------------------------------------ linha de produção (baixa, média, alta)
C = np.array([[40, 45, 50], [20, 60, 80], [-40, 50, 120]])
nomes = ["a1 pequena", "a2 média", "a3 grande"]
P, _ = prob_razoes(3, [(2, 1, 1), (1, 0, 3)])
r = risco(C, P)
print("\nLinha de produção: P(alta)/P(média) = 1, P(média)/P(baixa) = 3")
print("  P = (%s)" % frac(P))
print("  VE = %s -> %s" % ("  ".join("%.1f" % v for v in r["VE"]), nomes[r["escolha_VE"][0]]))
_, ver = prob_razoes(3, [(2, 1, 1), (1, 0, 3), (2, 0, 2)])
i, k, rd, ri, coer = ver[0]
print("  resposta a mais P(alta)/P(baixa) = %g; as outras implicam %g -> %s"
      % (rd, ri, "coerente" if coer else "incoerente"))
ok &= np.allclose(P, [1 / 7, 3 / 7, 3 / 7]) and np.allclose(r["VE"] * 7, [325, 440, 470])
ok &= r["escolha_VE"] == [2] and not coer and abs(ri - 3) < 1e-9

# ------------------------------------------------------------ para resolver na aula
CI = [[1000, 0, -1500], [350, 200, 300], [220, 100, 0]]
NI = ["ações", "obrigações", "títulos"]
P1, _ = prob_razoes(3, [(0, 1, 3), (1, 2, 2)])
r1 = risco(CI, P1)
print("\nExemplo: P1/P2 = 3, P2/P3 = 2  =>  P = (%s)" % frac(P1))
print("  investimento: VE = %s -> %s" % ("  ".join("%.1f" % v for v in r1["VE"]), NI[r1["escolha_VE"][0]]))
P2, _ = prob_razoes(3, [(0, 1, 1 / 3), (1, 2, 1 / 2)])
r2 = risco(CI, P2)
print("Com «1 para 3» e «1 para 2»: P = (%s)" % frac(P2))
print("  investimento: VE = %s -> %s" % ("  ".join("%.1f" % v for v in r2["VE"]), NI[r2["escolha_VE"][0]]))
ok &= np.allclose(P1, [6 / 9, 2 / 9, 1 / 9]) and np.allclose(r1["VE"], [500, 2800 / 9, 1520 / 9]) and r1["escolha_VE"] == [0]
ok &= np.allclose(P2, [0.1, 0.3, 0.6]) and np.allclose(r2["VE"], [-800, 275, 52]) and r2["escolha_VE"] == [1]

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
