function [linha, i] = Melhor(L, k)
%MELHOR  A linha de L com o menor valor na coluna k (em empate, a primeira).
%
%   [linha, i] = Melhor(L)      coluna k = a última
%   [linha, i] = Melhor(L, k)
%
%   Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.
if nargin < 2, k = size(L, 2); end
[~, i] = min(L(:, k));
linha = L(i, :);
end
