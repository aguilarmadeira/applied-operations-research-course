"""Critérios de decisão não probabilísticos (deck 1.2).

arrependimentos(C, custos=False)         -> matriz R dos arrependimentos (r_ij >= 0)
criterios(C, alpha=0.5, custos=False)    -> dict critério -> (valores por ação, ações escolhidas)
intervalos_retas(a, b, t0=0, t1=1)       -> onde cada reta a_i + b_i t está por cima (Hurwicz em alpha)
verifica_escolhas(C, alpha, respostas, nomes, custos=False)  -> diz se cada escolha está certa

Critérios: 'maximax' (otimista), 'maximin' (pessimista), 'laplace', 'savage', 'hurwicz'.
Com custos=True invertem-se os sentidos (minimin, minimax, ...); os nomes das chaves mantêm-se.

Complementos de IO — deck 1.2.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np

CRITERIOS = ("maximax", "maximin", "laplace", "savage", "hurwicz")


def arrependimentos(C, custos=False):
    """r_ij = max_k c_kj - c_ij (ganhos) ou r_ij = c_ij - min_k c_kj (custos)."""
    C = np.asarray(C, dtype=float)
    return C - C.min(axis=0) if custos else C.max(axis=0) - C


def _melhores(v, maior=True, tol=1e-9):
    alvo = v.max() if maior else v.min()
    return [i for i in range(len(v)) if abs(v[i] - alvo) <= tol]


def criterios(C, alpha=0.5, custos=False):
    """Valor de cada ação segundo os cinco critérios e a(s) ação(ões) escolhida(s).

    alpha: índice de otimismo de Hurwicz (pesa sempre o melhor resultado).
    Devolve {critério: (valores, [índices das ações escolhidas])}.
    """
    C = np.asarray(C, dtype=float)
    mx, mn, med = C.max(axis=1), C.min(axis=1), C.mean(axis=1)
    sav = arrependimentos(C, custos).max(axis=1)
    if custos:
        val = {"maximax": mn, "maximin": mx, "laplace": med, "savage": sav,
               "hurwicz": alpha * mn + (1 - alpha) * mx}
        maior = dict.fromkeys(CRITERIOS, False)
    else:
        val = {"maximax": mx, "maximin": mn, "laplace": med, "savage": sav,
               "hurwicz": alpha * mx + (1 - alpha) * mn}
        maior = {k: k != "savage" for k in CRITERIOS}
    return {k: (val[k], _melhores(val[k], maior[k])) for k in CRITERIOS}


def intervalos_retas(a, b, t0=0.0, t1=1.0, maior=True):
    """Para as retas v_i(t) = a_i + b_i t, devolve [(início, fim, [i, ...])]:
    em cada intervalo de [t0, t1], a(s) reta(s) por cima (ou por baixo, se maior=False).

    Em Hurwicz (ganhos): a = mínimos das linhas, b = máximos - mínimos, t = alpha.
    """
    a, b = np.asarray(a, float), np.asarray(b, float)
    cortes = {t0, t1}
    for i in range(len(a)):
        for k in range(i + 1, len(a)):
            if abs(b[i] - b[k]) > 1e-12:
                t = (a[k] - a[i]) / (b[i] - b[k])
                if t0 < t < t1:
                    cortes.add(round(t, 12))
    cortes = sorted(cortes)
    out = []
    for u, w in zip(cortes[:-1], cortes[1:]):
        quem = _melhores(a + b * (u + w) / 2, maior)
        if out and out[-1][2] == quem:
            out[-1] = (out[-1][0], w, quem)
        else:
            out.append((u, w, quem))
    return out


def verifica_escolhas(C, alpha, respostas, nomes, custos=False):
    """Confere as escolhas de um aluno sem mostrar a resolução.

    respostas: {critério: nome da ação escolhida}; imprime «certo» ou «errado» e devolve um dict.
    """
    res = criterios(C, alpha, custos)
    out = {}
    for k, escolha in respostas.items():
        certas = [nomes[i] for i in res[k][1]]
        out[k] = escolha in certas
        print("  %-8s %-28s %s" % (k, escolha, "certo" if out[k] else "errado"))
    return out
