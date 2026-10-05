function A = CustoMedio(P, C, S)
%CUSTOMEDIO  Custo médio anual A(n), para n = 1, ..., numel(C) (sem valor temporal do dinheiro).
%
%   A = CustoMedio(P, C, S)
%   P: custo de compra; C: custos de funcionamento por ano (C(1) é o ano 1);
%   S: revenda no fim de cada ano (vetor) ou valor de sucata fixo (por omissão 0).
%   A(n) = (P - S_n + C_1 + ... + C_n) / n; substituir ao fim de n* anos, com A(n*) mínimo.
%   É a função do slide «Em Python» (custo_medio).
%
%   Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.
if nargin < 3, S = 0; end
A = zeros(1, numel(C));
soma = 0;
for n = 1:numel(C)
  soma = soma + C(n);
  A(n) = (P - Revenda(S, n) + soma) / n;
end
end
