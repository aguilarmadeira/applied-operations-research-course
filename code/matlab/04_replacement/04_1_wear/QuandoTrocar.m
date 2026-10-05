function [anos, linhas, decisao] = QuandoTrocar(C, S, idade, minimo, d)
%QUANDOTROCAR  Duas máquinas: até quando manter a antiga, que tem idade anos.
%
%   [anos, linhas, decisao] = QuandoTrocar(C, S, idade, minimo)
%   [anos, linhas, decisao] = QuandoTrocar(C, S, idade, minimo, d)
%   Manter a antiga enquanto o custo de mais um ano dela for menor do que o custo médio
%   mínimo da nova (minimo). C, S: custos e revendas da antiga; d: fator de desconto (por omissão 1).
%   anos = n: trocar ao fim do ano n da antiga; anos = [n n+1]: empate (indiferente).
%   linhas: uma linha [k, M_k] por ano k = idade+1, ... da antiga;
%   decisao{j}: 'manter', 'indiferente' ou 'trocar'.
%
%   Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.
if nargin < 5, d = 1; end
linhas = zeros(0, 2);
decisao = {};
anos = numel(C);
for n = idade:numel(C) - 1
  M = CustoMaisUmAno(C, S, n, d);
  if abs(M - minimo) <= 1e-9
    dec = 'indiferente';
  elseif M < minimo
    dec = 'manter';
  else
    dec = 'trocar';
  end
  linhas(end + 1, :) = [n + 1, M]; %#ok<AGROW>
  decisao{end + 1} = dec; %#ok<AGROW>
  if strcmp(dec, 'indiferente')
    anos = [n, n + 1];
    return;
  end
  if strcmp(dec, 'trocar')
    anos = n;
    return;
  end
end
end
