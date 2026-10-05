function cam = Caminhos(acts)
%CAMINHOS  Todos os caminhos de uma atividade inicial até uma final (só para redes pequenas).
%
%   cam = Caminhos(acts)
%   cam{k}: índices (linhas de acts) das atividades do k-ésimo caminho.
%   A ordem é a da procura em profundidade: inícios e sucessores pela ordem das linhas.
%
%   Complementos de IO — deck 2.1.  J. F. A. Madeira — Licença MIT.
succ = Sucessores(acts);
inicios = find(cellfun(@isempty, acts(:, 2)))';
pilha = num2cell(fliplr(inicios));         % caminhos parciais por explorar
cam = {};
while ~isempty(pilha)
  p = pilha{end};  pilha(end) = [];
  s = succ{p(end)};
  if isempty(s)
    cam{end+1} = p; %#ok<AGROW>
  else
    for b = fliplr(s)
      pilha{end+1} = [p b]; %#ok<AGROW>
    end
  end
end
end
