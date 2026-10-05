"""Reproduz os exemplos do deck 6.3 (população finita, M/M/R).

Exemplo-guia: K = 10 empilhadores, lambda = 0.1 avarias/dia, mu = 0.8 reparações/dia;
técnico 150 €/dia, empilhador parado 250 €/dia. R = 1, 2, 3:
    P0 0.122, 0.283, 0.305; L 2.97, 1.35, 1.14; Lq 2.09, 0.26, 0.04; W 4.23, 1.55, 1.29 dias;
    custo 893, 636, 736 €/dia -> dois técnicos (menos 257 €/dia); com um técnico Wq ~ 2.98 dias;
    o 3.º técnico tira 0.2 empilhadores da paragem (50 €/dia) e custa 150.
População infinita: lambda = 1/dia contra mu = 0.8 dá rho = 1.25 (instável); na lavandaria 1 contra 0.4.
Para resolver na aula: Exemplo 3 (lavandaria, 5 máquinas, 3 mecânicos contra um super-mecânico):
L = 1.71 contra 1.16 -> trocar; Wq 0.11 contra 0.68 dias, W 2.61 contra 1.51 dias.

Correr (de qualquer pasta):  python ex06_3_mmr.py

Complementos de IO — deck 6.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from filas_mmr import mmR


def confere(v, alvo, casas):
    """v arredondado a `casas` casas decimais (por coluna) dá os valores do slide?"""
    v, alvo = np.asarray(v, float), np.asarray(alvo, float)
    return bool(np.all(np.abs(v - alvo) <= 0.5 * 10.0 ** -np.asarray(casas, float) + 1e-9))


ok = True
print("Complementos de IO — deck 6.3: população finita (M/M/R)")

# ------------------------------------------------------------ empilhadores
K, lam, mu, ct, cp = 10, 0.1, 0.8, 150, 250
print("\nEmpilhadores (K = %d, lambda = %g/dia, mu = %g/dia; técnico %d €/dia, parado %d €/dia)"
      % (K, lam, mu, ct, cp))
print("  R  P0     L (parados)  Lq    a funcionar  W (dias)  custo (€/dia)")
res, tab = [], []
for R in (1, 2, 3):
    e = mmR(K, R, lam, mu)
    custo = ct * R + cp * e['L']
    res.append(e)
    tab.append([e['P0'], e['L'], e['Lq'], e['a_funcionar'], e['W'], custo])
    print("  %d  %.3f  %.2f         %.2f  %.2f         %.2f      %.0f"
          % (R, e['P0'], e['L'], e['Lq'], e['a_funcionar'], e['W'], custo))
tab = np.array(tab)
best = int(tab[:, 5].argmin()) + 1
print("  decisão: %d técnicos (%.0f €/dia), menos %.0f €/dia do que com um só"
      % (best, tab[best - 1, 5], tab[0, 5] - tab[best - 1, 5]))
print("  com um técnico, Wq = W - 1/mu = %.2f dias" % res[0]['Wq'])
dL = res[1]['L'] - res[2]['L']
print("  o 3.º técnico tira %.1f empilhadores da paragem (%.1f €/dia) e custa %d €/dia" % (dL, cp * dL, ct))
ok &= (confere(tab, [[0.122, 2.97, 2.09, 7.03, 4.23, 893], [0.283, 1.35, 0.26, 8.65, 1.55, 636],
                    [0.305, 1.14, 0.04, 8.86, 1.29, 736]], [3, 2, 2, 2, 2, 0])
       and best == 2 and round(tab[0, 5] - tab[1, 5]) == 257 and round(res[0]['Wq'], 2) == 2.98
       and round(dL, 1) == 0.2 and round(cp * dL, -1) == 50)

# ------------------------------------------------------------ população infinita?
print("\nCom o modelo de população infinita: lambda = %g x %g = %g avarias/dia, mu = %g -> rho = %.2f (instável)"
      % (K, lam, K * lam, mu, K * lam / mu))
print("Na lavandaria: lambda = 5 x 0.2 = %g por dia contra mu = 0.4 de cada mecânico" % (5 * 0.2))
ok &= abs(K * lam / mu - 1.25) < 1e-12

# ------------------------------------------------------------ Exemplo 3 (para resolver na aula)
l3 = mmR(5, 3, 0.2, 1 / 2.5)
l1 = mmR(5, 1, 0.2, 1 / (5 / 6))
print("\nExemplo 3 — lavandaria (5 máquinas, lambda = 0.2/dia)")
print("  opção                        P0      L       Lq      a funcionar  W (dias)  Wq (dias)")
for nome, l in (("3 mecânicos (mu = 0.4)     ", l3), ("super-mecânico (mu = 1.2)  ", l1)):
    print("  %s  %.4f  %.4f  %.4f  %.4f       %.4f    %.4f"
          % (nome, l['P0'], l['L'], l['Lq'], l['a_funcionar'], l['W'], l['Wq']))
print("  decisão (mesmo salário): %s — menos máquinas paradas (%.2f contra %.2f)"
      % ("trocar pelo super-mecânico" if l1['L'] < l3['L'] else "manter os 3 mecânicos", l1['L'], l3['L']))
ok &= (round(l3['L'], 2) == 1.71 and round(l1['L'], 2) == 1.16 and l1['L'] < l3['L']
       and round(l3['Wq'], 2) == 0.11 and round(l1['Wq'], 2) == 0.68
       and round(l3['W'], 2) == 2.61 and round(l1['W'], 2) == 1.51)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
