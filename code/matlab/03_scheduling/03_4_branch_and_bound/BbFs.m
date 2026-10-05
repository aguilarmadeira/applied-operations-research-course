function [v, s, nos, lims] = BbFs(P)
%BBFS  Branch and bound para o flow shop (tempo total), fixando do início.
%
%   [v, s, nos, lims] = BbFs(P)
%   v: tempo total ótimo; s: sequência ótima (índices);
%   nos{k}, lims(k): sequência parcial e limite (LbFs) do k-ésimo nó gerado, pela ordem de geração.
%   Exploração best-first: o nó de menor limite primeiro; empates pela ordem dos índices.
%   Poda-se um nó quando o limite é >= ao valor do incumbente; sem incumbente não se poda.
%
%   Complementos de IO — deck 3.4.  J. F. A. Madeira — Licença MIT.
n = size(P, 1);
v = Inf;  s = [];
abertos = {[]};  limAb = LbFs([], P);     % nós por explorar
nos = {};  lims = [];
while ~isempty(abertos)
  % o de menor limite; empates: a sequência lexicograficamente menor
  k = find(limAb == min(limAb));
  M = zeros(numel(k), n);
  for r = 1:numel(k), M(r, 1:numel(abertos{k(r)})) = abertos{k(r)}; end
  [~, o] = sortrows(M);
  k = k(o(1));
  b = limAb(k);  t0 = abertos{k};
  abertos(k) = [];  limAb(k) = [];
  if b >= v, continue; end                 % podado
  for j = 1:n
    if any(t0 == j), continue; end
    t = [t0 j];
    lb = LbFs(t, P);
    nos{end+1} = t;  lims(end+1) = lb; %#ok<AGROW>
    if numel(t) == n
      if lb < v, v = lb;  s = t; end       % novo incumbente
    elseif lb < v
      abertos{end+1} = t;  limAb(end+1) = lb; %#ok<AGROW>
    end
  end
end
end
