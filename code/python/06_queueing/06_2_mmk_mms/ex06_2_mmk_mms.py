"""Reproduz os exemplos do deck 6.2 (capacidade limitada e vários servidores).

M/M/1/K no posto de 6.1 (lambda = 3/h, mu = 4/h), K = 2..6 e infinito: P_K, lambda_ef, L, W;
com K = 4, 10.4% desistem (0.31 por hora) e quem fica está 32 min; simula_mm1k(3, 4, 4) compara-se
com as fórmulas com tolerância.
M/M/s com lambda = 6/h: s = 2..5 -> P(esperar) 0.643, 0.237, 0.075, 0.020 e Wq 19.3, 2.4, 0.45, 0.09 min.
Fila única (M/M/2, 19.3 min) contra duas filas separadas (duas M/M/1, 45 min).
Custo 12 s + 20 Lq (custo_caixas): 62.57, 40.74, 48.90, 60.17 €/h -> 3 carregadores;
nível de serviço «menos de 10% esperam» -> 4 (7.5%), mais 8.16 €/h. simula_mms(6, 4, 3): Wq ~ 2.4 min.
Para resolver na aula: Exemplo 2 (restaurante, M/M/1/K com K = 300): Lq = 4/3, P(fila) = 44.4%,
W = 18 s, igual ao M/M/1 (P_K ~ 5e-54).

Correr (de qualquer pasta):  python ex06_2_mmk_mms.py

Complementos de IO — deck 6.2.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from filas import mm1, simula_mms
from filas_mms import mm1k, mms, custo_caixas, simula_mm1k


def confere(v, alvo, casas):
    """v arredondado a `casas` casas decimais (por coluna) dá os valores do slide?"""
    v, alvo = np.asarray(v, float), np.asarray(alvo, float)
    return bool(np.all(np.abs(v - alvo) <= 0.5 * 10.0 ** -np.asarray(casas, float) + 1e-9))


ok = True
print("Complementos de IO — deck 6.2: capacidade limitada e vários servidores")

# ------------------------------------------------------------ M/M/1/K
lam, mu = 3, 4
print("\nM/M/1/K: posto de carregamento com K lugares (lambda = 3/h, mu = 4/h)")
print("  K    P_K    lambda_ef    L     W (min)")
tab = []
for K in (2, 3, 4, 5, 6):
    x = mm1k(lam, mu, K)
    tab.append([x['PK'], x['lef'], x['L'], x['W'] * 60])
    print("  %-3d  %.3f  %.2f         %.2f  %.0f" % (K, x['PK'], x['lef'], x['L'], x['W'] * 60))
m = mm1(lam, mu)
print("  inf  0      %.4g            %.4g     %.4g" % (lam, m['L'], m['W'] * 60))
k4 = mm1k(lam, mu, 4)
print("  K = 4: desistem %.1f%% (%.2f por hora); quem fica está %.0f min"
      % (100 * k4['PK'], lam * k4['PK'], k4['W'] * 60))
ok &= confere(tab, [[0.243, 2.27, 0.81, 21], [0.154, 2.54, 1.15, 27], [0.104, 2.69, 1.44, 32],
                   [0.072, 2.78, 1.70, 37], [0.051, 2.85, 1.92, 41]], [3, 2, 2, 0])
ok &= round(lam * k4['PK'], 2) == 0.31

sk = simula_mm1k(lam, mu, 4)
print("Simulação (simula_mm1k(3, 4, 4): 200000 chegadas, semente 1)")
print("  desistem %.1f%% (fórmula %.1f%%)  W = %.0f min (%.0f)"
      % (100 * sk['PK'], 100 * k4['PK'], sk['W'] * 60, k4['W'] * 60))
tol = abs(sk['PK'] - k4['PK']) <= 0.02 and abs(sk['W'] - k4['W']) <= 0.10 * k4['W']
print("  simulação dentro da tolerância (10%% nas médias, 0.02 nas probabilidades): %s" % ("sim" if tol else "não"))
ok &= tol

# ------------------------------------------------------------ M/M/s
lam = 6
print("\nM/M/s: a procura duplica (lambda = 6/h, mu = 4/h)")
print("  s  P(esperar)  Lq     Wq (min)")
v = []
for s in (2, 3, 4, 5):
    y = mms(lam, mu, s)
    v.append([y['Pw'], y['Lq'], y['Wq'] * 60])
    print("  %d  %.3f       %.3f  %.2f" % (s, y['Pw'], y['Lq'], y['Wq'] * 60))
v = np.array(v)
ok &= (confere(v[:, 0], [0.643, 0.237, 0.075, 0.020], 3)
       and confere(v[:, 1], [1.93, 0.24, 0.045, 0.009], [2, 2, 3, 3])
       and confere(v[:, 2], [19.3, 2.4, 0.45, 0.09], [1, 1, 2, 2]))

# ------------------------------------------------------------ fila única ou separadas
sep, uni = mm1(3, mu)['Wq'] * 60, mms(6, mu, 2)['Wq'] * 60
print("\nFila única ou uma fila por carregador (2 carregadores, lambda = 6/h)")
print("  duas filas separadas (duas M/M/1, lambda = 3): Wq = %.1f min" % sep)
print("  uma fila única (M/M/2, lambda = 6):            Wq = %.1f min" % uni)
ok &= round(sep, 1) == 45 and round(uni, 1) == 19.3

# ------------------------------------------------------------ custo contra espera
print("\nQuantos carregadores? custo(s) = 12 s + 20 Lq(s) (€/h)")
print("  s  carregadores  espera  total")
tc = custo_caixas(lam, mu, 12, 20, 5)
for s, Pw, Lq, L, c in tc:
    print("  %d  %-12.0f  %-6.2f  %.2f" % (s, 12 * s, 20 * Lq, c))
c = np.array([r[4] for r in tc])
smin = tc[int(c.argmin())][0]
iserv = next(i for i, r in enumerate(tc) if r[1] < 0.10)
sserv = tc[iserv][0]
print("  mínimo custo: %d carregadores (%.2f €/h); esperam %.1f%%"
      % (smin, c.min(), 100 * tc[int(c.argmin())][1]))
print("  menos de 10%% esperam: %d carregadores (%.1f%%), %.2f €/h; preço do nível de serviço %.2f €/h"
      % (sserv, 100 * tc[iserv][1], c[iserv], c[iserv] - c.min()))
ok &= ([r[0] for r in tc] == [2, 3, 4, 5] and confere(c, [62.57, 40.74, 48.90, 60.17], 2)
       and smin == 3 and sserv == 4 and round(c[iserv] - c.min(), 2) == 8.16)

sm = simula_mms(lam, mu, 3)
y3 = mms(lam, mu, 3)
print("Simulação (simula_mms(6, 4, 3), semente 1)")
print("  Wq = %.2f min (fórmula %.2f)  P(esperar) = %.3f (%.3f)"
      % (sm['Wq'] * 60, y3['Wq'] * 60, sm['Pw'], y3['Pw']))
tol = abs(sm['Wq'] - y3['Wq']) <= 0.10 * y3['Wq'] and abs(sm['Pw'] - y3['Pw']) <= 0.02
print("  simulação dentro da tolerância (10%% nas médias, 0.02 nas probabilidades): %s" % ("sim" if tol else "não"))
ok &= tol

# ------------------------------------------------------------ Exemplo 2 (para resolver na aula)
z = mm1k(400, 600, 300)
zi = mm1(400, 600)
pfila = 1 - z['P'][0] - z['P'][1]
print("\nExemplo 2 — restaurante (M/M/1/GD/300/inf, lambda = 400/h, mu = 600/h)")
print("  a) Lq = %.4f clientes" % z['Lq'])
print("  b) P(haver fila) = 1 - P0 - P1 = %.4f (%.1f%%)" % (pfila, 100 * pfila))
print("  c) W = %.4g s" % (z['W'] * 3600))
print("  d) M/M/1 sem limite: Lq = %.4f, P(fila) = rho^2 = %.4f, W = %.4g s; P_K = %.1e: o limite não conta"
      % (zi['Lq'], zi['rho'] ** 2, zi['W'] * 3600, z['PK']))
ok &= (abs(z['Lq'] - 4 / 3) < 1e-9 and abs(pfila - 4 / 9) < 1e-9 and abs(z['W'] * 3600 - 18) < 1e-9
       and abs(zi['Lq'] - z['Lq']) < 1e-9 and z['PK'] < 1e-50)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
