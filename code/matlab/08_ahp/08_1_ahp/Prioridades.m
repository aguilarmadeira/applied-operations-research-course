function [w, lam, IC, RC] = Prioridades(A, metodo)
%PRIORIDADES  Pesos (prioridades) e consistência de uma matriz de comparações par a par.
%
%   [w, lam, IC, RC] = Prioridades(A)            método das colunas (aulas e testes)
%   [w, lam, IC, RC] = Prioridades(A, 'vetor')   vetor próprio do maior valor próprio (Saaty, eig)
%   'colunas': w = média das linhas da matriz normalizada por colunas; lam = média de (Aw)_i / w_i.
%   'vetor':   w = vetor próprio de lambda_max, normalizado para somar 1.
%   w é uma coluna; IC = (lam - n)/(n - 1) e RC = IC / RI(n) (0 se n <= 2), com o índice
%   aleatório de Saaty RI = 0, 0, 0.58, 0.90, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49 (n = 1, ..., 10).
%
%   Complementos de IO — deck 8.1.  J. F. A. Madeira — Licença MIT.
if nargin < 2, metodo = 'colunas'; end
RI = [0 0 0.58 0.90 1.12 1.24 1.32 1.41 1.45 1.49];
A = double(A);
n = size(A, 1);
if strcmp(metodo, 'colunas')
  w = mean(A ./ sum(A, 1), 2);
  lam = mean((A * w) ./ w);
else
  [V, D] = eig(A);
  [~, k] = max(real(diag(D)));
  w = abs(real(V(:, k)));
  w = w / sum(w);
  lam = real(D(k, k));
end
IC = 0;  RC = 0;
if n > 2, IC = (lam - n) / (n - 1); end
if RI(n) > 0, RC = IC / RI(n); end
end
