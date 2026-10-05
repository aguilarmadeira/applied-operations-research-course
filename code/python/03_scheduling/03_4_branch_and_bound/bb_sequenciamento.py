"""Branch and bound para sequenciamento (deck 3.4).

lb_fs(seq, P)   -> limite inferior do tempo total de qualquer sequência que comece por seq
bb_fs(P)        -> ((T ótimo, 'sequência'), nós gerados): flow shop, tempo total
atraso(seq, p, d) -> atraso total sum max(0, C_j - d_j) numa máquina
bb_atraso(p, d) -> ((atraso ótimo, 'sequência'), nós gerados): uma máquina, atraso total

Exploração best-first (o nó de menor limite primeiro; empates pela ordem dos nomes).
Poda-se um nó quando o seu limite é >= ao valor do incumbente; sem incumbente não se poda.
Os nós gerados vêm numa lista de ('sequência parcial', limite), pela ordem em que são gerados.

Complementos de IO — deck 3.4.  J. F. A. Madeira — Licença MIT.
"""
import heapq

from sequenciamento import tempos


# ---------- flow shop, tempo total (limite de Ignall e Schrage) ----------
def lb_fs(seq, P):
    """max_i ( C_i + soma em U dos tempos na máquina i + min em U do que falta depois de i ).

    C_i: conclusão da sequência parcial seq na máquina i; U: trabalhos por sequenciar.
    """
    m = len(next(iter(P.values())))
    U = [j for j in P if j not in seq]
    c = tempos(seq, P)[-1] if seq else [0] * m
    if not U:
        return c[-1]
    return max(c[i] + sum(P[j][i] for j in U) + min(sum(P[j][i + 1:]) for j in U)
               for i in range(m))


def bb_fs(P):
    """Fixam-se os trabalhos a partir da primeira posição; limite lb_fs."""
    best = (float("inf"), None)
    h = [(lb_fs([], P), ())]
    nos = []
    while h:
        b, s = heapq.heappop(h)
        if b >= best[0]:
            continue                                  # podado
        for j in P:
            if j in s:
                continue
            t = s + (j,)
            v = lb_fs(list(t), P)
            nos.append(("".join(t), v))
            if len(t) == len(P):
                if v < best[0]:
                    best = (v, "".join(t))            # novo incumbente
            elif v < best[0]:
                heapq.heappush(h, (v, t))
    return best, nos


# ---------- uma máquina, atraso total (sequência construída a partir do fim) ----------
def atraso(seq, p, d):
    """Atraso total: soma de max(0, C_j - d_j), com C_j o instante de conclusão de j."""
    t = 0
    T = 0
    for j in seq:
        t += p[j]
        T += max(0, t - d[j])
    return T


def bb_atraso(p, d):
    """Fixam-se os trabalhos a partir da última posição.

    Limite = atraso dos trabalhos já fixados no fim (a sua conclusão é conhecida:
    soma de todos os p menos a soma dos que vêm depois).
    """
    P = sum(p.values())
    best = (float("inf"), None)

    def lb(suf):                      # suf: trabalhos do fim, pela ordem em que ficam
        t = P - sum(p[j] for j in suf)
        T = 0
        for j in suf:
            t += p[j]
            T += max(0, t - d[j])
        return T

    h = [(0, ())]
    nos = []
    while h:
        b, suf = heapq.heappop(h)
        if b >= best[0]:
            continue                                  # podado
        for j in p:
            if j in suf:
                continue
            s = (j,) + suf
            v = lb(s)
            nos.append(("".join(s), v))
            if len(s) == len(p):
                if v < best[0]:
                    best = (v, "".join(s))            # novo incumbente
            elif v < best[0]:
                heapq.heappush(h, (v, s))
    return best, nos
