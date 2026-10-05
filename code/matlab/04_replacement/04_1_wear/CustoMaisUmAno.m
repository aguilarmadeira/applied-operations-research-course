function M = CustoMaisUmAno(C, S, n, d)
%CUSTOMAISUMANO  Custo de manter o equipamento mais um ano (o ano n+1).
%
%   M = CustoMaisUmAno(C, S, n)      sem desconto: M = C_{n+1} + (S_n - S_{n+1})
%   M = CustoMaisUmAno(C, S, n, d)   com desconto (4.2), d = 1/(1+r): M = C_{n+1} + S_n - d S_{n+1}
%   S: revenda no fim de cada ano (vetor) ou valor de sucata fixo.
%   Regra: substituir ao fim do ano n quando M > A(n) (ou > W(n), com desconto).
%
%   Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.
if nargin < 4, d = 1; end
M = C(n + 1) + Revenda(S, n) - d * Revenda(S, n + 1);
end
