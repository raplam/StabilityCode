% Addition for reviewer: compare the intra-day dynamics with those of the
% deterministic case.
clear all
close all
path(genpath(cd),path);

std=0.2;
w=1;
tstar=0;
Na=10^3;
population=generateSParctan(tstar,0.5,1.5,1,w);%
Capacity=0.5*(1-std:std:1+std);

for i=1:length(Capacity)
    congestion=generateBottleneck(Capacity(i));
    congestion=computeEquilibriumBottleneck(Na,congestion,population);
    figure(1)
    [t,ind]=sort(congestion.eqDepartures);
    plot(t,1/Na:1/Na:1,'-k');
    hold on
    plot(congestion.eqArrivals(ind),1/Na:1/Na:1,'--r');
 end



