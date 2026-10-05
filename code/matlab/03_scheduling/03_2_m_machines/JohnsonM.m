function s = JohnsonM(P)
%JOHNSONM  Regra de Johnson com m máquinas.
%
%   s = JohnsonM(P)
%   Com 2 máquinas, Johnson diretamente; com m >= 3, Johnson nas máquinas fictícias (G, H) de Reduz.
%   Não verifica a condição (use Condicao primeiro): sem ela, é só uma heurística.
%
%   Complementos de IO — deck 3.2.  J. F. A. Madeira — Licença MIT.
if size(P, 2) == 2
  s = Johnson(P(:, 1), P(:, 2));
else
  [G, H] = Reduz(P);
  s = Johnson(G, H);
end
end
