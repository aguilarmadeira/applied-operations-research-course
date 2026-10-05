function W = CustoEquivalente(P, C, S, r)
%CUSTOEQUIVALENTE  Custo anual equivalente descontado W(n), para n = 1, ..., numel(C).
%
%   W = CustoEquivalente(P, C, S, r)
%   d = 1/(1+r); a compra P paga-se no instante 0, o custo C_i no início do ano i (fator d^(i-1))
%   e a revenda S_n no fim do ano n (fator d^n):
%       W(n) = (P + soma C_i d^(i-1) - S_n d^n) / soma d^(i-1);   com r = 0, W(n) = A(n) de 4.1.
%   S: revenda no fim de cada ano (vetor) ou valor de sucata fixo.
%   É a função do slide «Em Python» (custo_equivalente).
%
%   Complementos de IO — deck 4.2.  J. F. A. Madeira — Licença MIT.
d = 1 / (1 + r);
W = zeros(1, numel(C));
soma_c = 0;  soma_d = 0;
for n = 1:numel(C)
  soma_c = soma_c + C(n) * d^(n - 1);     % pago no início do ano n
  soma_d = soma_d + d^(n - 1);
  W(n) = (P + soma_c - Revenda(S, n) * d^n) / soma_d;
end
end
