function r = Rutura(D, Ce, Cp, Cr, Ca, TR)
%RUTURA  Modelo com rutura planeada (encomendas em atraso, satisfeitas à chegada).
%
%   r = Rutura(D, Ce, Cp, Cr)        r = Rutura(D, Ce, Cp, Cr, Ca, TR)
%   Cr: custo de rutura por unidade em atraso e período; Ca: preço (por omissão 0); TR: prazo de entrega.
%   r.rho = Cr/(Cp + Cr) (fração ótima do ciclo com stock positivo; «nível de serviço» nas aulas),
%   r.Q = sqrt(2 D Ce / Cp)/sqrt(rho), r.S = rho Q, r.R = Q - S (rutura máxima),
%   r.T, r.T1 = S/D, r.T2 = (Q - S)/D, r.n = D/Q, r.Kenc, r.Kpos, r.Krut, r.Kaq, r.K e
%   r.Pe = D TR - (Q - S) (pode ser < 0; vazio se não se der TR).
%
%   Complementos de IO — deck 7.2.  J. F. A. Madeira — Licença MIT.
if nargin < 5, Ca = 0; end
rho = Cr / (Cp + Cr);
Q = sqrt(2 * D * Ce / (Cp * rho));
S = Q * rho;
if nargin < 6 || isempty(TR), Pe = []; else, Pe = D * TR - (Q - S); end
r = struct('rho', rho, 'Q', Q, 'S', S, 'R', Q - S, 'T', Q / D, 'T1', S / D, 'T2', (Q - S) / D, ...
           'n', D / Q, 'Kenc', D * Ce / Q, 'Kpos', Cp * S * S / (2 * Q), 'Krut', Cr * (Q - S)^2 / (2 * Q), ...
           'Kaq', D * Ca, 'K', D * Ca + D * Ce / Q + Cp * S * S / (2 * Q) + Cr * (Q - S)^2 / (2 * Q), 'Pe', Pe);
end
