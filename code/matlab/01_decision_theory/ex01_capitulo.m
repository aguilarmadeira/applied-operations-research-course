% EX01_CAPITULO  Corre os quatro exemplos do capítulo 1 (Teoria da decisão).
%
%   É o ficheiro que o link «Open in MATLAB Online» abre. Carregue em Run:
%   cada exemplo imprime os resultados e termina com «confere com os slides: sim».
%
%   Complementos de IO — capítulo 1.  J. F. A. Madeira — Licença MIT.

aqui = fileparts(mfilename('fullpath'));
exemplos = {'01_1_decision_problem/ex01_1_decision_problem.m', ...
            '01_2_nonprobabilistic_criteria/ex01_2_nonprobabilistic_criteria.m', ...
            '01_3_probabilistic_criteria/ex01_3_probabilistic_criteria.m', ...
            '01_4_subjective_probabilities/ex01_4_subjective_probabilities.m'};
for e = 1:numel(exemplos)
  fprintf('\n%s\n', repmat('=', 1, 72));
  run(fullfile(aqui, exemplos{e}));
end
