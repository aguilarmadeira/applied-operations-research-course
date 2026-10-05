function [seq, constr] = Tdm(P, nomes, log)
%TDM  Método do desvio de tempo (TDM) com m máquinas.
%
%   [seq, constr] = Tdm(P)
%   [seq, constr] = Tdm(P, nomes, log)
%   P: matriz n x m de tempos (linha = trabalho). Com 2 máquinas, Tdm2 diretamente;
%   com m >= 3, Tdm2 nas máquinas fictícias (G, H) de Reduz.  nomes e log como em Tdm2.
%
%   Complementos de IO — deck 3.3.  J. F. A. Madeira — Licença MIT.
if nargin < 2, nomes = {}; end
if nargin < 3, log = false; end
if size(P, 2) == 2
  a = P(:, 1);  b = P(:, 2);
else
  [a, b] = Reduz(P);
end
[seq, constr] = Tdm2(a, b, nomes, log);
end
