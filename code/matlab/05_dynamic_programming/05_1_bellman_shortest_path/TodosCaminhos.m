function [cs, custos] = TodosCaminhos(C, ini, fim)
%TODOSCAMINHOS  Todos os percursos de ini a fim, com o respetivo custo (enumeração completa).
%
%   [cs, custos] = TodosCaminhos(C, ini, fim)
%   C: matriz dos custos dos arcos (Inf se não há arco).
%   cs: cell com um vetor-linha de nós por percurso; custos: vetor com o custo de cada um.
%
%   Complementos de IO — deck 5.1.  J. F. A. Madeira — Licença MIT.
if ini == fim
  cs = {fim};  custos = 0;
  return
end
cs = {};  custos = [];
for j = find(isfinite(C(ini,:)))
  [p, v] = TodosCaminhos(C, j, fim);
  for r = 1:numel(p)
    cs{end+1} = [ini p{r}]; %#ok<AGROW>
    custos(end+1) = C(ini, j) + v(r); %#ok<AGROW>
  end
end
end
