function [vals, seqs] = ForcaBruta(P, f)
%FORCABRUTA  Avalia todas as n! sequências e ordena-as por valor.
%
%   [vals, seqs] = ForcaBruta(P)       valor = tempo total, Cmax(s, P)
%   [vals, seqs] = ForcaBruta(P, f)    valor = f(s), com s um vetor de índices
%   P: matriz n x m de tempos (ou vetor coluna com n tempos).
%   vals: valores por ordem crescente (vals(1) é o ótimo); seqs(k, :) é a sequência de vals(k).
%   Empates no valor: por ordem lexicográfica dos índices.
%
%   Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.
if nargin < 2 || isempty(f), f = @(s) Cmax(s, P); end
n = size(P, 1);
S = perms(1:n);
v = zeros(size(S, 1), 1);
for k = 1:size(S, 1)
  v(k) = f(S(k, :));
end
X = sortrows([v S]);
vals = X(:, 1);
seqs = X(:, 2:end);
end
