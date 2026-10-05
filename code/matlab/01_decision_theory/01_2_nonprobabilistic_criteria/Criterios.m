function res = Criterios(C, alpha, custos)
%CRITERIOS  Os cinco critérios não probabilísticos.
%
%   res = Criterios(C, alpha, custos)
%   alpha: índice de otimismo de Hurwicz (por omissão 0.5; pesa sempre o melhor resultado)
%   custos: true para matriz de custos (por omissão false); os nomes dos campos mantêm-se.
%   res.maximax, res.maximin, res.laplace, res.savage, res.hurwicz são estruturas com
%   .valores (um por ação) e .escolha (índices das ações escolhidas).
%
%   Complementos de IO — deck 1.2.  J. F. A. Madeira — Licença MIT.
if nargin < 2, alpha = 0.5; end
if nargin < 3, custos = false; end
mx = max(C, [], 2);  mn = min(C, [], 2);  med = mean(C, 2);
sav = max(Arrependimentos(C, custos), [], 2);
if custos
  v = {mn, mx, med, sav, alpha*mn + (1 - alpha)*mx};
  maior = [false false false false false];
else
  v = {mx, mn, med, sav, alpha*mx + (1 - alpha)*mn};
  maior = [true true true false true];
end
nomes = {'maximax', 'maximin', 'laplace', 'savage', 'hurwicz'};
res = struct();
for k = 1:5
  x = v{k}(:)';
  if maior(k), alvo = max(x); else, alvo = min(x); end
  res.(nomes{k}) = struct('valores', x, 'escolha', find(abs(x - alvo) <= 1e-9));
end
end
