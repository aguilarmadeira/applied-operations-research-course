"""Falhas súbitas: substituição individual e substituição de grupo (deck 4.3).

falhas(n, Pacum, T=12)                      -> (p, vida, N): p_t, vida média e falhas esperadas N_1, ..., N_T
grupo(n, ci, cg, Pacum, T=None)             -> (p, vida, K_ind, tabela da política de grupo)
simula(n, Pacum, T=8, runs=4000, seed=1)    -> falhas médias por período, por simulação de Monte Carlo

n: número de unidades; Pacum: probabilidades acumuladas de uma unidade nova ter falhado até ao fim
de cada período (a última é 1); ci: custo de uma troca individual; cg: custo por unidade na troca de grupo.
    p_t = P(t) - P(t-1);  vida média = soma t p_t;  individual: K_ind = (n / vida) c_i por período;
    N_t = n p_t + N_1 p_{t-1} + ... + N_{t-1} p_1;
    grupo de t em t períodos: K(t) = (c_i (N_1 + ... + N_t) + n c_g) / t.

Complementos de IO — deck 4.3.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np


def falhas(n, Pacum, T=12):
    """Probabilidades p_t de falhar no período t, vida média e falhas esperadas N_t (com renovação).

    Devolve (p, vida, N), com N[t-1] = N_t para t = 1, ..., max(len(p), T).
    """
    p = [Pacum[0]] + [Pacum[i] - Pacum[i - 1] for i in range(1, len(Pacum))]
    vida = sum((i + 1) * x for i, x in enumerate(p))
    N = [n]                                   # N[0] = n: as unidades instaladas no instante 0
    for t in range(1, 1 + max(len(p), T)):
        N.append(sum(N[k] * p[t - k - 1] for k in range(t) if t - k - 1 < len(p)))
    return p, vida, N[1:]


def grupo(n, ci, cg, Pacum, T=None):
    """Política individual contra política de grupo de t em t períodos (t = 1, ..., T; por omissão T = len(p)).

    Devolve (p, vida, K_ind, L), em que L tem uma linha por t:
    (t, N_t, soma N_k, c_i soma N_k, n c_g, total, K(t) = total / t).
    """
    p, vida, N = falhas(n, Pacum, T or 12)
    ind = n / vida * ci
    T = T or len(p)
    L, soma = [], 0
    for t in range(1, T + 1):
        soma += N[t - 1]
        tot = soma * ci + n * cg
        L.append((t, N[t - 1], soma, soma * ci, n * cg, tot, tot / t))
    return p, vida, ind, L


def simula(n, Pacum, T=8, runs=4000, seed=1):
    """Simulação de Monte Carlo das falhas por período com a política individual.

    Cada unidade recebe o período em que falha; quando falha no período t, é substituída por uma nova
    no fim de t. Devolve a média, em runs corridas, do número de falhas em cada período 1, ..., T
    (estima N_t). Semente fixa (seed) para resultados reprodutíveis.
    """
    p = np.diff([0] + list(Pacum))
    vida = np.arange(1, len(p) + 1)
    rng = np.random.default_rng(seed)
    F = np.zeros(T)
    for _ in range(runs):
        falha = rng.choice(vida, size=n, p=p)            # período da primeira falha de cada unidade
        for t in range(1, T + 1):
            f = falha == t
            k = f.sum()
            F[t - 1] += k
            falha[f] = t + rng.choice(vida, size=k, p=p)  # substituída no fim de t
    return F / runs
