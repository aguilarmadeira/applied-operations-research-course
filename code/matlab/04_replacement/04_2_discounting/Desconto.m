function L = Desconto(P, C, r, S)
%DESCONTO  Tabela do custo anual equivalente descontado, com taxa de desconto r.
%
%   L = Desconto(P, C, r, S)
%   Uma linha por ano:
%   [n, C_n, d^(n-1), C_n d^(n-1), soma C_i d^(i-1), P + soma - S_n d^n, soma d^(i-1), W(n)].
%   S: revenda no fim de cada ano (vetor) ou valor de sucata fixo (por omissão 0).
%
%   Complementos de IO — deck 4.2.  J. F. A. Madeira — Licença MIT.
if nargin < 4, S = 0; end
d = 1 / (1 + r);
L = zeros(numel(C), 8);
E = 0;  H = 0;
for n = 1:numel(C)
  f = d^(n - 1);
  E = E + C(n) * f;
  H = H + f;
  num = P + E - Revenda(S, n) * d^n;
  L(n, :) = [n, C(n), f, C(n) * f, E, num, H, num / H];
end
end
