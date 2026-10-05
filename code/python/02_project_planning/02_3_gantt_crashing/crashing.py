"""Diagrama de Gantt e aceleração de projetos, crashing (deck 2.3).

Um projeto com custos é um dicionário  acts = {nome: (precedentes, DN, custo DN, DM, custo DM)}
(DN: duração normal; DM: duração mínima; o custo cresce linearmente entre as duas).

gantt(acts, dur=None)      -> linhas de texto do diagrama de Gantt (barras de ES a EF; folga a seguir)
crash(acts, bonus=0)       -> custo por unidade de tempo e, para cada duração T do projeto,
                              (custo direto mínimo, durações, custo total com o bónus), por enumeração exata
crash_pl(acts, bonus, T0=None) -> o mesmo ótimo pela programação linear (precisa de scipy)

A enumeração testa todas as combinações de durações inteiras entre DM e DN: é exata, mas só serve
para redes pequenas; a programação linear funciona para redes grandes.
Usa o CPM de 2.1 (pm.py).

Complementos de IO — deck 2.3.  J. F. A. Madeira — Licença MIT.
"""
from itertools import product

from pm import cpm


def gantt(acts, dur=None):
    """Diagrama de Gantt em texto, uma coluna por unidade de tempo (durações inteiras).

    '#' atividade crítica, '=' atividade com folga, '-' folga (de EF a LF), '.' livre.
    Devolve a lista das linhas (a primeira é a régua do tempo: 1, 2, ..., módulo 10).
    """
    ES, EF, LS, LF, F, T = cpm(acts, dur)
    T = int(round(T))
    linhas = ["  tempo   " + "".join(str((t + 1) % 10) for t in range(T))]
    for a in acts:
        s = ["."] * T
        c = "#" if abs(F[a]) < 1e-9 else "="
        for t in range(int(ES[a]), int(EF[a])):
            s[t] = c
        for t in range(int(EF[a]), int(LF[a])):
            s[t] = "-"
        linhas.append("  %-7s %s" % (a, "".join(s)))
    return linhas


def crash(acts, bonus=0):
    """Crashing por enumeração exata.

    Devolve slope = {a: custo por unidade de tempo} e
    {T: (custo direto mínimo, {a: duração}, custo total = direto - bonus * (Tn - T))},
    em que Tn é a duração normal. Em caso de empate fica a primeira combinação encontrada.
    """
    names = list(acts)
    slope = {a: ((v[4] - v[2]) / (v[1] - v[3]) if v[1] > v[3] else 0) for a, v in acts.items()}
    best = {}
    for ds in product(*[range(acts[a][3], acts[a][1] + 1) for a in names]):
        d = dict(zip(names, ds))
        T = cpm(acts, d)[5]
        c = sum(acts[a][2] + slope[a] * (acts[a][1] - d[a]) for a in names)
        if T not in best or c < best[T][0] - 1e-9:
            best[T] = (c, d)
    Tn = max(best)
    return slope, {T: (c, d, c - bonus * (Tn - T)) for T, (c, d) in best.items()}


def crash_pl(acts, bonus, T0=None):
    """Crashing como programação linear (slide «Complemento»), com scipy.optimize.linprog.

    Variáveis: s_j (início), y_j (unidades retiradas a j), T (duração do projeto).
    min sum c_j y_j - bonus (T0 - T)  s.a.  s_j >= s_i + d_i - y_i (i precede j),
    T >= s_i + d_i - y_i (i final), 0 <= y_j <= DN_j - DM_j, s_j >= 0.
    Devolve T, custo direto, custo total e {a: y_a}.
    """
    import numpy as np
    from scipy.optimize import linprog

    names = list(acts)
    n = len(names)
    idx = {a: i for i, a in enumerate(names)}
    if T0 is None:
        T0 = cpm(acts)[5]
    c = np.zeros(2 * n + 1)
    for a, v in acts.items():
        c[n + idx[a]] = (v[4] - v[2]) / (v[1] - v[3]) if v[1] > v[3] else 0
    c[2 * n] = bonus
    A, b = [], []
    for j, v in acts.items():
        for i in v[0]:                              # s_i - s_j - y_i <= -d_i
            row = np.zeros(2 * n + 1)
            row[idx[i]], row[idx[j]], row[n + idx[i]] = 1, -1, -1
            A.append(row)
            b.append(-acts[i][1])
    for i in acts:
        if not any(i in acts[x][0] for x in acts):  # s_i - y_i - T <= -d_i
            row = np.zeros(2 * n + 1)
            row[idx[i]], row[n + idx[i]], row[2 * n] = 1, -1, -1
            A.append(row)
            b.append(-acts[i][1])
    bounds = [(0, None)] * n + [(0, acts[a][1] - acts[a][3]) for a in names] + [(0, None)]
    r = linprog(c, A_ub=np.array(A), b_ub=b, bounds=bounds)
    T = r.x[-1]
    y = {a: r.x[n + idx[a]] for a in names}
    direto = sum(v[2] for v in acts.values()) + sum(c[n + idx[a]] * y[a] for a in names)
    return T, direto, direto - bonus * (T0 - T), y
