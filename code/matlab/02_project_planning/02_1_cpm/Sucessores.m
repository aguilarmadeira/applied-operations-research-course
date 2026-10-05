function succ = Sucessores(acts)
%SUCESSORES  Para cada atividade, as atividades que a têm como precedente.
%
%   succ = Sucessores(acts)
%   succ{i}: índices (linhas de acts) dos sucessores da atividade i.
%
%   Complementos de IO — deck 2.1.  J. F. A. Madeira — Licença MIT.
n = size(acts, 1);
succ = cell(1, n);
for i = 1:n
  succ{i} = zeros(1, 0);
  for j = 1:n
    if any(strcmp(acts{i, 1}, acts{j, 2}))
      succ{i}(end+1) = j; %#ok<AGROW>
    end
  end
end
end
