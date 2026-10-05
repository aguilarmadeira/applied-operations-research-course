function [valor, x] = RegraRacio(w, v, W, ilimitada)
%REGRARACIO  Regra do rácio: escolher pelo maior v_i / w_i (pode falhar).
%
%   [valor, x] = RegraRacio(w, v, W)          mochila ilimitada
%   [valor, x] = RegraRacio(w, v, W, false)   mochila 0-1
%   Percorre os objetos por ordem decrescente de v_i / w_i (os empates pela ordem
%   dada) e põe o que couber: todas as unidades possíveis (ilimitada) ou uma (0-1).
%   x(i) = unidades do objeto i. Não garante o ótimo.
%
%   Complementos de IO — deck 5.2.  J. F. A. Madeira — Licença MIT.
if nargin < 4, ilimitada = true; end
[~, ordem] = sort(-v ./ w);               % sort é estável: os empates ficam pela ordem dada
x = zeros(1, numel(w));  k = W;
for i = ordem
  if ilimitada
    x(i) = floor(k / w(i));
  else
    x(i) = w(i) <= k;
  end
  k = k - x(i)*w(i);
end
valor = sum(x .* v);
end
