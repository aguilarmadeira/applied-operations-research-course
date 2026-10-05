"""Caminho mais curto por programação dinâmica (deck 5.1).

A rede é um dicionário arcos[nó] = {sucessor: custo}.

caminho_etapas(arcos, fim)        -> (f, dec): f[i] = custo mínimo de i até fim;
                                     dec[i] = sucessores ótimos de i (todos, se houver empate)
caminhos_otimos(dec, ini, fim)    -> lista de todos os percursos ótimos de ini a fim
todos_caminhos(arcos, ini, fim)   -> lista de (percurso, custo) de todos os percursos (força bruta)
guloso(arcos, ini, fim)           -> (custo, percurso) da regra gulosa (arco mais barato em cada nó)

Complementos de IO — deck 5.1.  J. F. A. Madeira — Licença MIT.
"""


def caminho_etapas(arcos, fim):
    """Recursão para trás: f(fim) = 0,  f(i) = min_j { c(i, j) + f(j) }.

    Cada nó é calculado depois de todos os seus sucessores (não é preciso
    dar as etapas: serve também para redes com arcos dentro da mesma «coluna»).
    Devolve f (dicionário nó -> custo mínimo até fim) e dec (nó -> lista dos
    sucessores ótimos, pela ordem dos arcos; mais do que um em caso de empate).
    """
    f = {fim: 0}
    dec = {}
    pend = set(arcos)
    while pend:
        for i in sorted(pend):
            if all(j in f for j in arcos[i]):          # sucessores todos calculados
                vals = {j: c + f[j] for j, c in arcos[i].items()}
                m = min(vals.values())
                f[i] = m
                dec[i] = [j for j, v in vals.items() if v == m]
                pend.remove(i)
                break
        else:
            raise ValueError("grafo com ciclo ou nó sem saída")
    return f, dec


def caminhos_otimos(dec, ini, fim):
    """Todos os percursos ótimos de ini a fim, lidos para a frente a partir de dec."""
    if ini == fim:
        return [[fim]]
    return [[ini] + resto for j in dec[ini] for resto in caminhos_otimos(dec, j, fim)]


def todos_caminhos(arcos, ini, fim):
    """Todos os percursos de ini a fim, com o respetivo custo (enumeração completa)."""
    if ini == fim:
        return [([fim], 0)]
    out = []
    for j, c in arcos.get(ini, {}).items():
        for p, v in todos_caminhos(arcos, j, fim):
            out.append(([ini] + p, c + v))
    return out


def guloso(arcos, ini, fim):
    """Regra gulosa (míope): em cada nó segue o arco mais barato (o primeiro, se houver empate)."""
    no, total, caminho = ini, 0, [ini]
    while no != fim:
        j = min(arcos[no], key=arcos[no].get)
        total += arcos[no][j]
        no = j
        caminho.append(j)
    return total, caminho
