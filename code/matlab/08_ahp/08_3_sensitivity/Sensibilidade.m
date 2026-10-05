function T = Sensibilidade(M, w, k, grelha)
%SENSIBILIDADE  Pontuações das alternativas quando o peso do critério k percorre uma grelha.
%
%   T = Sensibilidade(M, w, k)           grelha linspace(0, 1, 21)
%   T = Sensibilidade(M, w, k, grelha)
%   T tem uma linha por valor da grelha e uma coluna por alternativa (para o gráfico).
%
%   Complementos de IO — deck 8.3.  J. F. A. Madeira — Licença MIT.
if nargin < 4, grelha = linspace(0, 1, 21); end
T = zeros(numel(grelha), size(M, 1));
for g = 1:numel(grelha)
  T(g, :) = Agrega(M, PesosCom(w, k, grelha(g)))';
end
end
