function p = Direto(v)
%DIRETO  Prioridades locais de um atributo em que mais é melhor: v_i / soma(v).
%
%   p = Direto(v)     autonomia, carga, rendimento, ...; p é uma coluna.
%
%   Complementos de IO — deck 8.2.  J. F. A. Madeira — Licença MIT.
v = double(v(:));
p = v / sum(v);
end
