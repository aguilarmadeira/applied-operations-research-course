"""Reproduz os exemplos do deck 5.3 (gestão da mão-de-obra).

Exemplo-guia: montagem de feiras e congressos, necessidades 3, 8, 9, 4, 6; excesso 300 €;
contratação 600 € + 150 € por operário; ninguém contratado no início.
Seguir as necessidades: 4050 €; 9 desde o início: 6450 €; 336 planos possíveis.
Tabelas: f_5(4) = 900, f_5(5) = 750, f_5(6..9) = 0; f_4(9) = 600 (x_4 = 6); f_3(8) = 1350, f_3(9) = 600;
f_2(3) = 2400 (x_2 = 9); f_1(0) = 3450. Plano ótimo 3, 9, 9, 6, 6 (custos 1050, 1800, 0, 600, 0),
único por força bruta. Sensibilidade ao custo fixo: 0 -> 1650; 300 -> 2850 (4 planos);
600 -> 3450; 1200 -> 4650; 2000 -> 6050 (9, 9, 9, 6, 6).
Para resolver na aula: Exemplo 7: 5, 8, 8, 6, 6, custo 3300; Exemplo 8: 5, 7, 6, 6, custo 2400.

No fim compara com os slides.
Correr (de qualquer pasta):  python ex05_3_workforce.py

Complementos de IO — deck 5.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from mao_de_obra import mao_obra, mao_obra_bruta, custo_plano


def mat2str(A):
    """Matriz/vetor no formato do mat2str do MATLAB (para as saídas serem iguais)."""
    A = np.atleast_2d(np.asarray(A, float))
    return "[" + ";".join(" ".join("%.15g" % x for x in linha) for linha in A) + "]"


def mostra(titulo, b, ce, cf, cv):
    """Duas políticas simples, as tabelas da recursão, o plano ótimo e a força bruta."""
    print("\n%s: b = %s, ce = %d, cf = %d, cv = %d" % (titulo, mat2str(b), ce, cf, cv))
    n, M = len(b), max(b)
    for xs, rot in [(b, "seguir as necessidades"), ([M] * n, "%d desde o início" % M)]:
        tot, cs = custo_plano(b, ce, cf, cv, xs)
        print("  %s %s: custos %s = %d" % (rot, mat2str(xs), mat2str(cs), tot))
    nplanos = int(np.prod([M - bt + 1 for bt in b]))
    print("  planos possíveis: %d" % nplanos)
    valor, plano, f, dec = mao_obra(b, ce, cf, cv, tabelas=True)
    print("  recursão para trás (s = operários na semana anterior):")
    for t in range(n - 1, -1, -1):
        for s in f[t]:
            cand = []
            for x in range(b[t], M + 1):
                c = ce * (x - b[t]) + ((cf + cv * (x - s)) if x > s else 0)
                cand.append("%d: %d+%d=%d" % (x, c, f[t + 1][x], c + f[t + 1][x]))
            print("    semana %d, s = %d: f = %-5d x* = %-6s [%s]"
                  % (t + 1, s, f[t][s], " ou ".join(map(str, dec[t][s])), "; ".join(cand)))
    tot, cs = custo_plano(b, ce, cf, cv, plano)
    print("  plano ótimo %s, custo %d (custos por semana %s)" % (mat2str(plano), valor, mat2str(cs)))
    cb, pb = mao_obra_bruta(b, ce, cf, cv)
    print("  força bruta (%d planos): %d com %s" % (nplanos, cb, mat2str(pb)))
    return valor, plano, f, cs, cb, pb, nplanos


ok = True
print("Complementos de IO — deck 5.3: gestão da mão-de-obra")

# ------------------------------------------------------------ montagem de eventos
b = [3, 8, 9, 4, 6]
valor, plano, f, cs, cb, pb, nplanos = mostra("Montagem de feiras e congressos", b, 300, 600, 150)
ok &= (valor == 3450 and plano == [3, 9, 9, 6, 6] and cs == [1050, 1800, 0, 600, 0]
       and cb == 3450 and pb == [(3, 9, 9, 6, 6)] and nplanos == 336
       and custo_plano(b, 300, 600, 150, b)[0] == 4050 and custo_plano(b, 300, 600, 150, [9] * 5)[0] == 6450
       and f[4] == {4: 900, 5: 750, 6: 0, 7: 0, 8: 0, 9: 0} and f[3] == {9: 600}
       and f[2] == {8: 1350, 9: 600} and f[1][3] == 2400 and f[0] == {0: 3450})

print("  e se o custo fixo de contratar mudar?")
sens = {}
for cf in (0, 300, 600, 1200, 2000):
    v = mao_obra(b, 300, cf, 150)[0]
    cbr, pbr = mao_obra_bruta(b, 300, cf, 150)
    sens[cf] = (v, pbr)
    print("    cf = %4d: custo %d, planos ótimos %s" % (cf, v, mat2str(pbr)))
ok &= (sens[0] == (1650, [(3, 8, 9, 4, 6)]) and sens[300][0] == 2850 and len(sens[300][1]) == 4
       and sens[600] == (3450, [(3, 9, 9, 6, 6)]) and sens[1200] == (4650, [(3, 9, 9, 6, 6)])
       and sens[2000] == (6050, [(9, 9, 9, 6, 6)]))

# ------------------------------------------------------------ Para resolver na aula
r7 = mostra("Exemplo 7", [5, 7, 8, 4, 6], 300, 400, 200)
r8 = mostra("Exemplo 8", [5, 7, 4, 6], 200, 300, 200)
ok &= r7[0] == 3300 and r7[1] == [5, 8, 8, 6, 6] and r7[5] == [(5, 8, 8, 6, 6)]
ok &= r8[0] == 2400 and r8[1] == [5, 7, 6, 6] and r8[5] == [(5, 7, 6, 6)]

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
