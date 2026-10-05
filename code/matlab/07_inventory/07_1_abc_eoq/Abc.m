function [tot, linhas] = Abc(nomes, v, q, lim)
%ABC  Classificação ABC pelo valor anual (preço x quantidade).
%
%   [tot, linhas] = Abc(nomes, v, q)        A até 80 % do valor acumulado, B até 95 %, C o resto
%   [tot, linhas] = Abc(nomes, v, q, lim)   lim = [limite de A, limite de B] (em %)
%   nomes: cell com os nomes dos artigos; v: valores unitários; q: quantidades.
%   linhas: estrutura (uma por artigo, por ordem decrescente de valor) com os campos
%   nome, v, q, valor, pct (% do total), acum (% acumulada) e classe ('A', 'B' ou 'C').
%
%   Complementos de IO — deck 7.1.  J. F. A. Madeira — Licença MIT.
if nargin < 4, lim = [80 95]; end
v = v(:)';  q = q(:)';
valor = v .* q;
tot = sum(valor);
[~, ordem] = sort(-valor);            % ordenação estável, como o sorted do Python
linhas = struct('nome', {}, 'v', {}, 'q', {}, 'valor', {}, 'pct', {}, 'acum', {}, 'classe', {});
cum = 0;
for j = 1:numel(ordem)
  i = ordem(j);
  cum = cum + valor(i);
  c = 100 * cum / tot;
  if c <= lim(1) + 1e-9
    classe = 'A';
  elseif c <= lim(2) + 1e-9
    classe = 'B';
  else
    classe = 'C';
  end
  linhas(j) = struct('nome', nomes{i}, 'v', v(i), 'q', q(i), 'valor', valor(i), ...
                     'pct', 100 * valor(i) / tot, 'acum', c, 'classe', classe);
end
end
