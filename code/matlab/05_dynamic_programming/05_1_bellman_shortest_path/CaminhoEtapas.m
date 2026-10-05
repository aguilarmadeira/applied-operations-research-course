function [f, dec] = CaminhoEtapas(C, fim)
%CAMINHOETAPAS  Caminho mais curto por programação dinâmica (recursão para trás).
%
%   [f, dec] = CaminhoEtapas(C, fim)
%   C: matriz n x n dos custos dos arcos, C(i,j) = custo do arco i -> j (Inf se não há arco).
%   f(fim) = 0,  f(i) = min_j { C(i,j) + f(j) }.
%   Cada nó é calculado depois de todos os seus sucessores (não é preciso dar as
%   etapas: serve também para redes com arcos dentro da mesma «coluna»).
%   f: vetor n x 1 com o custo mínimo de cada nó até fim (NaN nos nós sem caminho).
%   dec: cell n x 1; dec{i} = sucessores ótimos de i (mais do que um em caso de empate).
%
%   Complementos de IO — deck 5.1.  J. F. A. Madeira — Licença MIT.
n = size(C, 1);
f = NaN(n, 1);  f(fim) = 0;
dec = cell(n, 1);
pend = find(any(isfinite(C), 2))';
pend(pend == fim) = [];
while ~isempty(pend)
  feito = false;
  for i = pend
    suc = find(isfinite(C(i,:)));
    if all(~isnan(f(suc)))                       % sucessores todos calculados
      vals = C(i, suc) + f(suc)';
      m = min(vals);
      f(i) = m;
      dec{i} = suc(vals == m);
      pend(pend == i) = [];
      feito = true;
      break
    end
  end
  if ~feito
    error('grafo com ciclo ou nó sem saída');
  end
end
end
