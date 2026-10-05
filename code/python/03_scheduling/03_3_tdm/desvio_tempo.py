"""Método do desvio de tempo, TDM (time deviation method) (deck 3.3).

desvios(a, b, rest)            -> {trabalho: ((desvio máq., desvio trab.) na máq. 1, (...) na máq. 2)}
tdm2(a, b, jobs=None, log=False) -> (sequência do TDM, sequência construída), duas máquinas
tdm(P, log=False)              -> o mesmo para m máquinas (com m >= 3, nas fictícias (G, H) de 3.2)

Em cada iteração, só com os trabalhos por atribuir:
  desvio na máquina  = maior tempo dessa máquina - tempo;
  desvio no trabalho = maior tempo desse trabalho - tempo.
Células (0, 0) na máquina 1 entram na sequência em construção pela frente (a seguir às que
já lá estão); na máquina 2 entram por trás (antes das que já lá estão no fim). No fim inverte-se.

Desempate (tal como nos decks): várias células (0, 0) na mesma máquina ordenam-se pela maior
soma dos quatro desvios do trabalho; por trás, o bloco ordenado entra todo à esquerda do que já
lá está, pelo que a de maior soma fica mais longe do fim. Um trabalho com (0, 0) nas duas
máquinas entra pela frente. Ver o README desta pasta (a regra tem outra leitura possível).

Complementos de IO — deck 3.3.  J. F. A. Madeira — Licença MIT.
"""
from m_maquinas import reduz


def desvios(a, b, rest):
    """Tabela de desvios dos trabalhos em rest (os ainda por atribuir).

    Para cada j: ((max_a - a_j, max_j - a_j), (max_b - b_j, max_j - b_j)), com
    max_a, max_b os maiores tempos de cada máquina em rest e max_j = max(a_j, b_j).
    """
    ma = max(a[j] for j in rest)
    mb = max(b[j] for j in rest)
    D = {}
    for j in rest:
        mx = max(a[j], b[j])
        D[j] = ((ma - a[j], mx - a[j]), (mb - b[j], mx - b[j]))
    return D


def tdm2(a, b, jobs=None, log=False):
    """TDM com duas máquinas; a, b: dicionários trabalho -> tempo.

    Devolve (sequência do TDM, sequência construída antes da inversão).
    Com log=True imprime a tabela de desvios e as entradas de cada iteração.
    """
    jobs = list(a) if jobs is None else list(jobs)
    F, B = [], []                       # bloco da frente e bloco de trás
    rest = jobs[:]
    it = 0
    while rest:
        it += 1
        D = desvios(a, b, rest)
        z1 = [j for j in rest if D[j][0] == (0, 0)]
        z2 = [j for j in rest if D[j][1] == (0, 0) and j not in z1]
        s = {j: sum(D[j][0]) + sum(D[j][1]) for j in rest}
        z1.sort(key=lambda j: -s[j])
        z2.sort(key=lambda j: -s[j])
        F += z1
        B = z2 + B
        if log:
            print("  iteração %d (máx. %d e %d)" % (it, max(a[j] for j in rest), max(b[j] for j in rest)))
            for j in rest:
                print("    %-4s (%d, %d)  (%d, %d)" % ((j,) + D[j][0] + D[j][1]))
        rest = [j for j in rest if j not in z1 + z2]
        if log:
            print("    pela frente: %s;  por trás: %s;  em construção: %s"
                  % (" ".join(z1) or "-", " ".join(z2) or "-", " ".join(F + ["_"] * len(rest) + B)))
    constr = F + B
    return constr[::-1], constr


def tdm(P, log=False):
    """TDM com m máquinas: com 2, diretamente; com m >= 3, nas máquinas fictícias (G, H)."""
    if len(next(iter(P.values()))) == 2:
        a = {j: t[0] for j, t in P.items()}
        b = {j: t[1] for j, t in P.items()}
    else:
        a, b = reduz(P)
    return tdm2(a, b, list(P), log)
