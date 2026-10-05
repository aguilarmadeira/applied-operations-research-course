function S = Agrega(M, w)
%AGREGA  Soma ponderada S_i = sum_k w_k p_ik (pontuação final de cada alternativa).
%
%   S = Agrega(M, w)
%   M: matriz alternativas x critérios (prioridades locais); w: pesos dos critérios.
%   S é uma coluna.
%
%   Complementos de IO — deck 8.2.  J. F. A. Madeira — Licença MIT.
S = M * w(:);
end
