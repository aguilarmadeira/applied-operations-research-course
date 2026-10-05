function lb = LbFs(seq, P)
%LBFS  Limite inferior do tempo total (flow shop) de qualquer sequência que comece por seq.
%
%   lb = LbFs(seq, P)
%   lb = max_i ( C_i + soma em U dos tempos na máquina i + min em U do que falta depois de i ),
%   com C_i a conclusão da sequência parcial seq na máquina i e U os trabalhos por sequenciar
%   (limite de Ignall e Schrage).  P: matriz n x m de tempos (linha = trabalho).
%
%   Complementos de IO — deck 3.4.  J. F. A. Madeira — Licença MIT.
[n, m] = size(P);
U = 1:n;
U(ismember(U, seq)) = [];
if isempty(seq)
  c = zeros(1, m);
else
  C = Tempos(seq, P);
  c = C(end, :);
end
if isempty(U)
  lb = c(end);
  return
end
v = zeros(1, m);
for i = 1:m
  v(i) = c(i) + sum(P(U, i)) + min(sum(P(U, i+1:end), 2));
end
lb = max(v);
end
