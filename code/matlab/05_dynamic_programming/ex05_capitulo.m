% EX05_CAPITULO  Corre os três exemplos do capítulo 5 (Programação dinâmica).
%
%   É o ficheiro que o link «Open in MATLAB Online» abre. Carregue em Run:
%   cada exemplo imprime os resultados e termina com «confere com os slides: sim».
%
%   Complementos de IO — capítulo 5.  J. F. A. Madeira — Licença MIT.

aqui = fileparts(mfilename('fullpath'));
exemplos = {'05_1_bellman_shortest_path/ex05_1_bellman_shortest_path.m', ...
            '05_2_knapsack/ex05_2_knapsack.m', ...
            '05_3_workforce/ex05_3_workforce.m'};
for e = 1:numel(exemplos)
  fprintf('\n%s\n', repmat('=', 1, 72));
  run(fullfile(aqui, exemplos{e}));
end
