function [total, caminho] = Guloso(C, ini, fim)
%GULOSO  Regra gulosa (míope): em cada nó segue o arco mais barato.
%
%   [total, caminho] = Guloso(C, ini, fim)
%   C: matriz dos custos dos arcos (Inf se não há arco). Em caso de empate segue
%   o primeiro sucessor. total: custo do percurso; caminho: vetor-linha de nós.
%
%   Complementos de IO — deck 5.1.  J. F. A. Madeira — Licença MIT.
no = ini;  total = 0;  caminho = ini;
while no ~= fim
  [c, j] = min(C(no,:));
  total = total + c;
  no = j;
  caminho(end+1) = j; %#ok<AGROW>
end
end
