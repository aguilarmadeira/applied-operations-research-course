"""Filas de espera com população finita: M/M/R/GD/K/K (deck 6.3).

mmR(K, R, lam, mu) -> dict P (lista P_0..P_K), P0, L, Lq, a_funcionar, lef, W, Wq

K máquinas (população = capacidade), R reparadores (os servidores);
lam = taxa de avaria de uma máquina a funcionar; mu = taxa de reparação de um reparador.

Complementos de IO — deck 6.3.  J. F. A. Madeira — Licença MIT.
"""
from math import comb, factorial


def mmR(K, R, lam, mu):
    """M/M/R com população finita K (problema da reparação de máquinas); r = lam/mu.

    P_n = C(K, n) r^n P0 se n <= R;  P_n = C(K, n) n!/(R! R^(n-R)) r^n P0 se n > R;
    L = sum n P_n (paradas), Lq = sum_{n>R} (n - R) P_n, lef = lam (K - L), W = L/lef, Wq = Lq/lef.
    Não há condição de estabilidade (quem está avariado não volta a avariar).
    """
    r = lam / mu
    w = [comb(K, j) * r ** j if j <= R
         else comb(K, j) * factorial(j) * r ** j / (factorial(R) * R ** (j - R))
         for j in range(K + 1)]
    P0 = 1 / sum(w)
    P = [x * P0 for x in w]
    L = sum(j * p for j, p in enumerate(P))
    Lq = sum((j - R) * p for j, p in enumerate(P) if j > R)
    lef = lam * (K - L)
    return dict(P=P, P0=P0, L=L, Lq=Lq, a_funcionar=K - L, lef=lef, W=L / lef, Wq=Lq / lef)
