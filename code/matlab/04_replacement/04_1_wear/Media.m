function L = Media(P, C, S)
%MEDIA  Tabela do custo médio anual (sem valor temporal do dinheiro).
%
%   L = Media(P, C, S)
%   Uma linha por ano: [n, C_n, soma C_i, P - S_n, total = soma C_i + P - S_n, A(n) = total / n].
%   S: revenda no fim de cada ano (vetor) ou valor de sucata fixo (por omissão 0).
%
%   Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.
if nargin < 3, S = 0; end
L = zeros(numel(C), 6);
soma = 0;
for n = 1:numel(C)
  soma = soma + C(n);
  perda = P - Revenda(S, n);
  L(n, :) = [n, C(n), soma, perda, soma + perda, (soma + perda) / n];
end
end
