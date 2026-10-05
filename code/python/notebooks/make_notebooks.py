"""Gera os cadernos Jupyter/Colab a partir dos exemplos ex*.py: um por capítulo
(nesta pasta) e um por exemplo (ex*.ipynb, ao lado do ex*.py).

Os ficheiros ex*.py são a única fonte: cada caderno tem uma célula de
preparação (no Colab clona o repositório; dentro do repositório usa a pasta
code/python) e, por método, uma célula de texto (deck, funções usadas e a
descrição do exemplo) seguida do código do exemplo, sem as 3 linhas de
caminhos (substituídas pela célula de preparação).

Depois de alterar um exemplo, correr outra vez (a partir de qualquer pasta):
    python make_notebooks.py            # gera os cadernos sem saídas
    python make_notebooks.py --executar # gera e executa (guarda as saídas)

Complementos de IO — código da UC.  J. F. A. Madeira — Licença MIT.
"""
import glob
import os
import re
import sys

import nbformat
from nbformat.v4 import new_code_cell, new_markdown_cell, new_notebook

AQUI = os.path.dirname(os.path.abspath(__file__))
PY = os.path.dirname(AQUI)                     # code/python
REPO = "aguilarmadeira/applied-operations-research-course"
BLOB = f"https://github.com/{REPO}/blob/main/code/python"
COLAB = f"https://colab.research.google.com/github/{REPO}/blob/main/code/python/notebooks"

CAPITULOS = {
    "01_decision_theory": "1 — Teoria da decisão",
    "02_project_planning": "2 — Planeamento de projetos (CPM, PERT, Gantt e crashing)",
    "03_scheduling": "3 — Problemas sequenciais",
    "04_replacement": "4 — Teoria da substituição",
    "05_dynamic_programming": "5 — Programação dinâmica",
    "06_queueing": "6 — Filas de espera",
    "07_inventory": "7 — Gestão de stocks",
    "08_ahp": "8 — Decisão multicritério (AHP)",
}

# Títulos das secções = subtítulos dos decks (por nome do exemplo).
TITULOS = {
    "ex01_1_decision_problem": "1.1 O problema de decisão",
    "ex01_2_nonprobabilistic_criteria": "1.2 Critérios de decisão não probabilísticos",
    "ex01_3_probabilistic_criteria": "1.3 Critérios de decisão probabilísticos",
    "ex01_4_subjective_probabilities": "1.4 Probabilidades subjetivas",
    "ex02_1_cpm": "2.1 Planeamento de projetos: CPM",
    "ex02_2_pert": "2.2 Planeamento de projetos: PERT",
    "ex02_3_gantt_crashing": "2.3 Diagrama de Gantt e aceleração de projetos (crashing)",
    "ex03_1_johnson": "3.1 Problemas sequenciais: regra de Johnson (2 máquinas)",
    "ex03_2_m_machines": "3.2 Problemas sequenciais: três ou mais máquinas",
    "ex03_3_tdm": "3.3 Problemas sequenciais: método do desvio de tempo (TDM)",
    "ex03_4_branch_and_bound": "3.4 Problemas sequenciais: branch and bound",
    "ex04_1_wear": "4.1 Teoria da substituição: equipamentos que se desgastam",
    "ex04_2_discounting": "4.2 Teoria da substituição: com valor temporal do dinheiro",
    "ex04_3_group_replacement": "4.3 Teoria da substituição: falhas súbitas e substituição de grupo",
    "ex05_1_bellman_shortest_path": "5.1 Programação dinâmica: princípio de Bellman e caminho mais curto",
    "ex05_2_knapsack": "5.2 Programação dinâmica: o problema da mochila",
    "ex05_3_workforce": "5.3 Programação dinâmica: gestão da mão-de-obra",
    "ex06_1_mm1": "6.1 Filas de espera: conceitos, lei de Little e M/M/1",
    "ex06_2_mmk_mms": "6.2 Filas de espera: capacidade limitada e vários servidores",
    "ex06_3_mmr": "6.3 Filas de espera: população finita (M/M/R)",
    "ex07_1_abc_eoq": "7.1 Gestão de stocks: classificação ABC e quantidade económica de encomenda",
    "ex07_2_shortages_discounts": "7.2 Gestão de stocks: rutura planeada e descontos de quantidade",
    "ex07_3_production": "7.3 Gestão de stocks: produção e consumo simultâneos",
    "ex08_1_ahp": "8.1 Decisão multicritério: o AHP, comparações par a par e consistência",
    "ex08_2_attributes": "8.2 Decisão multicritério: atributos quantitativos e agregação",
    "ex08_3_sensitivity": "8.3 Decisão multicritério: análise de sensibilidade",
}

