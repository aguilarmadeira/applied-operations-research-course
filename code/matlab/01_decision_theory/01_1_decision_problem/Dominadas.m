function pares = Dominadas(C, custos)
%DOMINADAS  Pares [i k] em que a ação i é dominada pela ação k.
%
%   pares = Dominadas(C)          ganhos: C(i,:) <= C(k,:) e < em pelo menos um estado
%   pares = Dominadas(C, true)    custos: os sentidos invertem-se
%   pares tem uma linha por par (índices a partir de 1); vazio se não houver.
%
%   Complementos de IO — deck 1.1.  J. F. A. Madeira — Licença MIT.
if nargin < 2, custos = false; end
G = C;  if custos, G = -C; end          % trabalhar sempre com "mais é melhor"
pares = zeros(0, 2);
n = size(G, 1);
for i = 1:n
  for k = 1:n
    if i ~= k && all(G(i,:) <= G(k,:)) && any(G(i,:) < G(k,:))
      pares(end+1, :) = [i k]; %#ok<AGROW>
    end
  end
end
end
