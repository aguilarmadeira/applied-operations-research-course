% EX06_CAPITULO  Corre os três exemplos do capítulo 6 (Filas de espera).
%
%   É o ficheiro que o link «Open in MATLAB Online» abre. Carregue em Run:
%   cada exemplo imprime os resultados e termina com «confere com os slides: sim».
%   As simulações (6.1 e 6.2) usam 200000 clientes cada e demoram alguns segundos.
%
%   Complementos de IO — capítulo 6.  J. F. A. Madeira — Licença MIT.

aqui = fileparts(mfilename('fullpath'));
exemplos = {'06_1_mm1/ex06_1_mm1.m', ...
            '06_2_mmk_mms/ex06_2_mmk_mms.m', ...
            '06_3_mmr/ex06_3_mmr.m'};
for e = 1:numel(exemplos)
  fprintf('\n%s\n', repmat('=', 1, 72));
  run(fullfile(aqui, exemplos{e}));
end
