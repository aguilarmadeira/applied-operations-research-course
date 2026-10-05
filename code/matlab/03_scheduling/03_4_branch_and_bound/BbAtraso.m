function [v, s, nos, lims] = BbAtraso(p, d)
%BBATRASO  Branch and bound para o atraso total numa máquina, fixando do fim.
%
%   [v, s, nos, lims] = BbAtraso(p, d)
%   v: atraso total ótimo; s: sequência ótima (índices);
%   nos{k}, lims(k): trabalhos fixados no fim (pela ordem em que ficam) e limite do k-ésimo nó gerado.
%   Limite = atraso dos trabalhos já fixados no fim (a sua conclusão é conhecida:
%   soma de todos os p menos a soma dos que vêm depois).
%   Exploração best-first: o nó de menor limite primeiro; empates pela ordem dos índices.
%
%   Complementos de IO — deck 3.4.  J. F. A. Madeira — Licença MIT.
p = p(:)';  d = d(:)';
n = numel(p);
Ptot = sum(p);
v = Inf;  s = [];
abertos = {[]};  limAb = 0;
nos = {};  lims = [];
while ~isempty(abertos)
  k = find(limAb == min(limAb));
  M = zeros(numel(k), n);
  for r = 1:numel(k), M(r, 1:numel(abertos{k(r)})) = abertos{k(r)}; end
  [~, o] = sortrows(M);
  k = k(o(1));
  b = limAb(k);  suf0 = abertos{k};
  abertos(k) = [];  limAb(k) = [];
  if b >= v, continue; end                 % podado
  for j = 1:n
    if any(suf0 == j), continue; end
    suf = [j suf0];
    C = Ptot - sum(p(suf)) + cumsum(p(suf));   % conclusões dos trabalhos fixados no fim
    lb = sum(max(0, C - d(suf)));
    nos{end+1} = suf;  lims(end+1) = lb; %#ok<AGROW>
    if numel(suf) == n
      if lb < v, v = lb;  s = suf; end     % novo incumbente
    elseif lb < v
      abertos{end+1} = suf;  limAb(end+1) = lb; %#ok<AGROW>
    end
  end
end
end
