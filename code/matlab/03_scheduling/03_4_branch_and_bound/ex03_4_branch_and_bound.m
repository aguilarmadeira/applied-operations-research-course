% EX03_4_BRANCH_AND_BOUND  Reproduz os exemplos do deck 3.4 (branch and bound).
%
%   Plastificação (3 máquinas, tempo total): nó «3 primeiro» com C = (2, 11, 18) e LB = max(22, 34, 34) = 34;
%   raiz 32; árvore com 10 nós e ótimo 3, 2, 4, 1 com T = 35. Resumo: chegada 39, Johnson 39, TDM 40, B&B 35.
%   Impressora digital (1 máquina, atraso total): EDD N, M, L, K com atraso 9; limites ...K 4, ...L 7,
%   ...LK 9, ...KL 7; árvore com 13 nós e ótimo N, M, K, L com atraso 7 (C = 3, 6, 8, 15; atrasos 0, 0, 0, 7).
%   Com 8 trabalhos: 8! = 40320 sequências e 109600 nós na árvore completa.
%   (A experiência com 100 problemas aleatórios está só em Python: ver o README.)
%   O TPC da Lista 3 não é resolvido aqui.
%
%   Complementos de IO — deck 3.4.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 3.4: branch and bound\n');
lista = @(v, sep) strjoin(arrayfun(@(x) sprintf('%d', x), v, 'UniformOutput', false), sep);
ok = true;

% ------------------------------------------------------------ parte 1: plastificação
Q = [2 4 3; 7 8 8; 2 9 7; 4 8 5];
nomes = {'1', '2', '3', '4'};
fprintf('\nParte 1 — plastificação (3 máquinas, tempo total)\n');
C3 = Tempos(3, Q);  c3 = C3(end, :);
U = [1 2 4];
lbs = zeros(1, 3);
for i = 1:3
  lbs(i) = c3(i) + sum(Q(U, i)) + min(sum(Q(U, i+1:end), 2));
end
fprintf('  nó «3 primeiro»: C = (%s), LB1, LB2, LB3 = %s -> LB = %d\n', lista(c3, ', '), lista(lbs, ', '), LbFs(3, Q));
fprintf('  raiz: LB = %d\n', LbFs([], Q));
[v, s, nos, lims] = BbFs(Q);
rot = cellfun(@(t) strjoin(nomes(t), ''), nos, 'UniformOutput', false);
fprintf('  nós gerados (%d): %s\n', numel(nos), strjoin(arrayfun(@(k) sprintf('%s: %d', rot{k}, lims(k)), ...
        1:numel(nos), 'UniformOutput', false), ', '));
vq = ForcaBruta(Q);
fprintf('  ótimo: %s com T = %d (força bruta: %d sequências, mínimo %d)\n', strjoin(nomes(s), ', '), v, numel(vq), vq(1));
ok = ok && isequal(c3, [2 11 18]) && isequal(lbs, [22 34 34]) && LbFs(3, Q) == 34 && LbFs([], Q) == 32;
ok = ok && v == 35 && isequal(s, [3 2 4 1]) && numel(nos) == 10;
ok = ok && isequal(rot, {'1', '2', '3', '4', '31', '32', '34', '321', '324', '3241'}) ...
     && isequal(lims, [36 39 34 36 36 35 35 36 35 35]);

fprintf('  resumo da semana da plastificação:\n');
resumo = {'ordem de chegada', 1:4; 'Johnson sobre (G, H)', JohnsonM(Q); 'TDM sobre (G, H)', Tdm(Q); 'branch and bound', s};
Tr = zeros(1, 4);
for k = 1:4
  Tr(k) = Cmax(resumo{k, 2}, Q);
  fprintf('    %-22s %s  T = %d\n', resumo{k, 1}, strjoin(nomes(resumo{k, 2}), ', '), Tr(k));
end
ok = ok && isequal(Tr, [39 39 40 35]) && isequal(JohnsonM(Q), [1 3 4 2]) && isequal(Tdm(Q), [2 3 4 1]);

% ------------------------------------------------------------ parte 2: impressora digital
p = [2 7 3 3];
d = [11 8 6 4];
nomes = {'K', 'L', 'M', 'N'};
fprintf('\nParte 2 — impressora digital (1 máquina, atraso total); soma dos tempos = %d\n', sum(p));
[~, edd] = sort(d);
fprintf('  EDD (prazo mais cedo primeiro): %s, atraso total = %d\n', strjoin(nomes(edd), ', '), Atraso(edd, p, d));
[v, s, nos, lims] = BbAtraso(p, d);
rot = cellfun(@(t) strjoin(nomes(t), ''), nos, 'UniformOutput', false);
fprintf('  nós gerados (%d): %s\n', numel(nos), strjoin(arrayfun(@(k) sprintf('...%s: %d', rot{k}, lims(k)), ...
        1:numel(nos), 'UniformOutput', false), ', '));
Cj = cumsum(p(s));
fprintf('  ótimo: %s com atraso %d;  C = (%s), atrasos %s\n', strjoin(nomes(s), ', '), v, lista(Cj, ', '), ...
        lista(max(0, Cj - d(s)), ', '));
[va, sa] = ForcaBruta(p(:), @(q) Atraso(q, p, d));
fprintf('  força bruta: %d sequências, mínimo %d\n', numel(va), va(1));
lim = @(r) lims(strcmp(rot, r));
ok = ok && isequal(edd, [4 3 2 1]) && Atraso(edd, p, d) == 9 && v == 7 && isequal(s, [4 3 1 2]) && numel(nos) == 13;
ok = ok && isequal(rot(1:4), {'K', 'L', 'M', 'N'}) && isequal(lims(1:4), [4 7 9 11]);
ok = ok && lim('LK') == 9 && lim('KL') == 7 && lim('MKL') == 7 && lim('NKL') == 9;
ok = ok && isequal(Cj, [3 6 8 15]) && va(1) == 7 && isequal(sa(1, :), [4 3 1 2]);

% ------------------------------------------------------------ tamanho da árvore completa
n = 8;
fprintf('\nCom %d trabalhos: %d sequências; a árvore completa tem %d nós\n', ...
        n, factorial(n), sum(factorial(n) ./ factorial(n - (1:n))));
ok = ok && factorial(8) == 40320 && sum(factorial(8) ./ factorial(8 - (1:8))) == 109600;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
