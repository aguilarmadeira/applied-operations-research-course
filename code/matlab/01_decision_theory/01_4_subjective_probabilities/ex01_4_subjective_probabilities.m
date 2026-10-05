% EX01_4_SUBJECTIVE_PROBABILITIES  Reproduz os exemplos do deck 1.4 (probabilidades subjetivas).
%
%   Linha de produção: «alta tão provável como média» e «média 3 vezes mais provável do que baixa»
%   => P = (1/7, 3/7, 3/7); VE = 325/7, 440/7, 470/7 -> a3 grande.
%   Resposta a mais «alta 2 vezes mais provável do que baixa»: as respostas implicam 3 -> incoerente.
%   Para resolver na aula: vantagens 3 para 1 e 2 para 1 => P = (6/9, 2/9, 1/9);
%   no investimento, VE = 500, 311.1, 168.9 -> ações; com «1 para 3» e «1 para 2»,
%   P = (1/10, 3/10, 6/10) e VE = -800, 275, 52 -> obrigações.
%
%   Complementos de IO — deck 1.4.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 1.4: probabilidades subjetivas\n');
% probabilidades como frações com denominador comum (como nos slides: 6/9, 2/9, 1/9)
den = @(P) find(arrayfun(@(d) all(abs(P*d - round(P*d)) < 1e-9), 1:100), 1);
frac = @(P) strjoin(arrayfun(@(x) sprintf('%d/%d', round(x*den(P)), den(P)), P, 'UniformOutput', false), ', ');
fmt1 = @(v) strjoin(arrayfun(@(x) sprintf('%.1f', x), v, 'UniformOutput', false), '  ');
ok = true;

% ------------------------------------------------------------ linha de produção (baixa, média, alta)
C = [40 45 50; 20 60 80; -40 50 120];
nomes = {'a1 pequena', 'a2 média', 'a3 grande'};
P = ProbRazoes(3, [3 2 1; 2 1 3]);
r = Risco(C, P);
fprintf('\nLinha de produção: P(alta)/P(média) = 1, P(média)/P(baixa) = 3\n');
fprintf('  P = (%s)\n', frac(P));
fprintf('  VE = %s -> %s\n', fmt1(r.VE), nomes{r.escolha_VE});
[~, ver] = ProbRazoes(3, [3 2 1; 2 1 3; 3 1 2]);
if ver(1,5), txt = 'coerente'; else, txt = 'incoerente'; end
fprintf('  resposta a mais P(alta)/P(baixa) = %g; as outras implicam %g -> %s\n', ver(1,3), ver(1,4), txt);
ok = ok && max(abs(P - [1 3 3]/7)) < 1e-9 && max(abs(r.VE*7 - [325 440 470])) < 1e-9 ...
     && isequal(r.escolha_VE, 3) && ~ver(1,5) && abs(ver(1,4) - 3) < 1e-9;

% ------------------------------------------------------------ para resolver na aula
CI = [1000 0 -1500; 350 200 300; 220 100 0];
NI = {'ações', 'obrigações', 'títulos'};
P1 = ProbRazoes(3, [1 2 3; 2 3 2]);  r1 = Risco(CI, P1);
fprintf('\nExemplo: P1/P2 = 3, P2/P3 = 2  =>  P = (%s)\n', frac(P1));
fprintf('  investimento: VE = %s -> %s\n', fmt1(r1.VE), NI{r1.escolha_VE});
P2 = ProbRazoes(3, [1 2 1/3; 2 3 1/2]);  r2 = Risco(CI, P2);
fprintf('Com «1 para 3» e «1 para 2»: P = (%s)\n', frac(P2));
fprintf('  investimento: VE = %s -> %s\n', fmt1(r2.VE), NI{r2.escolha_VE});
ok = ok && max(abs(P1 - [6 2 1]/9)) < 1e-9 && max(abs(r1.VE - [500 2800/9 1520/9])) < 1e-9 && isequal(r1.escolha_VE, 1);
ok = ok && max(abs(P2 - [0.1 0.3 0.6])) < 1e-9 && max(abs(r2.VE - [-800 275 52])) < 1e-9 && isequal(r2.escolha_VE, 2);

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
