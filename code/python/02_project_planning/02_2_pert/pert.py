"""PERT: durações incertas, probabilidade de terminar a tempo e simulação (deck 2.2).

Um projeto PERT é um dicionário  acts3 = {nome: (precedentes, to, tm, tp)}.

Phi(z)                                  -> função de distribuição da normal reduzida
pert(acts3)                             -> te, var (dicionários), T (duração esperada), caminho crítico
beta_pert(a, m, b, n=200_000, rng=None) -> n durações sorteadas de uma Beta-PERT com média (a+4m+b)/6
simula_pert(acts3, N=200_000, semente=2026) -> T (N durações do projeto) e D (durações sorteadas)

Usa o CPM de 2.1 (pm.py).

Complementos de IO — deck 2.2.  J. F. A. Madeira — Licença MIT.
"""
from math import erf, sqrt

import numpy as np

from pm import cpm, topo


def Phi(z):
    """P(Z <= z) para Z ~ N(0, 1)."""
    return 0.5 * (1 + erf(z / sqrt(2)))


def pert(acts3):
    """te = (to + 4 tm + tp)/6 e var = ((tp - to)/6)^2; CPM com os te.

    Devolve te, var (dicionários), T (duração esperada do projeto) e a lista das atividades críticas.
    """
    te = {a: (v[1] + 4 * v[2] + v[3]) / 6 for a, v in acts3.items()}
    var = {a: ((v[3] - v[1]) / 6) ** 2 for a, v in acts3.items()}
    acts = {a: (v[0], te[a]) for a, v in acts3.items()}
    ES, EF, LS, LF, F, T = cpm(acts)
    crit = [a for a in acts if abs(F[a]) < 1e-9]
    return te, var, T, crit


def beta_pert(a, m, b, n=200_000, rng=None):
    """n valores de a + (b - a) X, X ~ Beta(1 + 4(m-a)/(b-a), 1 + 4(b-m)/(b-a)); média (a + 4m + b)/6."""
    if rng is None:
        rng = np.random.default_rng()
    if b == a:                                    # duração certa
        return np.full(n, float(a))
    al = 1 + 4 * (m - a) / (b - a)
    be = 1 + 4 * (b - m) / (b - a)
    return a + (b - a) * rng.beta(al, be, n)


def simula_pert(acts3, N=200_000, semente=2026):
    """Sorteia N vezes as durações de todas as atividades (Beta-PERT, independentes) e,
    em cada sorteio, calcula a duração do projeto com a passagem para a frente do CPM.

    Devolve T (vetor com as N durações do projeto) e D ({atividade: vetor das N durações}).
    """
    rng = np.random.default_rng(semente)
    D = {a: beta_pert(v[1], v[2], v[3], N, rng) for a, v in acts3.items()}
    EF = {}
    for a in topo(acts3):
        pre = acts3[a][0]
        ES = np.max([EF[p] for p in pre], axis=0) if pre else 0
        EF[a] = ES + D[a]
    T = np.max([EF[a] for a in acts3], axis=0)
    return T, D
