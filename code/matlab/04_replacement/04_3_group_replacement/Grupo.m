function [p, vida, ind, L] = Grupo(n, ci, cg, Pacum, T)
%GRUPO  Política individual contra política de grupo de t em t períodos.
%
%   [p, vida, ind, L] = Grupo(n, ci, cg, Pacum)      t = 1, ..., numel(p)
%   [p, vida, ind, L] = Grupo(n, ci, cg, Pacum, T)   t = 1, ..., T
%   ci: custo de uma troca individual; cg: custo por unidade na troca de grupo.
%   ind = (n / vida) ci, custo por período da política individual.
%   L: uma linha por t: [t, N_t, soma N_k, ci soma N_k, n cg, total, K(t) = total / t].
%
%   Complementos de IO — deck 4.3.  J. F. A. Madeira — Licença MIT.
if nargin < 5 || isempty(T)
  [p, vida, N] = Falhas(n, Pacum, 12);
  T = numel(p);
else
  [p, vida, N] = Falhas(n, Pacum, T);
end
ind = n / vida * ci;
L = zeros(T, 7);
soma = 0;
for t = 1:T
  soma = soma + N(t);
  tot = soma * ci + n * cg;
  L(t, :) = [t, N(t), soma, soma * ci, n * cg, tot, tot / t];
end
end
