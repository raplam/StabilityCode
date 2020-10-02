function congestion = generateMFDwoHypercongestion(C,L,vf)
% Generates a production MFD that increases linearly, and then remains
% constant. 
% With a quadratic speed MFD, C=ncr*vcr/L=ncr vf (1-ncr/(3ncr))^2 /L
% =ncr vf (2/3)^2 /L => ncr= 9/4 C L /vf
congestion.mechanism='MFD';%'bottleneck';
congestion.C=C;
congestion.vf=vf;
congestion.ncr=C*mean(L)/vf;
congestion.speed_fct=@(x)(x<=congestion.ncr).*vf+(x>congestion.ncr).*C.*mean(L)./x;
end

