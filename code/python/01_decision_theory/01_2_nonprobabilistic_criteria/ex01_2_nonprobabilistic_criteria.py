"""Reproduz os exemplos do deck 1.2 (critérios não probabilísticos).

Exemplo-guia: capacidade de uma linha de produção (lucro, milhares de euros):
    a1 pequena: 40, 45, 50;  a2 média: 20, 60, 80;  a3 grande: -40, 50, 120.
Maximax a3; Maximin a1; Laplace, Savage e Hurwicz (alpha = 0.5) a2;
Hurwicz: a1 para alpha < 0.4, a2 entre 0.4 e 0.6, a3 acima de 0.6 (com 0.7: 47, 62, 72).
Slide «Savage pode ser incoerente»: com uma 3.ª ação a escolha passa da Ação 1 à Ação 2.
Para resolver na aula: Exemplo 3 (investimento, Hurwicz 0.8) e o exercício a1–a4 (Hurwicz 0.7).
No fim, um exemplo de verifica_escolhas (conferir respostas sem ver a resolução).

Correr (de qualquer pasta):  python ex01_2_nonprobabilistic_criteria.py

Complementos de IO — deck 1.2.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from criterios import arrependimentos, criterios, intervalos_retas, verifica_escolhas
from decisao import dominadas


def mat2str(A):
    """Matriz/vetor no formato do mat2str do MATLAB (para as saídas serem iguais)."""
    A = np.atleast_2d(np.asarray(A, float))
    return "[" + ";".join(" ".join("%.15g" % x for x in linha) for linha in A) + "]"


def mostra(titulo, C, nomes, alpha, custos=False):
    print("\n" + titulo)
    dom = dominadas(C, custos)
    print("  dominadas:", ", ".join("%s (por %s)" % (nomes[i], nomes[k]) for i, k in dom) or "nenhuma")
    res = criterios(C, alpha, custos)
    for k, (v, esc) in res.items():
        rot = k + (" (%.1f)" % alpha if k == "hurwicz" else "")
        print("  %-14s %-34s -> %s" % (rot, "  ".join("%.4g" % x for x in v),
                                       ", ".join(nomes[i] for i in esc)))
    return res


ok = True
print("Complementos de IO — deck 1.2: critérios de decisão não probabilísticos")

# ------------------------------------------------------------ linha de produção
C = np.array([[40, 45, 50], [20, 60, 80], [-40, 50, 120]])
nomes = ["a1 pequena", "a2 média", "a3 grande"]
res = mostra("Linha de produção (lucro, milhares de euros)", C, nomes, 0.5)
R = arrependimentos(C)
print("  arrependimentos: %s" % mat2str(R))
h7 = criterios(C, 0.7)["hurwicz"]
print("  Hurwicz com alpha = 0.7: %s -> %s" % ("  ".join("%.4g" % x for x in h7[0]), nomes[h7[1][0]]))
iv = intervalos_retas(C.min(1), C.max(1) - C.min(1))
for u, w, quem in iv:
    print("  alpha em [%.2f, %.2f]: %s" % (u, w, ", ".join(nomes[i] for i in quem)))
c = [res["maximax"][1] == [2], res["maximin"][1] == [0], res["laplace"][1] == [1],
     res["savage"][1] == [1], res["hurwicz"][1] == [1],
     np.allclose(res["laplace"][0], [45, 160 / 3, 130 / 3]),
     np.array_equal(R, [[0, 15, 70], [20, 0, 40], [80, 10, 0]]),
     np.allclose(h7[0], [47, 62, 72]), h7[1] == [2],
     [(round(u, 6), round(w, 6), q) for u, w, q in iv] == [(0, 0.4, [0]), (0.4, 0.6, [1]), (0.6, 1, [2])]]
ok &= all(c)

# ------------------------------------------------------------ Savage incoerente
s2 = criterios([[60, -40], [70, -60]])["savage"]
s3 = criterios([[60, -40], [70, -60], [90, -65]])["savage"]
print("\nSavage incoerente: 2 ações, máx. arrependimentos %s -> Ação %d;"
      " com a Ação 3: %s -> Ação %d" % (mat2str(s2[0]), s2[1][0] + 1, mat2str(s3[0]), s3[1][0] + 1))
ok &= s2[1] == [0] and s3[1] == [1] and s3[0].tolist() == [30, 20, 25]

# ------------------------------------------------------------ Exemplo 3 (investimento)
CI = [[1000, 0, -1500], [350, 200, 300], [220, 100, 0]]
NI = ["ações", "obrigações", "títulos do tesouro"]
r3 = mostra("Exemplo 3 (investimento; subida, estável, descida)", CI, NI, 0.8)
ok &= (r3["maximax"][1] == [0] and r3["maximin"][1] == [1] and r3["laplace"][1] == [1]
       and r3["savage"][1] == [1] and r3["hurwicz"][1] == [0]
       and np.allclose(r3["savage"][0], [1800, 650, 780]) and np.allclose(r3["hurwicz"][0], [500, 320, 176]))

# ------------------------------------------------------------ exercício a1–a4
CE = [[-50, 0, 80], [-10, 30, 35], [60, 45, -30], [90, 40, 45]]
NE = ["a1", "a2", "a3", "a4"]
re = mostra("Exercício (estimativas de ganhos)", CE, NE, 0.7)
ok &= all(v[1] == [3] for v in re.values()) and dominadas(CE) == [(1, 3)]

# ------------------------------------------------------------ verificar respostas
print("\nverifica_escolhas: um aluno respondeu assim ao Exemplo 3")
v = verifica_escolhas(CI, 0.8, {"maximax": "ações", "maximin": "títulos do tesouro",
                                "savage": "obrigações"}, NI)
ok &= v == {"maximax": True, "maximin": False, "savage": True}

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