# Secções sem exemplo em Python.
SEM_EXEMPLO = {}

CABECALHO = re.compile(
    r"^import os, sys\n"
    r"sys\.path\.insert\(0, os\.path\.join\(os\.path\.dirname\(os\.path\.abspath\(__file__\)\), \"\.\.\", \"\.\.\"\)\)\n"
    r"import uc_setup[^\n]*\n", re.M)

PREPARACAO = '''\
# Preparação: põe as funções da UC no caminho do Python.
# No Colab (ou noutra pasta), clona o repositório; dentro do repositório, usa code/python.
import os, sys
LOCAL = [p for p in ("..", os.path.join("..", "..")) if os.path.isfile(os.path.join(p, "uc_setup.py"))]
if LOCAL:
    RAIZ = os.path.abspath(LOCAL[0])
else:
    if not os.path.isdir("applied-operations-research-course"):
        !git clone -q --depth 1 https://github.com/aguilarmadeira/applied-operations-research-course
    RAIZ = os.path.abspath(os.path.join("applied-operations-research-course", "code", "python"))
if RAIZ not in sys.path:
    sys.path.insert(0, RAIZ)
import uc_setup  # acrescenta as pastas dos métodos e common/
print("Código da UC pronto.")'''


def modulos_da_uc(fonte):
    """Ficheiros .py da UC importados pelo exemplo (caminho relativo a code/python)."""
    fich = []
    for mod in re.findall(r"^from (\w+) import", fonte, re.M):
        achados = [p for p in glob.glob(os.path.join(PY, "**", mod + ".py"), recursive=True)
                   if os.sep + "notebooks" + os.sep not in p]
        if achados:
            fich.append(os.path.relpath(achados[0], PY).replace(os.sep, "/"))
    return fich


def seccao(caminho):
    nome = os.path.splitext(os.path.basename(caminho))[0]
    rel = os.path.relpath(caminho, PY).replace(os.sep, "/")
    fonte = open(caminho, encoding="utf-8").read()
    m = re.match(r'"""(.*?)"""\n', fonte, re.S)
    doc, corpo = (m.group(1), fonte[m.end():]) if m else ("", fonte)
    corpo, n = CABECALHO.subn("", corpo, count=1)
    if n != 1:
        sys.exit(f"{rel}: cabeçalho de caminhos não encontrado")
    # Descrição: sem a linha «Correr (de qualquer pasta)…» nem a assinatura final.
    linhas = [l for l in doc.strip().splitlines()
              if not l.startswith("Correr (de qualquer pasta)")
              and not l.startswith("Complementos de IO — ")]
    descricao = "\n".join(linhas).strip()
    funcs = ", ".join(f"[`{os.path.basename(f)}`]({BLOB}/{f})" for f in modulos_da_uc(corpo))
    texto = f"## {TITULOS[nome]}\n\nExemplo [`{os.path.basename(rel)}`]({BLOB}/{rel})"
    if funcs:
        texto += f" · funções da UC: {funcs}"
    texto += f"\n\n```text\n{descricao}\n```"
    return [new_markdown_cell(texto), new_code_cell(corpo.strip() + "\n")]


