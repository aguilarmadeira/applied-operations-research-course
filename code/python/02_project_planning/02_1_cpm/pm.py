"""Método do caminho crítico, CPM (deck 2.1).

Um projeto é um dicionário  acts = {nome: (precedentes, duração, ...)}
(os campos a seguir à duração são ignorados aqui; o PERT e o crashing usam-nos).

topo(acts)           -> lista das atividades por uma ordem topológica
cpm(acts, dur=None)  -> ES, EF, LS, LF, folga (dicionários) e T (duração do projeto)
caminhos(acts)       -> todos os caminhos do início ao fim (listas de nomes)

Complementos de IO — deck 2.1.  J. F. A. Madeira — Licença MIT.
"""


def topo(acts):
    """Ordem topológica: cada atividade aparece depois de todos os seus precedentes."""
    order, seen = [], set()
    while len(order) < len(acts):
        n0 = len(order)
        for a, (pre, *_) in acts.items():
            if a not in seen and all(p in seen for p in pre):
                order.append(a)
                seen.add(a)
        if len(order) == n0:
            raise ValueError("as precedências têm um ciclo (ou um precedente inexistente)")
    return order


def sucessores(acts):
    """{a: [atividades que têm a como precedente]}."""
    return {a: [b for b in acts if a in acts[b][0]] for a in acts}


def cpm(acts, dur=None):
    """Passagem para a frente e para trás.

    acts: {nome: (precedentes, duração, ...)};  dur: {nome: duração} (por omissão, a de acts).
    Devolve ES, EF, LS, LF, F (folga = LS - ES), dicionários por atividade, e T = max EF.
    """
    dur = dur or {a: v[1] for a, v in acts.items()}
    o = topo(acts)
    ES, EF = {}, {}
    for a in o:                                   # para a frente: ES = max EF dos precedentes
        ES[a] = max([EF[p] for p in acts[a][0]], default=0)
        EF[a] = ES[a] + dur[a]
    T = max(EF.values())
    succ = sucessores(acts)
    LS, LF = {}, {}
    for a in reversed(o):                         # para trás: LF = min LS dos sucessores
        LF[a] = min([LS[s] for s in succ[a]], default=T)
        LS[a] = LF[a] - dur[a]
    F = {a: LS[a] - ES[a] for a in acts}
    return ES, EF, LS, LF, F, T


def caminhos(acts):
    """Todos os caminhos de uma atividade inicial até uma final (só para redes pequenas)."""
    succ = sucessores(acts)
    out = []

    def rec(p):
        s = succ[p[-1]]
        if not s:
            out.append(p)
            return
        for b in s:
            rec(p + [b])

    for a in acts:
        if not acts[a][0]:
            rec([a])
    return out
