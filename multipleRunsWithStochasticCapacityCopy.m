%% Presentation
% This script launches a bottleneck simulation with a continuum of users and stochastic capacity.
% Last modified by Raphael Lamotte, on October 24, 2018.

clear all
close all
path(genpath(cd),path);
path(genpath('C:\Users\rlamotte\Documents\PhD\Matlab\simulations\github'),path);

% Define the population of users
% population=generateSPabg();%
tstar=0;
population=generateSParctan(tstar,0.5*ones(size(tstar)),1.5*ones(size(tstar)),ones(size(tstar)),1*ones(size(tstar)));%

% Define some technical settings
lambda=10^(-2);
settings.maxIter=500/lambda;
settings.display='off'; %'on' 'off' 'final'
settings.additionalPlots='off';
settings.knownEq=0; % should only set to a positive value if Iryo's method apply (morning commute with identical alpha).

% Define some mode-specific parameters
departureTimes=-2:1/60:2;
ini=ones(population.N,length(departureTimes))/population.N/length(departureTimes); % initial distribution of departures
revisionProtocol.exponent=1;
revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);
revisionProtocol.rate=lambda/length(departureTimes);
    
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

% define multiple capacities.
% Run individual simulation with each of them
% Run one with stochastic, and plot all potential gains.

Capacity=0.5*(0.6:0.05:1.5);

congestion=generateBottleneck(Capacity);
[~,hist]=runIterationsContinuumStochastic(departureTimes,settings,congestion,population,revisionProtocol,ini);
figure(1)
plot(1:settings.maxIter,hist.potGain,'r');
hold on

for i=1:length(Capacity)
    congestion=generateBottleneck(Capacity(i));
    [~,hist]=runIterationsContinuumStochastic(departureTimes,settings,congestion,population,revisionProtocol,ini);
    figure(1)
    plot(1:settings.maxIter,hist.potGain,'k');
    hold on
end