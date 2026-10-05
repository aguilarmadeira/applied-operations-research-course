function [f, esc] = MochilaIlimitada(w, v, W)
%MOCHILAILIMITADA  Mochila ilimitada por programação dinâmica.
%
%   [f, esc] = MochilaIlimitada(w, v, W)
%   f(k) = max_i { v_i + f(k - w_i) : w_i <= k },  f(k) = 0 se nada cabe;
%   calcula f(0), f(1), ..., f(W) por esta ordem.
%   f: vetor 1 x (W+1), com f(k+1) = valor máximo com capacidade k.
%   esc: cell 1 x (W+1); esc{k+1} = objetos que dão o máximo (vários se houver
%   empate; vazio se nada cabe).
%
%   Complementos de IO — deck 5.2.  J. F. A. Madeira — Licença MIT.
f = zeros(1, W + 1);
esc = cell(1, W + 1);
for k = 1:W
  melhor = 0;  arg = [];
  for i = 1:numel(w)
    if w(i) <= k
      val = v(i) + f(k - w(i) + 1);
      if val > melhor
        melhor = val;  arg = i;
      elseif val == melhor && melhor > 0
        arg(end+1) = i; %#ok<AGROW>
      end
    end
  end
  f(k + 1) = melhor;
  esc{k + 1} = arg;
end
end
