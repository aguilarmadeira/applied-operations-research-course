% EX07_CAPITULO  Corre os três exemplos do capítulo 7 (Gestão de stocks).
%
%   É o ficheiro que o link «Open in MATLAB Online» abre. Carregue em Run:
%   cada exemplo imprime os resultados e termina com «confere com os slides: sim».
%
%   Complementos de IO — capítulo 7.  J. F. A. Madeira — Licença MIT.

aqui = fileparts(mfilename('fullpath'));
exemplos = {'07_1_abc_eoq/ex07_1_abc_eoq.m', ...
            '07_2_shortages_discounts/ex07_2_shortages_discounts.m', ...
            '07_3_production/ex07_3_production.m'};
for e = 1:numel(exemplos)
  fprintf('\n%s\n', repmat('=', 1, 72));
  run(fullfile(aqui, exemplos{e}));
end
