"""O problema da mochila por programação dinâmica (deck 5.2).

w: pesos (inteiros), v: valores, W: capacidade (inteira).

mochila_ilimitada(w, v, W)            -> (f, esc): f[k] = valor máximo com capacidade k, k = 0..W;
                                         esc[k] = objetos que atingem f[k] (índices; vários se houver empate)
solucoes_ilimitada(w, v, W)           -> (melhor, sols): força bruta da mochila ilimitada (todas as soluções ótimas)
mochila_01(w, v, W)                   -> (valor, x): mochila 0-1, x[i] = 1 se o objeto i vai na mochila
mochila_01(w, v, W, tabela=True)      -> (valor, x, F): também a tabela F[i][k] = f_{i+1}(k)
forca_bruta_01(w, v, W)               -> (melhor, sols): força bruta da mochila 0-1
regra_racio(w, v, W, ilimitada=True)  -> (valor, x): escolher pelo maior v_i / w_i (pode falhar)

Complementos de IO — deck 5.2.  J. F. A. Madeira — Licença MIT.
"""
import itertools


def mochila_ilimitada(w, v, W):
    """f(k) = max_i { v_i + f(k - w_i) : w_i <= k },  f(k) = 0 se nada cabe.

    Calcula f(0), f(1), ..., f(W) por esta ordem. Devolve a tabela f e, para
    cada k, a lista esc[k] dos objetos que dão o máximo (vazia se nada cabe).
    """
    f = [0] * (W + 1)
    esc = [[] for _ in range(W + 1)]
    for k in range(1, W + 1):
        melhor, arg = 0, []
        for i in range(len(w)):
            if w[i] <= k:
                val = v[i] + f[k - w[i]]
                if val > melhor:
                    melhor, arg = val, [i]
                elif val == melhor and melhor > 0:
                    arg.append(i)
        f[k] = melhor
        esc[k] = arg
    return f, esc


def solucoes_ilimitada(w, v, W):
    """Força bruta da mochila ilimitada: valor ótimo e todas as soluções ótimas.

    Cada solução é um tuplo com o número de unidades de cada objeto.
    """
    def cargas():
        for m in itertools.product(*[range(W // x + 1) for x in w]):
            if sum(a * b for a, b in zip(m, w)) <= W:
                yield m
    melhor = max(sum(a * b for a, b in zip(m, v)) for m in cargas())
    sols = [m for m in cargas() if sum(a * b for a, b in zip(m, v)) == melhor]
    return melhor, sols


def mochila_01(w, v, W, tabela=False):
    """Mochila 0-1 por etapas: etapa i = objeto i; estado k = capacidade disponível.

    f_i(k) = max{ f_{i+1}(k)  (não),  v_i + f_{i+1}(k - w_i)  (sim, se w_i <= k) },  f_{n+1}(k) = 0.
    Resolve do último objeto para o primeiro e lê a solução para a frente a partir de f_1(W).
    Devolve (valor ótimo, x); com tabela=True devolve também F, com F[i][k] = f_{i+1}(k).
    """
    n = len(w)
    F = [[0] * (W + 1) for _ in range(n + 1)]
    for i in range(n - 1, -1, -1):                # último objeto -> primeiro
        for k in range(W + 1):
            F[i][k] = F[i + 1][k]                     # não
            if w[i] <= k:                             # sim
                F[i][k] = max(F[i][k], v[i] + F[i + 1][k - w[i]])
    x, k = [], W
    for i in range(n):
        x.append(int(F[i][k] != F[i + 1][k]))
        k -= w[i] * x[-1]
    if tabela:
        return F[0][W], x, F
    return F[0][W], x


def forca_bruta_01(w, v, W):
    """Força bruta da mochila 0-1: valor ótimo e todas as soluções ótimas (tuplos de 0 e 1)."""
    sols = [(sum(a * b for a, b in zip(m, v)), m) for m in itertools.product([0, 1], repeat=len(w))
            if sum(a * b for a, b in zip(m, w)) <= W]
    melhor = max(s for s, _ in sols)
    return melhor, [m for s, m in sols if s == melhor]


def regra_racio(w, v, W, ilimitada=True):
    """Regra do rácio: percorre os objetos por ordem decrescente de v_i / w_i (os empates
    pela ordem dada) e põe o que couber: todas as unidades possíveis (ilimitada) ou uma (0-1).

    Devolve (valor, x), com x[i] = unidades do objeto i. Não garante o ótimo.
    """
    ordem = sorted(range(len(w)), key=lambda i: -v[i] / w[i])
    x, k = [0] * len(w), W
    for i in ordem:
        x[i] = k // w[i] if ilimitada else int(w[i] <= k)
        k -= x[i] * w[i]
    return sum(a * b for a, b in zip(x, v)), x
