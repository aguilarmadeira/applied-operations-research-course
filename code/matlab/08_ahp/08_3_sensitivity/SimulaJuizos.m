function [freq, fracinc] = SimulaJuizos(C, M, qualitativos, N, degraus, seed)
%SIMULAJUIZOS  Frequência do 1.º lugar de cada alternativa quando todos os juízos são perturbados.
%
%   [freq, fracinc] = SimulaJuizos(C, M)
%   [freq, fracinc] = SimulaJuizos(C, M, qualitativos, N, degraus, seed)
%   C: matriz de comparação dos critérios; M: prioridades locais (alternativas x critérios).
%   qualitativos: célula com uma linha {coluna de M, matriz de comparação das alternativas} por
%   critério qualitativo (essas colunas são recalculadas a partir da matriz perturbada); {} se não houver.
%   Por omissão N = 20000, degraus = 1, seed = 1 (rng(seed)).
%   freq: frequência do 1.º lugar (coluna); fracinc: fração das matrizes dos critérios com RC > 0.1.
%   O gerador não é o do numpy: as frequências ficam próximas das do Python, não iguais.
%
%   Complementos de IO — deck 8.3.  J. F. A. Madeira — Licença MIT.
if nargin < 3, qualitativos = {}; end
if nargin < 4, N = 20000; end
if nargin < 5, degraus = 1; end
if nargin < 6, seed = 1; end
rng(seed);
vit = zeros(size(M, 1), 1);
inc = 0;
for r = 1:N
  [w, ~, ~, rc] = Prioridades(Perturba(C, degraus));
  inc = inc + (rc > 0.1);
  Mr = M;
  for q = 1:size(qualitativos, 1)
    Mr(:, qualitativos{q, 1}) = Prioridades(Perturba(qualitativos{q, 2}, degraus));
  end
  [~, b] = max(Mr * w);
  vit(b) = vit(b) + 1;
end
freq = vit / N;
fracinc = inc / N;
end
