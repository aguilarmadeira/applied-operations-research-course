% EX02_CAPITULO  Corre os três exemplos do capítulo 2 (Planeamento de projetos).
%
%   É o ficheiro que o link «Open in MATLAB Online» abre. Carregue em Run:
%   cada exemplo imprime os resultados e termina com «confere com os slides: sim».
%
%   Complementos de IO — capítulo 2.  J. F. A. Madeira — Licença MIT.

aqui = fileparts(mfilename('fullpath'));
exemplos = {'02_1_cpm/ex02_1_cpm.m', ...
            '02_2_pert/ex02_2_pert.m', ...
            '02_3_gantt_crashing/ex02_3_gantt_crashing.m'};
for e = 1:numel(exemplos)
  fprintf('\n%s\n', repmat('=', 1, 72));
  run(fullfile(aqui, exemplos{e}));
end
