# Código da UC — organização e caminhos

- **Clonar o repositório inteiro.** As pastas dependem umas das outras (p. ex. os exemplos de 1.2 usam a dominância de 1.1), por isso uma pasta copiada sozinha não corre.
- **Os exemplos correm a partir de qualquer pasta.** Cada `ex*.m` começa por

  ```matlab
  addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC
  ```

  e cada `ex*.py` por

  ```python
  import os, sys
  sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
  import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)
  ```

- **Nos seus próprios scripts**, para usar as funções da UC:
  - MATLAB/Octave: `addpath('<repo>/code/matlab'); uc_setup`
  - Python: `import sys; sys.path.insert(0, '<repo>/code/python'); import uc_setup`
- **Cada função existe uma só vez**, na pasta do deck que a introduz (p. ex. `dominadas` em `01_1_decision_problem/`); quem a reutiliza noutro deck usa-a de lá.
- **Python e MATLAB fazem o mesmo.** O MATLAB é uma tradução do Python, com as mesmas funções (em MATLAB com maiúscula inicial: `criterios` → `Criterios`) e a mesma saída. Cada exemplo termina com *confere com os slides: sim*.
- **Verificar respostas sem ver a resolução:** `verifica_escolhas` / `VerificaEscolhas` (1.2) diz se a ação escolhida em cada critério está certa.

## Correr no Colab (sem instalar nada)

Há um caderno por exemplo (`ex*.ipynb`, ao lado do `ex*.py`) e um caderno por capítulo em `python/notebooks/`. A primeira célula clona o repositório no Colab (ou, dentro do repositório, usa `code/python`).

| Capítulo | Colab |
|---|---|
| 1 Teoria da decisão | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/aguilarmadeira/applied-operations-research-course/blob/main/code/python/notebooks/01_decision_theory.ipynb) |
| 2 Planeamento de projetos | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/aguilarmadeira/applied-operations-research-course/blob/main/code/python/notebooks/02_project_planning.ipynb) |
| 3 Problemas sequenciais | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/aguilarmadeira/applied-operations-research-course/blob/main/code/python/notebooks/03_scheduling.ipynb) |
| 4 Teoria da substituição | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/aguilarmadeira/applied-operations-research-course/blob/main/code/python/notebooks/04_replacement.ipynb) |
| 5 Programação dinâmica | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/aguilarmadeira/applied-operations-research-course/blob/main/code/python/notebooks/05_dynamic_programming.ipynb) |
| 6 Filas de espera | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/aguilarmadeira/applied-operations-research-course/blob/main/code/python/notebooks/06_queueing.ipynb) |
| 7 Gestão de stocks | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/aguilarmadeira/applied-operations-research-course/blob/main/code/python/notebooks/07_inventory.ipynb) |
| 8 Decisão multicritério (AHP) | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/aguilarmadeira/applied-operations-research-course/blob/main/code/python/notebooks/08_ahp.ipynb) |

Os `ex*.py` são a fonte: os cadernos são gerados por `python/notebooks/make_notebooks.py` (`python make_notebooks.py --executar` gera-os e guarda as saídas).

## Correr no MATLAB Online (para quem tem conta MathWorks)

O link abre o repositório no MATLAB Online e o script do capítulo, que corre todos os exemplos. Quem não tem conta descarrega a pasta `matlab/` e corre os `ex*.m` no MATLAB ou no GNU Octave.

| Capítulo | MATLAB Online |
|---|---|
| 1 Teoria da decisão | [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=aguilarmadeira/applied-operations-research-course&file=code/matlab/01_decision_theory/ex01_capitulo.m) |
| 2 Planeamento de projetos | [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=aguilarmadeira/applied-operations-research-course&file=code/matlab/02_project_planning/ex02_capitulo.m) |
| 3 Problemas sequenciais | [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=aguilarmadeira/applied-operations-research-course&file=code/matlab/03_scheduling/ex03_capitulo.m) |
| 4 Teoria da substituição | [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=aguilarmadeira/applied-operations-research-course&file=code/matlab/04_replacement/ex04_capitulo.m) |
| 5 Programação dinâmica | [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=aguilarmadeira/applied-operations-research-course&file=code/matlab/05_dynamic_programming/ex05_capitulo.m) |
| 6 Filas de espera | [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=aguilarmadeira/applied-operations-research-course&file=code/matlab/06_queueing/ex06_capitulo.m) |
| 7 Gestão de stocks | [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=aguilarmadeira/applied-operations-research-course&file=code/matlab/07_inventory/ex07_capitulo.m) |
| 8 Decisão multicritério (AHP) | [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=aguilarmadeira/applied-operations-research-course&file=code/matlab/08_ahp/ex08_capitulo.m) |

Testado com Python 3.13 (numpy 2.5; scipy em 2.3 e 5.2) e GNU Octave 8.4. As saídas de Python e MATLAB/Octave são iguais, exceto nas simulações (o gerador aleatório do MATLAB não é o do numpy: aí os exemplos conferem com tolerância) e nas duas verificações por programação linear, que só existem em Python (2.3 e 5.2).

Em 3.3 e 3.4 há ainda duas experiências aleatórias só em Python (`experiencia_aleatoria.py`, `experiencia_bb.py`), que reproduzem os números dos slides sobre 500 problemas aleatórios.
