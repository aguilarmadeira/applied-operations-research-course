"""AHP: matriz de comparações, prioridades e consistência (deck 8.1).

RI                              -> índice aleatório de Saaty, RI[n] (n = 1, ..., 10)
matriz(n, juizos)               -> matriz recíproca n x n a partir de {(i, j): a_ij} com i < j
prioridades(A, metodo='colunas') -> (w, lambda_max, IC, RC)

metodo='colunas': média das linhas da matriz normalizada por colunas (método das aulas e dos testes);
metodo='vetor':   vetor próprio do maior valor próprio (definição de Saaty, numpy.linalg.eig).
Os índices começam em 0 (critério 1 -> índice 0).

Complementos de IO — deck 8.1.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np

RI = {1: 0, 2: 0, 3: 0.58, 4: 0.90, 5: 1.12, 6: 1.24, 7: 1.32, 8: 1.41, 9: 1.45, 10: 1.49}   # índice aleatório de Saaty


def matriz(n, juizos):
    """Constrói a matriz recíproca a partir de {(i, j): a_ij} com i < j (índices a partir de 0).

    a_ii = 1 e a_ji = 1 / a_ij; os pares não indicados ficam com 1.
    """
    A = np.ones((n, n))
    for (i, j), a in juizos.items():
        A[i, j] = a
        A[j, i] = 1 / a
    return A


def prioridades(A, metodo='colunas'):
    """Pesos (prioridades) e consistência de uma matriz de comparações par a par.

    'colunas': média das linhas da matriz normalizada por colunas (método das aulas);
               lambda_max = média de (Aw)_i / w_i.
    'vetor':   vetor próprio do maior valor próprio (Saaty), normalizado para somar 1.
    Devolve w, lambda_max, IC = (lambda_max - n) / (n - 1) e RC = IC / RI[n] (0 se n <= 2).
    """
    A = np.asarray(A, float)
    n = len(A)
    if metodo == 'colunas':
        w = (A / A.sum(0)).mean(1)
        lam = float(np.mean(A @ w / w))
    else:
        val, vec = np.linalg.eig(A)
        k = np.argmax(val.real)
        w = np.abs(vec[:, k].real)
        w = w / w.sum()
        lam = float(val[k].real)
    IC = (lam - n) / (n - 1) if n > 2 else 0.0
    RC = IC / RI[n] if RI[n] > 0 else 0.0
    return w, lam, IC, RC
