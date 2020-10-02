%% Presentation
% This script launches a bottleneck simulation with a continuum of users and stochastic capacity.
% Last modified by Raphael Lamotte, on October 24, 2018.

clear all
close all
path(genpath(cd),path);
path(genpath('C:\Users\rlamotte\Documents\PhD\Matlab\simulations\github'),path);

Capacity=[0.5:0.1:0.7,0.75:0.05:0.9,0.91:0.01:1.1,1.15:1.25,1.3:0.1:1.5];
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
ini=ones(population.N,length(departureTimes))/population.N/length(departureTimes); % initial distribution of departures
revisionProtocol.exponent=1;
revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);
revisionProtocol.rate=1/length(departureTimes);
    
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

congestion=generateBottleneck(Capacity);
[fS,hist]=runIterationsContinuumStochastic(departureTimes,settings,congestion,population,revisionProtocol,ini);

