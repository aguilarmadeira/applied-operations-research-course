function certo = VerificaEscolhas(C, alpha, respostas, nomes, custos)
%VERIFICAESCOLHAS  Confere as escolhas de um aluno sem mostrar a resolução.
%
%   certo = VerificaEscolhas(C, alpha, respostas, nomes, custos)
%   respostas: estrutura critério -> nome da ação escolhida, p. ex.
%              struct('maximax', 'ações', 'savage', 'obrigações')
%   nomes: cell com os nomes das ações.  Imprime «certo» ou «errado».
%
%   Complementos de IO — deck 1.2.  J. F. A. Madeira — Licença MIT.
if nargin < 5, custos = false; end
res = Criterios(C, alpha, custos);
crit = fieldnames(respostas);
certo = struct();
for k = 1:numel(crit)
  escolha = respostas.(crit{k});
  certas = nomes(res.(crit{k}).escolha);
  certo.(crit{k}) = any(strcmp(escolha, certas));
  if certo.(crit{k}), txt = 'certo'; else, txt = 'errado'; end
  fprintf('  %-8s %-28s %s\n', crit{k}, escolha, txt);
end
end
