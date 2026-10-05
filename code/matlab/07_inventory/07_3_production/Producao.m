function r = Producao(D, P, Ce, Cp, Ca, Tprep)
%PRODUCAO  Modelo de produção e consumo simultâneos.
%
%   r = Producao(D, P, Ce, Cp)       r = Producao(D, P, Ce, Cp, Ca, Tprep)
%   D: procura por período; P: capacidade de produção por período (P > D); Ce: custo de preparação
%   de um lote; Cp: custo de posse por unidade e período; Ca: custo de produção unitário (por omissão 0);
%   Tprep: tempo de preparação do lote (no mesmo período).
%   r.Q = sqrt(2 D Ce / Cp) sqrt(P/(P - D)), r.Smax = Q (1 - D/P), r.T = Q/D, r.Tp = Q/P, r.n = D/Q,
%   r.Kenc (preparação), r.Kpos, r.K e r.Pl = D Tprep (ponto de lançamento; vazio se não se der Tprep).
%
%   Complementos de IO — deck 7.3.  J. F. A. Madeira — Licença MIT.
if nargin < 5, Ca = 0; end
Q = sqrt(2 * D * Ce / Cp) * sqrt(P / (P - D));
Smax = Q * (P - D) / P;
if nargin < 6 || isempty(Tprep), Pl = []; else, Pl = D * Tprep; end
r = struct('Q', Q, 'Smax', Smax, 'T', Q / D, 'Tp', Q / P, 'n', D / Q, 'Kenc', D * Ce / Q, ...
           'Kpos', Cp * Smax / 2, 'K', D * Ca + D * Ce / Q + Cp * Smax / 2, 'Pl', Pl);
end
