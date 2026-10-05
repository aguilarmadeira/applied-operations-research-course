function C = MatrizDecisao(f, acoes, estados)
%MATRIZDECISAO  Matriz de decisão C(i,j) = f(acoes(i), estados(j)).
%
%   C = MatrizDecisao(f, acoes, estados)
%   Linhas = ações, colunas = estados da natureza.
%
%   Complementos de IO — deck 1.1.  J. F. A. Madeira — Licença MIT.
C = zeros(numel(acoes), numel(estados));
for i = 1:numel(acoes)
  for j = 1:numel(estados)
    C(i, j) = f(acoes(i), estados(j));
  end
end
end
