% EX01_1_DECISION_PROBLEM  Reproduz os exemplos do deck 1.1 (o problema de decisão).
%
%   Slide «Boa decisão ≠ boa consequência»: moeda, +30 € / -10 €  =>  10 € por jogada.
%   Slide «Quantas tendas alugar?»: L(t, d) = 500 min(t, d) - 300 t, t, d em {2, 3, 4}.
%   Para discutir na aula: Exemplo 2 (dado)  =>  15 € por lançamento;
%   Exemplo 3 (investimento): os títulos do tesouro são dominados pelas obrigações.
%
%   No fim compara com os slides.
%
%   Complementos de IO — deck 1.1.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 1.1: o problema de decisão\n');

% ------------------------------------------------------------ a moeda
ve_moeda = 0.5*30 + 0.5*(-10);
fprintf('\nMoeda: 1/2 x 30 + 1/2 x (-10) = %g € por jogada\n', ve_moeda);

% ------------------------------------------------------------ as tendas
t = [2 3 4];  d = [2 3 4];
L = MatrizDecisao(@(t, d) 500*min(t, d) - 300*t, t, d);
fprintf('\nTendas: L(t, d) = 500 min(t, d) - 300 t\n');
fprintf('  alugar t \\ precisas d:      2      3      4\n');
for i = 1:3
  fprintf('  %d                       %s\n', t(i), strjoin(arrayfun(@(v) sprintf('%5.0f', v), L(i,:), 'UniformOutput', false), '  '));
end
if isempty(Dominadas(L)), fprintf('  ações dominadas: nenhuma\n'); end

% ------------------------------------------------------------ Exemplo 2: o dado
ve_dado = 5/6*20 - 1/6*10;
fprintf('\nExemplo 2 (dado): 5/6 x 20 - 1/6 x 10 = %g € por lançamento\n', ve_dado);

% ------------------------------------------------------------ Exemplo 3: investimento
nomes = {'comprar ações', 'comprar obrigações', 'comprar títulos do tesouro'};
C = [1000 0 -1500; 350 200 300; 220 100 0];
dom = Dominadas(C);
fprintf('\nExemplo 3 (investimento; subida, estável, descida):\n');
for p = 1:size(dom, 1)
  fprintf('  %s é dominada por %s\n', nomes{dom(p,1)}, nomes{dom(p,2)});
end

c = [ve_moeda == 10, isequal(L, [400 400 400; 100 600 600; -200 300 800]), ...
     isempty(Dominadas(L)), abs(ve_dado - 15) < 1e-12, isequal(dom, [3 2])];
simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{all(c) + 1});
