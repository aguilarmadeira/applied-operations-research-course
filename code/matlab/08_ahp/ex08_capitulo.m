% EX08_CAPITULO  Corre os três exemplos do capítulo 8 (Decisão multicritério: o AHP).
%
%   É o ficheiro que o link «Open in MATLAB Online» abre. Carregue em Run:
%   cada exemplo imprime os resultados e termina com «confere com os slides: sim».
%   As simulações de 8.3 demoram alguns segundos (cerca de 30 s no GNU Octave).
%
%   Complementos de IO — capítulo 8.  J. F. A. Madeira — Licença MIT.

aqui = fileparts(mfilename('fullpath'));
exemplos = {'08_1_ahp/ex08_1_ahp.m', ...
            '08_2_attributes/ex08_2_attributes.m', ...
            '08_3_sensitivity/ex08_3_sensitivity.m'};
for e = 1:numel(exemplos)
  fprintf('\n%s\n', repmat('=', 1, 72));
  run(fullfile(aqui, exemplos{e}));
end
