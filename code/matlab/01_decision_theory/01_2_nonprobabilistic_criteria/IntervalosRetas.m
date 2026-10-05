function [lim, quem] = IntervalosRetas(a, b, t0, t1, maior)
%INTERVALOSRETAS  Onde cada reta v_i(t) = a_i + b_i t está por cima em [t0, t1].
%
%   [lim, quem] = IntervalosRetas(a, b)           em [0, 1]
%   [lim, quem] = IntervalosRetas(a, b, t0, t1, maior)
%   lim: uma linha [início fim] por intervalo; quem{k}: índices da(s) reta(s) por cima
%   (por baixo, se maior = false).  Em Hurwicz: a = mínimos, b = máximos - mínimos, t = alpha.
%
%   Complementos de IO — deck 1.2.  J. F. A. Madeira — Licença MIT.
if nargin < 3, t0 = 0; end
if nargin < 4, t1 = 1; end
if nargin < 5, maior = true; end
a = a(:)';  b = b(:)';
cortes = [t0 t1];
for i = 1:numel(a)
  for k = i+1:numel(a)
    if abs(b(i) - b(k)) > 1e-12
      t = (a(k) - a(i)) / (b(i) - b(k));
      if t > t0 && t < t1, cortes(end+1) = round(t*1e12)/1e12; end %#ok<AGROW>
    end
  end
end
cortes = unique(cortes);
lim = zeros(0, 2);  quem = {};
for j = 1:numel(cortes) - 1
  v = a + b*(cortes(j) + cortes(j+1))/2;
  if maior, alvo = max(v); else, alvo = min(v); end
  q = find(abs(v - alvo) <= 1e-9);
  if ~isempty(quem) && isequal(quem{end}, q)
    lim(end, 2) = cortes(j+1);
  else
    lim(end+1, :) = [cortes(j) cortes(j+1)]; %#ok<AGROW>
    quem{end+1} = q; %#ok<AGROW>
  end
end
end
