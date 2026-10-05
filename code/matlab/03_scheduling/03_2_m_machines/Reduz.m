function [G, H] = Reduz(P)
%REDUZ  m máquinas -> 2 máquinas fictícias.
%
%   [G, H] = Reduz(P)
%   P: matriz n x m de tempos (linha = trabalho).  G = M1 + ... + M(m-1), H = M2 + ... + Mm
%   (vetores linha, um valor por trabalho).
%
%   Complementos de IO — deck 3.2.  J. F. A. Madeira — Licença MIT.
G = sum(P(:, 1:end-1), 2)';
H = sum(P(:, 2:end), 2)';
end
