"""Substituição de equipamentos que se desgastam, sem valor temporal do dinheiro (deck 4.1).

custo_medio(P, C, S=0)               -> lista A com A[n-1] = A(n), o custo médio anual se se substituir ao fim de n anos
media(P, C, S=0)                     -> tabela: uma linha (n, C_n, soma C, P - S_n, total, A(n)) por ano
melhor(L, k=-1)                      -> a linha de L com menor valor na coluna k (por omissão, a última)
custo_mais_um_ano(C, S, n, d=1.0)    -> M_{n+1} = C_{n+1} + S_n - d S_{n+1}, o custo de manter mais um ano
quando_trocar(C, S, idade, minimo, d=1.0) -> duas máquinas: até quando manter a antiga (com idade anos)
revenda(S, n)                        -> S_n (S é uma lista por ano ou um valor de sucata fixo)

P: custo de compra; C: custos de funcionamento por ano (C[0] é o ano 1);
S: valores de revenda no fim de cada ano (lista) ou um valor de sucata igual em todos os anos (número).
A(n) = (P - S_n + C_1 + ... + C_n) / n; substituir ao fim de n* anos, com A(n*) mínimo.

Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.
"""


def revenda(S, n):
    """Valor de revenda no fim do ano n (n = 1, 2, ...): S[n-1] se S for uma lista, ou S se for um número."""
    return S[n - 1] if hasattr(S, "__len__") else S


def custo_medio(P, C, S=0):
    """Custo médio anual A(n) = (P - S_n + soma_{i<=n} C_i) / n, para n = 1, ..., len(C).

    Devolve uma lista (A[n-1] = A(n)); é a função do slide «Em Python».
    """
    A, soma = [], 0
    for n, c in enumerate(C, start=1):
        soma += c
        A.append((P - revenda(S, n) + soma) / n)
    return A


def media(P, C, S=0):
    """Tabela do custo médio anual, uma linha por ano:
    (n, C_n, soma C_i, P - S_n, total = soma C_i + P - S_n, A(n) = total / n)."""
    L, soma = [], 0
    for n, c in enumerate(C, start=1):
        soma += c
        perda = P - revenda(S, n)
        L.append((n, c, soma, perda, soma + perda, (soma + perda) / n))
    return L


def melhor(L, k=-1):
    """A linha de L com o menor valor na coluna k (em empate, a primeira)."""
    return min(L, key=lambda r: r[k])


def custo_mais_um_ano(C, S, n, d=1.0):
    """Custo de manter o equipamento mais um ano (o ano n+1):
    M_{n+1} = C_{n+1} + S_n - d S_{n+1}  (funcionamento + o que se perde na revenda).

    Sem desconto (d = 1): C_{n+1} + (S_n - S_{n+1}). Com desconto (4.2), d = 1/(1+r).
    Regra: substituir ao fim do ano n quando M_{n+1} > A(n) (ou > W(n), com desconto).
    """
    return C[n] + revenda(S, n) - d * revenda(S, n + 1)


def quando_trocar(C, S, idade, minimo, d=1.0):
    """Duas máquinas: manter a antiga, que tem idade anos, enquanto o custo de mais um ano dela for menor
    do que o custo médio mínimo da nova (minimo); compara-se o marginal da antiga com a média mínima da nova.

    C, S: custos e revendas da antiga. Devolve (anos, linhas):
      anos   = [n]: trocar ao fim do ano n da antiga; [n, n+1]: empate, é indiferente trocar no fim de n ou de n+1;
      linhas = [(k, M_k, decisão)] para k = idade+1, ...: o k-ésimo ano da antiga, o seu custo e
               «manter», «indiferente» ou «trocar».
    """
    linhas = []
    for n in range(idade, len(C)):
        M = custo_mais_um_ano(C, S, n, d)
        dec = "indiferente" if abs(M - minimo) <= 1e-9 else ("manter" if M < minimo else "trocar")
        linhas.append((n + 1, M, dec))
        if dec == "indiferente":
            return [n, n + 1], linhas
        if dec == "trocar":
            return [n], linhas
    return [len(C)], linhas
