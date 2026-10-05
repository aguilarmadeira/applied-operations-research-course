function ordem = Topo(acts)
%TOPO  Ordem topológica: cada atividade aparece depois de todos os seus precedentes.
%
%   ordem = Topo(acts)
%   acts: cell array com uma linha por atividade, {nome, {precedentes}, duração, ...}
%         (os campos a seguir à duração são ignorados aqui; o PERT e o crashing usam-nos).
%   ordem: índices das linhas de acts.
%
%   Complementos de IO — deck 2.1.  J. F. A. Madeira — Licença MIT.
n = size(acts, 1);
nomes = acts(:, 1)';
ordem = zeros(1, 0);
visto = false(1, n);
while numel(ordem) < n
  n0 = numel(ordem);
  for i = 1:n
    if ~visto(i) && all(ismember(acts{i, 2}, nomes(visto)))
      ordem(end+1) = i; %#ok<AGROW>
      visto(i) = true;
    end
  end
  if numel(ordem) == n0
    error('as precedências têm um ciclo (ou um precedente inexistente)');
  end
end
end
