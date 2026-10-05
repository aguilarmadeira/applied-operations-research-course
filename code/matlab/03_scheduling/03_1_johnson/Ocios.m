function o = Ocios(seq, P)
%OCIOS  Tempo ocioso de cada máquina até ao fim: T - soma dos tempos dessa máquina.
%
%   o = Ocios(seq, P)      o(i) = Cmax(seq, P) - soma dos tempos de seq na máquina i
%
%   Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.
o = Cmax(seq, P) - sum(P(seq, :), 1);
end
