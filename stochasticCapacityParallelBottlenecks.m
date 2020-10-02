%% Presentation
% This script launches a bottleneck simulation with a continuum of users and stochastic capacity.
% Last modified by Raphael Lamotte, on October 24, 2018.

clear all
close all
path(genpath(cd),path);
path(genpath('C:\Users\rlamotte\Documents\PhD\Matlab\simulations\github'),path);

Tf=0:0.01:0.1;
Capacity=0.1*ones(length(Tf),1);
% Tf=zeros(size(Capacity));
% Capacity=1;

% Define the population of users
% population=generateSPabg();%
tstar=0;
population=generateSParctan(tstar,0.9*ones(size(tstar)),1.1*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));%

% Define some technical settings
settings.maxIter=2000;
settings.display='on'; %'on' 'off' 'final'
settings.additionalPlots='off';
settings.knownEq=0; % should only set to a positive value if Iryo's method apply (morning commute with identical alpha).


% Define some mode-specific parameters
departureTimes=-1.5:1/60:1.5;
revisionProtocol.exponent=1;
revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);
revisionProtocol.rate=1/length(departureTimes);
    
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

ini=rand(population.N,length(departureTimes)*length(Capacity));
ini=ini/sum(sum(ini));

congestion=generateParallelBottlenecks(Capacity,Tf);
[fS,hist]=runIterationsContinuumStochasticParallel(departureTimes,settings,congestion,population,revisionProtocol,ini);


