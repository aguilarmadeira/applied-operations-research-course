function A = MatrizReciproca(n, juizos)
%MATRIZRECIPROCA  Matriz de comparações par a par (recíproca) a partir dos juízos.
%
%   A = MatrizReciproca(n, juizos)
%   juizos: uma linha [i j a_ij] por juízo, com i < j (índices a partir de 1).
%   a_ii = 1 e a_ji = 1/a_ij; os pares não indicados ficam com 1.
%
%   Complementos de IO — deck 8.1.  J. F. A. Madeira — Licença MIT.
A = ones(n);
for l = 1:size(juizos, 1)
  i = juizos(l, 1);  j = juizos(l, 2);
  A(i, j) = juizos(l, 3);
  A(j, i) = 1 / juizos(l, 3);
end
end
