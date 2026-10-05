function p = Indireto(v)
%INDIRETO  Prioridades locais de um atributo em que menos é melhor: (1/v_i) / soma(1/v).
%
%   p = Indireto(v)   custos, tempos, distâncias, ...; p é uma coluna.
%
%   Complementos de IO — deck 8.2.  J. F. A. Madeira — Licença MIT.
v = 1 ./ double(v(:));
p = v / sum(v);
end