def caderno(pasta, titulo):
    num = titulo.split(" ")[0]
    ficheiro = f"{pasta}.ipynb"
    cel = [new_markdown_cell(
        f"# Complementos de Investigação Operacional — capítulo {num}: {titulo.split(' — ', 1)[1]}\n"
        f"### Exemplos em Python\n\n"
        f"[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)]({COLAB}/{ficheiro})\n\n"
        "Cada secção corre o exemplo `ex….py` do método e compara os resultados com os slides "
        "(no fim: *confere com os slides: sim*). Comece pela célula **Preparação**; no Colab, "
        "*Runtime → Run all* corre tudo.\n\n"
        "Os slides usam vírgula decimal; aqui usa-se o ponto. Este caderno é gerado a partir dos "
        "ficheiros `ex….py` por `make_notebooks.py`.\n\n"
        f"*Examples for Chapter {num} of the course \"Complements of Operational Research\" (ISEL, J. F. A. Madeira). "
        "Code comments and printed messages are in Portuguese; the English slides are in "
        "[`notes/en/`](https://github.com/aguilarmadeira/applied-operations-research-course/tree/main/notes/en).*"),
        new_markdown_cell("## Preparação"),
        new_code_cell(PREPARACAO)]
    exemplos = sorted(glob.glob(os.path.join(PY, pasta, "*", "ex*.py")))
    exemplos = [e for e in exemplos if os.path.splitext(os.path.basename(e))[0] in TITULOS]
    blocos = [(os.path.basename(os.path.dirname(e)), seccao(e)) for e in exemplos]
    for tit, readme in SEM_EXEMPLO.get(pasta, []):
        blocos.append((os.path.basename(os.path.dirname(readme)), [new_markdown_cell(
            f"## {tit}\n\nCódigo de investigação do docente, distribuído na aula; não faz parte "
            f"do código da UC nem deste caderno. Ver [`README.md`]({BLOB}/{readme}).")]))
    for _, c in sorted(blocos, key=lambda b: b[0]):
        cel += c
    nb = new_notebook(cells=cel, metadata={
        "kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"},
        "language_info": {"name": "python"},
        "colab": {"provenance": [], "toc_visible": True}})
    return os.path.join(AQUI, ficheiro), nb


def caderno_exemplo(caminho):
    """Um caderno só com este exemplo, ao lado do ex*.py (para o link Colab de cada método)."""
    rel = os.path.relpath(caminho, PY).replace(os.sep, "/")
    ficheiro = rel[:-3] + ".ipynb"
    capitulo = CAPITULOS[rel.split("/")[0]].split(" — ", 1)
    cel = [new_markdown_cell(
        f"# Complementos de Investigação Operacional — capítulo {capitulo[0]}: {capitulo[1]}\n\n"
        f"[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)]"
        f"(https://colab.research.google.com/github/{REPO}/blob/main/code/python/{ficheiro})\n\n"
        "Corra a célula **Preparação** e depois o exemplo (no Colab: *Runtime → Run all*). "
        "No fim, o exemplo compara os resultados com os slides (*confere com os slides: sim*). "
        "Os slides usam vírgula decimal; aqui usa-se o ponto. Caderno gerado a partir de "
        f"`{os.path.basename(caminho)}` por `notebooks/make_notebooks.py`.\n\n"
        "*Code comments and printed messages are in Portuguese.*"),
        new_markdown_cell("## Preparação"), new_code_cell(PREPARACAO)] + seccao(caminho)
    nb = new_notebook(cells=cel, metadata={
        "kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"},
        "language_info": {"name": "python"},
        "colab": {"provenance": []}})
    return os.path.join(PY, ficheiro), nb


def main():
    executar = "--executar" in sys.argv
    trabalhos = [caderno(pasta, titulo) for pasta, titulo in CAPITULOS.items()]
    for pasta in CAPITULOS:
        for e in sorted(glob.glob(os.path.join(PY, pasta, "*", "ex*.py"))):
            if os.path.splitext(os.path.basename(e))[0] in TITULOS:
                trabalhos.append(caderno_exemplo(e))
    for destino, nb in trabalhos:
        if executar:
            from nbconvert.preprocessors import ExecutePreprocessor
            ExecutePreprocessor(timeout=600, kernel_name="python3").preprocess(
                nb, {"metadata": {"path": os.path.dirname(destino)}})
        nbformat.validate(nb)
        nbformat.write(nb, destino)
        print(f"{os.path.relpath(destino, PY)}: {sum(c.cell_type == 'code' for c in nb.cells) - 1} exemplo(s)")


if __name__ == "__main__":
    main()
