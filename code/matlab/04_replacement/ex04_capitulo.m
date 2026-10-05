% EX04_CAPITULO  Corre os três exemplos do capítulo 4 (Teoria da substituição).
%
%   É o ficheiro que o link «Open in MATLAB Online» abre. Carregue em Run:
%   cada exemplo imprime os resultados e termina com «confere com os slides: sim».
%
%   Complementos de IO — capítulo 4.  J. F. A. Madeira — Licença MIT.

aqui = fileparts(mfilename('fullpath'));
exemplos = {'04_1_wear/ex04_1_wear.m', ...
            '04_2_discounting/ex04_2_discounting.m', ...
            '04_3_group_replacement/ex04_3_group_replacement.m'};
for e = 1:numel(exemplos)
  fprintf('\n%s\n', repmat('=', 1, 72));
  run(fullfile(aqui, exemplos{e}));
end
