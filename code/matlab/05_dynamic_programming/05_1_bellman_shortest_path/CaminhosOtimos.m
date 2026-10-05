function cs = CaminhosOtimos(dec, ini, fim)
%CAMINHOSOTIMOS  Todos os percursos ótimos de ini a fim, lidos para a frente.
%
%   cs = CaminhosOtimos(dec, ini, fim)
%   dec: a cell devolvida por CaminhoEtapas.
%   cs: cell com um vetor-linha de nós por percurso ótimo.
%
%   Complementos de IO — deck 5.1.  J. F. A. Madeira — Licença MIT.
if ini == fim
  cs = {fim};
  return
end
cs = {};
for j = dec{ini}
  resto = CaminhosOtimos(dec, j, fim);
  for r = 1:numel(resto)
    cs{end+1} = [ini resto{r}]; %#ok<AGROW>
  end
end
end
