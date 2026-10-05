function B = Perturba(A, degraus)
%PERTURBA  Desloca cada juízo, ao acaso, até degraus posições na escala de Saaty.
%
%   B = Perturba(A)            um degrau
%   B = Perturba(A, degraus)
%   Escala: 1/9, 1/8, ..., 1/2, 1, 2, ..., 9. Cada juízo acima da diagonal passa ao valor da escala
%   mais próximo, desloca-se randi([-degraus degraus]) posições (sem sair da escala) e B é a nova
%   matriz recíproca. Usa o gerador de números aleatórios do MATLAB/Octave (fixar com rng).
%
%   Complementos de IO — deck 8.3.  J. F. A. Madeira — Licença MIT.
if nargin < 2, degraus = 1; end
ESCALA = [1/9 1/8 1/7 1/6 1/5 1/4 1/3 1/2 1 2 3 4 5 6 7 8 9];
n = size(A, 1);
[I, J] = find(triu(true(n), 1));                      % pares i < j
a = A(sub2ind([n n], I, J));
[~, k] = min(abs(a - ESCALA), [], 2);                  % posição na escala de cada juízo
k = min(max(k + randi([-degraus degraus], numel(a), 1), 1), 17);
B = MatrizReciproca(n, [I J ESCALA(k)']);
end
