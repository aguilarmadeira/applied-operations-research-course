function s = Johnson(a, b)
%JOHNSON  Regra de Johnson (2 máquinas): sequência ótima.
%
%   s = Johnson(a, b)
%   a, b: vetores com os tempos dos trabalhos nas máquinas 1 e 2.
%   Primeiro os trabalhos com a_j <= b_j, por a crescente; depois os outros, por b decrescente.
%   Empates: fica primeiro o de menor índice (qualquer escolha é ótima).
%   s: vetor linha com os índices dos trabalhos.
%
%   Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.
a = a(:)';  b = b(:)';
L = find(a <= b);
R = find(a > b);
[~, o] = sort(a(L));   L = L(o);     % a crescente (sort é estável)
[~, o] = sort(-b(R));  R = R(o);     % b decrescente
s = [L R];
end
