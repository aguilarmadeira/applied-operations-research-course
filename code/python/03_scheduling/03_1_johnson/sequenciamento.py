"""Sequenciamento em máquinas em série e regra de Johnson para 2 máquinas (deck 3.1).

tempos(seq, P)          -> instantes de conclusão C[k][i] do k-ésimo trabalho da sequência na máquina i
cmax(seq, P)            -> tempo total (makespan) T da sequência
ocios(seq, P)           -> tempo ocioso de cada máquina (T - soma dos seus tempos)
tempo_total(seq, a, b)  -> tempo total com duas máquinas (a, b: dicionários trabalho -> tempo)
johnson(a, b)           -> sequência de Johnson (ótima com duas máquinas)
forca_bruta(P, f=None)  -> todas as sequências, ordenadas por valor: lista de (valor, 'sequência')

P: dicionário trabalho -> tuplo de tempos nas máquinas 1..m, pela ordem das máquinas.
As sequências são listas de nomes de trabalhos (ou strings com nomes de um carácter).

Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.
"""
import itertools


def tempos(seq, P):
    """Instantes de conclusão: C[k][i] = quando o k-ésimo trabalho de seq sai da máquina i.

    Cada trabalho entra numa máquina quando sai da anterior e a máquina fica livre:
    C_i <- max(C_i, C_(i-1)) + tempo do trabalho na máquina i.
    """
    m = len(next(iter(P.values())))
    f = [0] * m                       # instante em que cada máquina fica livre
    C = []
    for j in seq:
        for i in range(m):
            f[i] = max(f[i], f[i - 1] if i else 0) + P[j][i]
        C.append(f[:])
    return C


def cmax(seq, P):
    """Tempo total T: instante em que o último trabalho sai da última máquina."""
    return tempos(seq, P)[-1][-1] if len(seq) else 0


def ocios(seq, P):
    """Tempo ocioso de cada máquina até ao fim: T - soma dos tempos dessa máquina."""
    T = cmax(seq, P)
    m = len(next(iter(P.values())))
    return [T - sum(P[j][i] for j in seq) for i in range(m)]


def tempo_total(seq, a, b):
    """Tempo total com duas máquinas: C1 <- C1 + a_j, C2 <- max(C2, C1) + b_j."""
    c1 = c2 = 0
    for j in seq:
        c1 += a[j]
        c2 = max(c2, c1) + b[j]
    return c2


def johnson(a, b):
    """Regra de Johnson (2 máquinas); a, b: dicionários trabalho -> tempo.

    Primeiro os trabalhos com a_j <= b_j, por a crescente; depois os outros, por b decrescente.
    Empates: fica primeiro o que aparece primeiro em a (qualquer escolha é ótima).
    """
    L = [j for j in a if a[j] <= b[j]]
    R = [j for j in a if a[j] > b[j]]
    L.sort(key=lambda j: a[j])        # a crescente
    R.sort(key=lambda j: -b[j])       # b decrescente
    return L + R


def forca_bruta(P, f=None):
    """Avalia as n! sequências; por omissão, f = tempo total.

    Devolve a lista de (valor, 'sequência') ordenada (o primeiro elemento é o ótimo).
    f recebe a sequência como lista de nomes.
    """
    f = f or (lambda s: cmax(s, P))
    return sorted((f(list(s)), "".join(s)) for s in itertools.permutations(P))
