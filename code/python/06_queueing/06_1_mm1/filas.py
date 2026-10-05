"""Filas de espera: M/M/1 e simulação de eventos discretos (deck 6.1).

mm1(lam, mu)                                    -> dict rho, P0, L, Lq, W, Wq, Pn (função de n)
simula_mms(lam, mu, s, n=200000, seed=1, aquecimento=10000)
                                                -> dict Wq, W, Pw (P(esperar)), p95 (quantil 95% de Wq)

lam: taxa média de chegadas; mu: taxa média de serviço de um servidor (mesma unidade de tempo).
simula_mms com s = 1 é o código do slide «Confirmar com simulação»; com s > 1 serve para o M/M/s (deck 6.2).

Complementos de IO — deck 6.1.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np


def mm1(lam, mu):
    """Medidas do M/M/1 em regime estacionário (exige rho = lam/mu < 1).

    P0 = 1 - rho, Pn = (1 - rho) rho^n, L = rho/(1 - rho), Lq = rho^2/(1 - rho),
    W = 1/(mu - lam), Wq = lam/(mu (mu - lam)).
    """
    r = lam / mu
    assert r < 1, 'instável: lambda >= mu'
    return dict(rho=r, P0=1 - r, L=r / (1 - r), Lq=r * r / (1 - r),
                W=1 / (mu - lam), Wq=lam / (mu * (mu - lam)),
                Pn=lambda n: (1 - r) * r ** n)


def simula_mms(lam, mu, s, n=200000, seed=1, aquecimento=10000):
    """Simulação de uma fila FIFO com s servidores, chegadas e serviços exponenciais.

    Gera n chegadas (numpy.random.default_rng(seed): primeiro os n intervalos entre
    chegadas, depois os n tempos de serviço); cada cliente vai para o servidor que
    fica livre primeiro. Descarta os primeiros `aquecimento` clientes (arranque).
    Devolve as estimativas de Wq, W, P(esperar) e o quantil 95% da espera na fila.
    """
    rng = np.random.default_rng(seed)
    cheg = np.cumsum(rng.exponential(1 / lam, n))
    serv = rng.exponential(1 / mu, n)
    livre = np.zeros(s)                 # instante em que cada servidor fica livre
    espera = np.empty(n)
    for i in range(n):
        k = livre.argmin()
        ini = max(cheg[i], livre[k])
        espera[i] = ini - cheg[i]
        livre[k] = ini + serv[i]
    e = espera[aquecimento:]
    sv = serv[aquecimento:]
    return dict(Wq=e.mean(), W=(e + sv).mean(), Pw=(e > 0).mean(), p95=np.quantile(e, 0.95))
