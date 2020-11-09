%% Presentation
% This script launches a bottleneck simulation with a continuum of users and stochastic capacity.
% Last modified by Raphael Lamotte, on October 24, 2018.

clear all
close all
path(genpath(cd),path);

% Define the population of users
% population=generateSPabg();%
tstar=0;
N=1;

% Define some technical settings
lambda=10^(-2);
settings.maxIter=10^6;
settings.display='off'; %'on' 'off' 'final'
settings.additionalPlots='off';
settings.knownEq=0; % should only set to a positive value if Iryo's method apply (morning commute with identical alpha).

% Define some mode-specific parameters
departureTimes=-2:1/60:2;
ini=ones(N,length(departureTimes))/N/length(departureTimes); % initial distribution of departures
revisionProtocol.exponent=1;
revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);
revisionProtocol.rate=lambda/length(departureTimes);
    
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

% define multiple capacities.
% Run individual simulation with each of them
% Run one with stochastic, and plot all potential gains.
std=[0.1,0.2];
w=[4,1];
% std=[0.2];
% w=[1];
AllCumShifts=cell(length(std),length(w));
AllLyap=cell(length(std),length(w));
AllCumShiftsDet=cell(length(std),length(w),21);
AllLyapDet=cell(length(std),length(w),21);
for ind_std=1:length(std)
    for ind_w=1:length(w)
        population=generateSParctan(tstar,0.5,1.5,1,w(ind_w));%
        Capacity=0.5*(1-std(ind_std):std(ind_std)/10:1+std(ind_std));
        
        congestion=generateBottleneck(Capacity);
        [finalState,hist]=runIterationsContinuumStochasticWhile(departureTimes,settings,congestion,population,revisionProtocol,ini);
% %         figure(1)
% %         subplot(length(std),length(w),ind_w+(ind_std-1)*length(w))
% %         plot(1:settings.maxIter,hist.potGain,'r');
% %         hold on
%         
%         figure(2)
%         subplot(length(std),length(w),ind_w+(ind_std-1)*length(w))
%         x=cumsum(hist.shifts);
%         y=hist.Lyap;
%         plot(x(1:end),y(1:end),'r');
%         hold on
        AllCumShifts{ind_std,ind_w}=cumsum(hist.shifts);
        AllLyap{ind_std,ind_w}=hist.Lyap;
% 
%         xlabel('Average decision updates');
%         ylabel('Net gain');
%         xlim([0,5]);
%         title(['$w=',num2str(w(ind_w)),', \Delta S=\pm',num2str(100*std(ind_std)),'\%$']);
        
        if (ind_std==length(std) && ind_w==length(w))
%             figure(3)
%             plot(finalState.t',finalState.n');
%             xlabel('Time');
%             ylabel('Queue length');
%             
%             figure(4)
%             plot(departureTimes,hist.R(:,:,end),'r');
%             xlabel('Time');
%             ylabel('departure rate');
             t_stoch=finalState.t';
             n_stoch=finalState.n';
             R_stoch=hist.R(:,:,end);
        end
        
        for i=1:10:length(Capacity)
            congestion=generateBottleneck(Capacity(i));
            [finalState,hist]=runIterationsContinuumStochasticWhile(departureTimes,settings,congestion,population,revisionProtocol,ini);
% %             figure(1)
% %             subplot(length(std),length(w),ind_w+(ind_std-1)*length(w))
% %             plot(1:settings.maxIter,hist.potGain,':k');
% %             hold on
%             figure(2)
%             x=cumsum(hist.shifts);
%             y=hist.Lyap;
%             subplot(length(std),length(w),ind_w+(ind_std-1)*length(w))
%             plot(x(1:end),y(1:end),'k');
%             hold on
            AllCumShiftsDet{ind_std,ind_w,i}=cumsum(hist.shifts);
            AllLyapDet{ind_std,ind_w,i}=hist.Lyap;
        end
    end
end
% subplot(length(std),length(w),1)
% legend({'Stochastic','Deterministic'});
% save("workspace_stochasticity")
save("workspace_stochasticity_light",'std','w','AllCumShifts','AllLyap','AllCumShiftsDet','AllLyapDet','t_stoch','n_stoch','R_stoch','departureTimes','Capacity')
