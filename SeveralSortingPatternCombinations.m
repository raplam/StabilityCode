%% Presentation
% This script launches a simulation for a predefined number of days
% (iterations). The user can specify hereafter the configuration.


%% Note: this is a temporary version. The mechanism 'MFD' can only be used with the 'discrete' mode so far. The extension will come later.

clear all
close all
path(genpath(cd),path);

% Define congestion mechanism
Mechanism='MFD';
Capacity=0.5;

% Define mode (agent-based simulation ('discrete') or continuum-based
% ('continuum')
Mode='discrete';%'discrete'

% Define the population of users
% population=generateSPabg();%
tstar=repmat(8.05:0.1:9,1,300);
population=generateSParctan(tstar,0.5*ones(size(tstar)),2.5*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));%

% Define some technical settings
settings.maxIter=200;
settings.display='on'; %'on' 'off'

% Define some mechanism-specific parameters
switch Mechanism
    case 'MFD'
        population.L=1*rand(1,population.N);
        vf=1;
    case 'bottleneck'
        settings.knownEq=0; % should only set to a positive value if Iryo's method apply (morning commute with identical alpha).
end

% Define some mode-specific parameters
switch Mode
    case 'continuum'
        departureTimes=-1.5:1/60:1.5;
        ini=ones(population.N,length(departureTimes))/population.N/length(departureTimes); % initial distribution of departures
        revisionProtocol.exponent=1;
        revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);
        revisionProtocol.rate=1/length(departureTimes);
        outputs.groupHomogeneity='on';
    case 'discrete'
        updateProportion=0.02;
        ini=population.tstar; % initial departure times
end

%% DO NOT MODIFY AFTER THIS LINE
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

if strcmp(Mechanism,'MFD')&&strcmp(Mode,'continuum')
    error('the combination MFD+continuum is not supported yet');
end
switch Mechanism
    case 'MFD'
        congestion=generateQuadraticSpeedMFD(Capacity,population.L,vf);
%         congestion=generateMFDwoHypercongestion(Capacity,population.L,vf);
    case 'bottleneck'
        congestion=generateBottleneck(Capacity);
        if settings.knownEq>0
            Na=ceil(1000/population.N);
            congestion=computeEquilibriumBottleneck(Na,congestion,population);
        end
end
switch Mode
    case 'continuum'
        [fS,hist]=runIterationsContinuum(departureTimes,settings,congestion,population,revisionProtocol,ini);
    case 'discrete'
        [fS,hist]=runIterationsDiscrete(settings,congestion,population,updateProportion,ini);
end

