% EX03_CAPITULO  Corre os quatro exemplos do capítulo 3 (Problemas sequenciais).
%
%   É o ficheiro que o link «Open in MATLAB Online» abre. Carregue em Run:
%   cada exemplo imprime os resultados e termina com «confere com os slides: sim».
%
%   Complementos de IO — capítulo 3.  J. F. A. Madeira — Licença MIT.

aqui = fileparts(mfilename('fullpath'));
exemplos = {'03_1_johnson/ex03_1_johnson.m', ...
            '03_2_m_machines/ex03_2_m_machines.m', ...
            '03_3_tdm/ex03_3_tdm.m', ...
            '03_4_branch_and_bound/ex03_4_branch_and_bound.m'};
for e = 1:numel(exemplos)
  fprintf('\n%s\n', repmat('=', 1, 72));
  run(fullfile(aqui, exemplos{e}));
end
