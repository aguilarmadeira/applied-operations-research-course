"""Filas de espera: capacidade limitada (M/M/1/K) e vários servidores (M/M/s) (deck 6.2).

mm1k(lam, mu, K)                          -> dict rho, P (lista P_0..P_K), P0, PK, L, Lq, lef, W, Wq
mms(lam, mu, s)                           -> dict a, rho, P0, Pw (Erlang C), Lq, Wq, W, L, Pn (função de n)
custo_caixas(lam, mu, c_serv, c_esp, smax=10, base='Lq')
                                          -> lista de (s, Pw, Lq, L, custo) para s estável até smax
simula_mm1k(lam, mu, K, n=200000, seed=1) -> dict PK (fração de perdidos), W

custo(s) = c_serv * s + c_esp * Lq(s) (ou * L(s), com base='L'), com c_serv e c_esp na mesma
unidade de tempo de lam e mu. A simulação do M/M/s é simula_mms, do deck 6.1 (filas.py).

Complementos de IO — deck 6.2.  J. F. A. Madeira — Licença MIT.
"""
from math import factorial

import numpy as np


def mm1k(lam, mu, K):
    """M/M/1/K: capacidade K (quem chega com o sistema cheio perde-se); rho pode ser >= 1.

    P_n = (1 - rho) rho^n / (1 - rho^(K+1)), n = 0..K (P_n = 1/(K+1) se rho = 1);
    lef = lam (1 - P_K) é a taxa de quem entra; W = L/lef, Wq = Lq/lef.
    """
    r = lam / mu
    if abs(r - 1) < 1e-12:
        P = [1 / (K + 1)] * (K + 1)
    else:
        P = [(1 - r) * r ** n / (1 - r ** (K + 1)) for n in range(K + 1)]
    L = sum(n * p for n, p in enumerate(P))
    Lq = sum((n - 1) * p for n, p in enumerate(P) if n >= 1)
    lef = lam * (1 - P[K])
    return dict(rho=r, P=P, P0=P[0], PK=P[K], L=L, Lq=Lq, lef=lef, W=L / lef, Wq=Lq / lef)


def mms(lam, mu, s):
    """M/M/s em regime estacionário (exige rho = lam/(s mu) < 1).

    a = lam/mu; P0 = [sum_{n<s} a^n/n! + a^s/(s! (1 - rho))]^(-1);
    Pw = P(esperar) = a^s/(s! (1 - rho)) P0 (fórmula C de Erlang); Lq = Pw rho/(1 - rho);
    Wq = Lq/lam, W = Wq + 1/mu, L = Lq + a (= lam W).
    """
    a = lam / mu
    r = a / s
    assert r < 1, 'instável'
    P0 = 1 / (sum(a ** n / factorial(n) for n in range(s)) + a ** s / (factorial(s) * (1 - r)))
    Pw = a ** s / factorial(s) * P0 / (1 - r)          # P(esperar) = P(j >= s) (Erlang C)
    Lq = Pw * r / (1 - r)
    Wq = Lq / lam
    return dict(a=a, rho=r, P0=P0, Pw=Pw, Lq=Lq, Wq=Wq, W=Wq + 1 / mu, L=Lq + a,
                Pn=lambda n: P0 * a ** n / factorial(n) if n < s
                else P0 * a ** n / (factorial(s) * s ** (n - s)))


def custo_caixas(lam, mu, c_serv, c_esp, smax=10, base='Lq'):
    """Custo por unidade de tempo de s servidores, do primeiro s estável (s > lam/mu) até smax.

    Devolve [(s, Pw, Lq, L, custo)], com custo = c_serv s + c_esp * (Lq ou L, conforme base).
    """
    out = []
    for s in range(int(lam // mu) + 1, smax + 1):
        m = mms(lam, mu, s)
        out.append((s, m['Pw'], m['Lq'], m['L'], c_serv * s + c_esp * m[base]))
    return out


def simula_mm1k(lam, mu, K, n=200000, seed=1):
    """Simulação do M/M/1/K com bloqueio: quem chega com o sistema cheio (K) desiste.

    Por cada chegada (numpy.random.default_rng(seed)) sorteia-se o intervalo desde a anterior
    e, se entrar, o seu tempo de serviço. Devolve a fração de perdidos e o tempo médio no
    sistema de quem entra.
    """
    rng = np.random.default_rng(seed)
    t = 0.0
    fila = []                           # instantes de saída de quem está no sistema
    perdidos = 0
    tempos = []
    for i in range(n):
        t += rng.exponential(1 / lam)
        fila = [x for x in fila if x > t]
        if len(fila) >= K:
            perdidos += 1
            continue
        ini = max(t, fila[-1]) if fila else t
        sai = ini + rng.exponential(1 / mu)
        fila.append(sai)
        tempos.append(sai - t)
    return dict(PK=perdidos / n, W=np.mean(tempos))
