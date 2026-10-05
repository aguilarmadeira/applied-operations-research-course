function [verifica, info] = Condicao(P)
%CONDICAO  Condição de Johnson para m >= 3 máquinas.
%
%   [verifica, info] = Condicao(P)
%   verifica = min M1 >= máx. das máquinas intermédias  ou  min Mm >= máx. das máquinas intermédias.
%   info = [min M1, min Mm, máx. das máquinas 2..m-1].  Com m <= 2: verifica = true, info = [].
%   P: matriz n x m de tempos (linha = trabalho, coluna = máquina).
%
%   Complementos de IO — deck 3.2.  J. F. A. Madeira — Licença MIT.
m = size(P, 2);
if m <= 2
  verifica = true;  info = [];
  return
end
meio = max(max(P(:, 2:end-1)));
m1 = min(P(:, 1));
mm = min(P(:, end));
verifica = m1 >= meio || mm >= meio;
info = [m1 mm meio];
end
