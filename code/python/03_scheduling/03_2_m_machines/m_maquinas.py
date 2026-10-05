"""Johnson com três ou mais máquinas: condição e redução a duas máquinas fictícias (deck 3.2).

reduz(P)      -> (G, H): G = M1 + ... + M(m-1), H = M2 + ... + Mm (dicionários trabalho -> tempo)
condicao(P)   -> (verifica?, (min M1, min Mm, máx. das máquinas intermédias))
johnson_m(P)  -> sequência de Johnson: em (M1, M2) se m = 2; em (G, H) se m >= 3

A condição: min M1 >= máx. de cada máquina intermédia, ou min Mm >= máx. de cada máquina
intermédia. Se se verificar, Johnson em (G, H) dá o ótimo; se não, é só uma heurística
(johnson_m não verifica a condição: use condicao primeiro).

Complementos de IO — deck 3.2.  J. F. A. Madeira — Licença MIT.
"""
from sequenciamento import johnson


def reduz(P):
    """m máquinas -> 2 fictícias: G = M1 + ... + M(m-1), H = M2 + ... + Mm."""
    G = {j: sum(t[:-1]) for j, t in P.items()}
    H = {j: sum(t[1:]) for j, t in P.items()}
    return G, H


def condicao(P):
    """Condição de Johnson para m >= 3 máquinas.

    Devolve (True/False, (min M1, min Mm, máx. das máquinas 2..m-1)); com m <= 2, (True, None).
    """
    m = len(next(iter(P.values())))
    if m <= 2:
        return True, None
    meio = max(max(t[1:-1]) for t in P.values())
    m1 = min(t[0] for t in P.values())
    mm = min(t[-1] for t in P.values())
    return (m1 >= meio or mm >= meio), (m1, mm, meio)


def johnson_m(P):
    """Johnson com m máquinas: com 2, diretamente; com m >= 3, nas máquinas fictícias (G, H)."""
    if len(next(iter(P.values()))) == 2:
        return johnson({j: t[0] for j, t in P.items()}, {j: t[1] for j, t in P.items()})
    G, H = reduz(P)
    return johnson(G, H)
