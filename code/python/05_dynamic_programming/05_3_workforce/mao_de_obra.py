"""Gestão da mão-de-obra por programação dinâmica (deck 5.3).

O modelo das aulas: necessidades b[t] na semana t (nunca se trabalha com menos);
excesso ce por operário a mais por semana; contratar y > 0 pessoas custa cf + cv * y;
dispensar não custa. x0 = operários antes da semana 1 (por omissão 0).

mao_obra(b, ce, cf, cv, x0=0)                 -> (custo mínimo, plano)
mao_obra(b, ce, cf, cv, x0=0, tabelas=True)   -> (custo mínimo, plano, f, dec), com as tabelas da recursão
mao_obra_bruta(b, ce, cf, cv, x0=0)           -> (custo mínimo, lista de todos os planos ótimos)
custo_plano(b, ce, cf, cv, xs, x0=0)          -> (custo total, custos de cada semana) de um plano dado

Complementos de IO — deck 5.3.  J. F. A. Madeira — Licença MIT.
"""
import itertools


def mao_obra(b, ce, cf, cv, x0=0, tabelas=False):
    """Recursão para trás: f_t(s) = min_{b_t <= x <= max(b)} { c_t(s, x) + f_{t+1}(x) },  f_{n+1}(s) = 0.

    Etapa = semana; estado s = operários na semana anterior; decisão x = operários nesta semana.
    Devolve (f_1(x0), plano), com o plano lido para a frente (primeira decisão ótima em caso de empate).
    Com tabelas=True devolve também f e dec: f[t][s] = f_{t+1}(s) e dec[t][s] = lista das decisões
    ótimas (t = 0, ..., n-1; f[n] = 0 para todos os estados).
    """
    n, M = len(b), max(b)

    def custo(s, x, t):                               # c_t(s, x) = ce (x - b_t) + [x > s] (cf + cv (x - s))
        contrata = cf + cv * (x - s) if x > s else 0
        return ce * (x - b[t]) + contrata

    f = [dict() for _ in range(n + 1)]
    dec = [dict() for _ in range(n)]
    f[n] = {s: 0 for s in range(M + 1)}
    for t in range(n - 1, -1, -1):                    # semana n -> 1
        estados = [x0] if t == 0 else range(b[t - 1], M + 1)
        for s in estados:
            vals = {x: custo(s, x, t) + f[t + 1][x] for x in range(b[t], M + 1)}
            m = min(vals.values())
            f[t][s] = m
            dec[t][s] = [x for x, v in vals.items() if v == m]
    s, plano = x0, []                                  # ler o plano para a frente
    for t in range(n):
        s = dec[t][s][0]
        plano.append(s)
    if tabelas:
        return f[0][x0], plano, f, dec
    return f[0][x0], plano


def mao_obra_bruta(b, ce, cf, cv, x0=0):
    """Força bruta: percorre todos os planos com b_t <= x_t <= max(b).

    Devolve (custo mínimo, lista de todos os planos ótimos, como tuplos).
    """
    melhor = None
    for xs in itertools.product(*[range(bi, max(b) + 1) for bi in b]):
        c = custo_plano(b, ce, cf, cv, xs, x0)[0]
        if melhor is None or c < melhor[0]:
            melhor = (c, [xs])
        elif c == melhor[0]:
            melhor[1].append(xs)
    return melhor


def custo_plano(b, ce, cf, cv, xs, x0=0):
    """Custo de um plano xs (operários em cada semana): (total, lista dos custos de cada semana)."""
    custos, s = [], x0
    for x, bt in zip(xs, b):
        contrata = cf + cv * (x - s) if x > s else 0
        custos.append(ce * (x - bt) + contrata)
        s = x
    return sum(custos), custos
