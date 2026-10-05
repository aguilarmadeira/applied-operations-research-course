function [valor, x, F] = Mochila01(w, v, W)
%MOCHILA01  Mochila 0-1 por programação dinâmica (etapa = objeto, estado = capacidade livre).
%
%   [valor, x, F] = Mochila01(w, v, W)
%   f_i(k) = max{ f_{i+1}(k) (não),  v_i + f_{i+1}(k - w_i) (sim, se w_i <= k) },  f_{n+1}(k) = 0.
%   Resolve do último objeto para o primeiro e lê a solução para a frente a partir de f_1(W).
%   valor: valor ótimo; x: x(i) = 1 se o objeto i vai na mochila;
%   F: tabela (n+1) x (W+1), com F(i, k+1) = f_i(k).
%
%   Complementos de IO — deck 5.2.  J. F. A. Madeira — Licença MIT.
n = numel(w);
F = zeros(n + 1, W + 1);
for i = n:-1:1                            % último objeto -> primeiro
  for k = 0:W
    F(i, k+1) = F(i+1, k+1);                              % não
    if w(i) <= k                                          % sim
      F(i, k+1) = max(F(i, k+1), v(i) + F(i+1, k - w(i) + 1));
    end
  end
end
x = zeros(1, n);  k = W;
for i = 1:n
  x(i) = F(i, k+1) ~= F(i+1, k+1);
  k = k - w(i)*x(i);
end
valor = F(1, W+1);
end
