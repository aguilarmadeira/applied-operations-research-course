"""Reproduz os exemplos do deck 1.3 (critérios probabilísticos).

Linha de produção com h = (0.3, 0.5, 0.2): VE = 44.5, 52, 37 e POE = 21.5, 14, 29 -> a2;
VE + POE = 66 em todas as linhas; informação perfeita 66, VEIP = 66 - 52 = 14.
Sensibilidade: h1 = 0.3 fixo, t = h3, h2 = 0.7 - t: VE = 43.5 + 5t, 48 + 20t, 23 + 70t;
a decisão passa de a2 para a3 em t = 0.5 (VE = 58).
Para resolver na aula: Exemplo 3 (investimento) com h = (0.3, 0.5, 0.2):
VE = 0, 265, 116 e POE = 460, 195, 344 -> obrigações; VEIP = 195.

Correr (de qualquer pasta):  python ex01_3_probabilistic_criteria.py

Complementos de IO — deck 1.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from criterios import intervalos_retas
from risco import risco


def fmt(v):
    return "  ".join("%.4g" % (0.0 if abs(x) < 1e-9 else x) for x in v)


def mostra(titulo, C, h, nomes):
    r = risco(C, h)
    print("\n" + titulo + ", h = (%s)" % ", ".join("%g" % x for x in h))
    print("  VE : %s -> %s" % (fmt(r["VE"]), ", ".join(nomes[i] for i in r["escolha_VE"])))
    print("  POE: %s -> %s" % (fmt(r["POE"]), ", ".join(nomes[i] for i in r["escolha_POE"])))
    print("  VE + POE: %s (igual em todas as linhas)" % fmt(r["soma"]))
    print("  com informação perfeita: %.4g;  VEIP = %.4g" % (r["info_perfeita"], r["VEIP"]))
    return r


ok = True
print("Complementos de IO — deck 1.3: critérios de decisão probabilísticos")

C = np.array([[40, 45, 50], [20, 60, 80], [-40, 50, 120]])
nomes = ["a1 pequena", "a2 média", "a3 grande"]
r = mostra("Linha de produção", C, [0.3, 0.5, 0.2], nomes)
ok &= (np.allclose(r["VE"], [44.5, 52, 37]) and np.allclose(r["POE"], [21.5, 14, 29])
       and np.allclose(r["soma"], 66) and abs(r["VEIP"] - 14) < 1e-9 and r["escolha_VE"] == [1])

# sensibilidade: VE_i(t) = 0.3 c_i1 + (0.7 - t) c_i2 + t c_i3 = a_i + b_i t
a = 0.3 * C[:, 0] + 0.7 * C[:, 1]
b = C[:, 2] - C[:, 1]
print("\nSensibilidade (h1 = 0.3, t = h3): VE = " + ", ".join("%.4g + %.4gt" % (x, y) for x, y in zip(a, b)))
iv = intervalos_retas(a, b, 0, 0.7)
for u, w, quem in iv:
    print("  t em [%.2f, %.2f]: %s" % (u, w, ", ".join(nomes[i] for i in quem)))
ok &= np.allclose(a, [43.5, 48, 23]) and np.allclose(b, [5, 20, 70])
ok &= [(round(u, 6), round(w, 6), q) for u, w, q in iv] == [(0, 0.5, [1]), (0.5, 0.7, [2])]
ok &= abs(48 + 20 * 0.5 - 58) < 1e-12

CI = [[1000, 0, -1500], [350, 200, 300], [220, 100, 0]]
ri = mostra("Exemplo 3 (investimento)", CI, [0.3, 0.5, 0.2], ["ações", "obrigações", "títulos"])
ok &= (np.allclose(ri["VE"], [0, 265, 116]) and np.allclose(ri["POE"], [460, 195, 344])
       and abs(ri["VEIP"] - 195) < 1e-9 and ri["escolha_VE"] == [1] == ri["escolha_POE"])

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
