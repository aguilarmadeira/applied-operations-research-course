"""Reproduz os exemplos do deck 5.1 (princípio de Bellman e caminho mais curto).

Exemplo-guia: transportadora de A a J (custos em centenas de €).
Regra gulosa: A-C-F-I-J, custo 21. Recursão para trás: f(H) = 5, f(I) = 7; f(E) = 11 (H ou I),
f(F) = 16, f(G) = 9; f(B) = 13, f(C) = 18 (E ou G), f(D) = 13; f(A) = 17. Ótimo A-B-G-I-J, custo 17.
Slide «Quanto se poupa?»: 15 percursos, 45 somas a enumerar contra 19 da PD; tabela k^N contra N k^2.
Para resolver na aula: Exemplos 1, 2 e 3 (do nó 1 ao nó 7): 26 por 1-4-6-7; 23 por 1-3-6-7;
17 por 1-2-3-5-7 (a regra gulosa dá 34, 28 e 17).

No fim compara com os slides.
Correr (de qualquer pasta):  python ex05_1_bellman_shortest_path.py

Complementos de IO — deck 5.1.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

from caminho import caminho_etapas, caminhos_otimos, todos_caminhos, guloso


def txt(caminho):
    """Percurso como texto: A-B-G-I-J."""
    return "-".join(map(str, caminho))


def mostra(titulo, arcos, ini, fim):
    """Regra gulosa, recursão para trás nó a nó, percursos ótimos e força bruta."""
    print("\n" + titulo)
    g, cg = guloso(arcos, ini, fim)
    print("  regra gulosa: %s, custo %d" % (txt(cg), g))
    f, dec = caminho_etapas(arcos, fim)
    print("  recursão para trás (f = custo mínimo até %s):" % fim)
    for i in sorted(arcos, reverse=True):
        vias = ", ".join("via %s: %d+%d=%d" % (j, c, f[j], c + f[j]) for j, c in arcos[i].items())
        print("    f(%s) = %-3d [%s]  -> %s" % (i, f[i], vias, " ou ".join(map(str, dec[i]))))
    cs = caminhos_otimos(dec, ini, fim)
    print("  ótimo: %d por %s" % (f[ini], " e ".join(txt(c) for c in cs)))
    tc = todos_caminhos(arcos, ini, fim)
    print("  força bruta: %d percursos, mínimo %d" % (len(tc), min(v for _, v in tc)))
    return g, f, dec, cs, tc


ok = True
print("Complementos de IO — deck 5.1: princípio de Bellman e caminho mais curto")

# ------------------------------------------------------------ transportadora A -> J
arcos = {"A": {"B": 4, "C": 2, "D": 8}, "B": {"E": 4, "F": 2, "G": 4}, "C": {"E": 7, "F": 3, "G": 9},
         "D": {"E": 9, "F": 7, "G": 4}, "E": {"H": 6, "I": 4}, "F": {"I": 9}, "G": {"H": 8, "I": 2},
         "H": {"J": 5}, "I": {"J": 7}}
g, f, dec, cs, tc = mostra("Transportadora de A a J (custos em centenas de €)", arcos, "A", "J")
somas_enum = sum(len(p) - 2 for p, _ in tc)          # um percurso com m arcos pede m - 1 somas
somas_pd = sum(len(s) for s in arcos.values())       # uma soma por arco
print("  enumerar: %d somas; PD: %d somas (uma por arco)" % (somas_enum, somas_pd))
print("  em geral (N etapas, k nós por etapa):")
esforco = [(N, k, float(k) ** N, N * k * k) for N, k in [(4, 3), (10, 10), (20, 10)]]
for N, k, perc, somas in esforco:
    print("    N = %2d, k = %2d: %g percursos, %g somas da PD" % (N, k, perc, somas))
ok &= (g == 21 and f["A"] == 17 and cs == [["A", "B", "G", "I", "J"]]
       and [f[n] for n in "BCDEFGHI"] == [13, 18, 13, 11, 16, 9, 5, 7]
       and dec["E"] == ["H", "I"] and dec["C"] == ["E", "G"]
       and len(tc) == 15 and somas_enum == 45 and somas_pd == 19
       and [(p, s) for _, _, p, s in esforco] == [(81, 36), (1e10, 1000), (1e20, 2000)])

# ------------------------------------------------------------ Para resolver na aula
E1 = {1: {2: 5, 3: 9, 4: 8}, 2: {5: 10, 6: 17}, 3: {5: 4, 6: 10}, 4: {5: 9, 6: 9}, 5: {7: 19}, 6: {7: 9}}
E2 = {1: {2: 7, 3: 8, 4: 9}, 2: {5: 12}, 3: {5: 8, 6: 9}, 4: {5: 7, 6: 13}, 5: {7: 9}, 6: {7: 6}}
E3 = {1: {2: 5, 3: 14, 4: 6}, 2: {3: 6, 5: 12, 6: 12}, 3: {5: 2, 6: 3}, 4: {3: 7, 6: 9}, 5: {7: 4}, 6: {7: 4}}
esperado = [(26, [[1, 4, 6, 7]], 34), (23, [[1, 3, 6, 7]], 28), (17, [[1, 2, 3, 5, 7]], 17)]
for n, (G, (fo, co, go)) in enumerate(zip([E1, E2, E3], esperado), start=1):
    g, f, dec, cs, tc = mostra("Exemplo %d (do nó 1 ao nó 7)" % n, G, 1, 7)
    ok &= f[1] == fo and cs == co and g == go and min(v for _, v in tc) == fo
ok &= dec[4] == [3, 6]                                # Exemplo 3: empate em 4, que não interessa ao ótimo

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
