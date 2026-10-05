"""AHP: análise de sensibilidade dos pesos e dos juízos (deck 8.3).

pesos_com(w, k, p)               -> pesos com p no critério k; os restantes mantêm as proporções entre si
sensibilidade(M, w, k, grelha)   -> pontuações das alternativas quando o peso do critério k percorre a grelha
viragem(M, w, k, i, j)           -> peso do critério k em que as alternativas i e j empatam (None se fora de [0, 1])
ESCALA                           -> a escala de Saaty 1/9, ..., 1/2, 1, 2, ..., 9
perturba(A, rng, degraus=1)      -> matriz com cada juízo deslocado ao acaso até `degraus` posições na escala
simula_juizos(C, M, qualitativos=None, N=20000, degraus=1, seed=1)
                                 -> frequência do 1.º lugar de cada alternativa e fração de matrizes com RC > 0,1

Usa matriz e prioridades (deck 8.1, ahp.py) e agrega (deck 8.2, atributos.py).
Os índices começam em 0.

Complementos de IO — deck 8.3.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np

from ahp import matriz, prioridades
from atributos import agrega


def pesos_com(w, k, p):
    """Peso p no critério k; os restantes mantêm as proporções entre si e somam 1 - p:
    w_j(p) = w_j (1 - p) / (1 - w_k), j != k."""
    w = np.asarray(w, float)
    r = w.copy()
    r[k] = 0
    r = r / r.sum() * (1 - p)
    r[k] = p
    return r


def sensibilidade(M, w, k, grelha=np.linspace(0, 1, 21)):
    """Pontuações das alternativas (uma linha por valor da grelha) quando o peso do critério k percorre a grelha."""
    return np.array([agrega(M, pesos_com(w, k, p)) for p in grelha])


def viragem(M, w, k, i, j):
    """Peso do critério k em que as alternativas i e j empatam (None se não houver em [0, 1]).

    As pontuações são retas em p: S(p) = S(0) + p (M[:, k] - S(0)); com d0 = S_i(0) - S_j(0)
    e d1 = M[i, k] - M[j, k], o empate é em p* = d0 / (d0 - d1).
    """
    M = np.asarray(M, float)
    s0 = agrega(M, pesos_com(w, k, 0))
    d0 = s0[i] - s0[j]
    d1 = M[i, k] - M[j, k]
    if abs(d1 - d0) < 1e-15:
        return None
    p = d0 / (d0 - d1)
    return p if 0 <= p <= 1 else None


ESCALA = [1/9, 1/8, 1/7, 1/6, 1/5, 1/4, 1/3, 1/2, 1, 2, 3, 4, 5, 6, 7, 8, 9]


def perturba(A, rng, degraus=1):
    """Cada juízo acima da diagonal sobe/desce até `degraus` posições na escala de Saaty, ao acaso
    (fica dentro de 1/9, ..., 9); devolve a nova matriz recíproca. rng: numpy.random.Generator."""
    A = np.asarray(A, float)
    n = len(A)
    J = {}
    for i in range(n):
        for j in range(i + 1, n):
            k = min(range(17), key=lambda t: abs(ESCALA[t] - A[i, j]))
            J[(i, j)] = ESCALA[int(np.clip(k + rng.integers(-degraus, degraus + 1), 0, 16))]
    return matriz(n, J)


def simula_juizos(C, M, qualitativos=None, N=20000, degraus=1, seed=1):
    """Frequência com que cada alternativa fica em 1.º lugar quando todos os juízos são perturbados.

    C: matriz de comparação dos critérios; M: prioridades locais (alternativas x critérios).
    qualitativos: {coluna de M: matriz de comparação das alternativas nesse critério}; essas
    colunas são recalculadas a partir da matriz perturbada.
    Devolve (frequências do 1.º lugar, fração das matrizes dos critérios com RC > 0,1).
    """
    rng = np.random.default_rng(seed)
    M = np.asarray(M, float)
    vit = np.zeros(len(M))
    inc = 0
    for _ in range(N):
        Cr = perturba(C, rng, degraus)
        w, _, _, rc = prioridades(Cr)
        inc += rc > 0.1
        Mr = M.copy()
        for k, S in (qualitativos or {}).items():
            Mr[:, k] = prioridades(perturba(S, rng, degraus))[0]
        vit[np.argmax(Mr @ w)] += 1
    return vit / N, inc / N
