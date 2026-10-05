function D = Desvios(a, b, rest)
%DESVIOS  Tabela de desvios do TDM para os trabalhos ainda por atribuir.
%
%   D = Desvios(a, b, rest)
%   a, b: tempos nas máquinas 1 e 2; rest: índices dos trabalhos por atribuir.
%   D(k, :) = [ma - a_j, mx - a_j, mb - b_j, mx - b_j] para j = rest(k), com
%   ma, mb os maiores tempos de cada máquina em rest e mx = max(a_j, b_j):
%   (desvio na máquina, desvio no trabalho) na máquina 1 e depois na máquina 2.
%
%   Complementos de IO — deck 3.3.  J. F. A. Madeira — Licença MIT.
a = a(:);  b = b(:);  rest = rest(:);
ma = max(a(rest));  mb = max(b(rest));
mx = max(a(rest), b(rest));
D = [ma - a(rest), mx - a(rest), mb - b(rest), mx - b(rest)];
end
