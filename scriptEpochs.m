%% This script generates the figures for the paper on stability and monotonicity
clear all
close all
path(genpath(cd),path);
path(genpath('C:\Users\rlamotte\Documents\PhD\Matlab\simulations\github'),path);

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

screensize = get( groot, 'Screensize' );
fig1=figure;
set(1,'Position',[0,0,screensize(3)/2,0.42*screensize(4)]);
fig2=figure;
set(fig2,'Position',[0,0,screensize(3)/2,0.65*screensize(4)]);
col=get(gca,'colororder');


dt=1/60;
departureTimes=-1.5:dt:1.5;
Nt=length(departureTimes);
Capacity=1/2;
congestion=generateBottleneck(Capacity);

settings.display='off'; %'on' 'off'
settings.knownEq=0;
settings.maxEpoch=5;

revisionProtocol.exponent=1;
revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);

% %
% lambda=[1,0.5,0.2,0.1,0.05,0.02,0.01,0.005,0.002,0.001];
% longcol=jet(length(lambda));
% stdStar=[0,0.05,0.1];
% styles={'-','--',':','-.'};
% du=1.5;
% 
% for inds=1:length(stdStar)
%     minPG=zeros(length(lambda),1);
%     maxPG=zeros(length(lambda),1);
%     PGquant=zeros(length(lambda),5);
%     for i=1:length(lambda)
%         revisionProtocol.rate=lambda(i)/length(departureTimes);
%         if stdStar(inds)>0
%             N=10;
%             tstar=0-((1:N)-(1+N)/2)*stdStar(inds)/sqrt((N^2-1)/12);
%         else
%             tstar=0;
%         end
%         settings.maxIter=500/lambda(i);
%         population=generateSParctan(tstar,(1-du/2)*ones(size(tstar)),(1+du/2)*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));
%         [fS,hist]=runIterationsContinuumWhile(departureTimes,settings,congestion,population,revisionProtocol,[]);
%         figure(fig1)
%         subplot(1,2,1) % Potential gain
%         plot(cumsum(hist.shifts),hist.potGain,styles{inds},'Color',longcol(i,:));
%         hold on
%         xlabel('Epochs');
%         ylabel('Potential gain [\%]');
% %         title(['$\lambda=',num2str(lambda(i)),'$']);
%         xlim([0,settings.maxEpoch]);
%         
%         subplot(1,2,2) % Potential gain
%         semilogy(cumsum(hist.shifts),1:length(hist.TU),styles{inds},'Color',longcol(i,:));
%         xlim([0,settings.maxEpoch]);
%         hold on
%         xlabel('Epochs');
%         ylabel('Iteration');
% %         title(['$\lambda=',num2str(lambda(i)),'$']);
%         ind=find(cumsum(hist.shifts)>5);
%         pause(0.1)
%         minPG(i)=min(hist.potGain(ind));
%         maxPG(i)=max(hist.potGain(ind));
%         PGquant(i,:)=quantile(hist.potGain(ind),[0.1,0.25,0.5,0.75,0.9]);
%     end
%     figure(fig2)
%     semilogx(lambda,minPG,styles{inds});
%     hold on
%     semilogx(lambda,maxPG,styles{inds});
%     semilogx(lambda,PGquant,styles{inds});
% end

%
lambda=0.01;
stdStar=0;
styles={'-','--',':','-.'};
% du=[1.5,0.5,-0.5,-1.5];
du=[-1.5];
revisionProtocol.rate=lambda/length(departureTimes);
tstar=0;
settings.maxIter=500/lambda;
for indu=1:length(du)  
        population=generateSParctan(tstar,(1-du(indu)/2)*ones(size(tstar)),(1+du(indu)/2)*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));
        [fS,hist]=runIterationsContinuumWhile(departureTimes,settings,congestion,population,revisionProtocol,[]);
        epochs=cumsum(hist.shifts);
        figure(fig1)
        subplot(1,2,1) % Potential gain
        plot(epochs,hist.potGain);
        hold on
        xlabel('Epochs');
        ylabel('Potential gain [\%]');
%         title(['$\lambda=',num2str(lambda(i)),'$']);
        xlim([0,settings.maxEpoch]);
       
        subplot(1,2,2) % Potential gain
        semilogy(epochs,1:length(hist.TU));
        xlim([0,settings.maxEpoch]);
        hold on
        xlabel('Epochs');
        ylabel('Iteration');
%         title(['$\lambda=',num2str(lambda(i)),'$']);
        figure(fig2)
        subplot(2,2,1)
        semilogy(epochs,hist.Lyap);
        subplot(2,2,2)
        plot(epochs(1:end-1),hist.DLyap1(1:end-1)./hist.Lyap(1:end-1)./hist.shifts(1:end-1));
        subplot(2,2,3)
        plot(epochs(1:end-1),hist.DLyap2(1:end-1)./hist.Lyap(1:end-1)./hist.shifts(1:end-1));
        subplot(2,2,4)
        plot(epochs(1:end-1),(hist.DLyap1(1:end-1)+hist.DLyap2(1:end-1))./hist.Lyap(1:end-1)./hist.shifts(1:end-1));
        hold on
        plot(epochs(1:end-1),(hist.Lyap(2:end)-hist.Lyap(1:end-1))./hist.Lyap(1:end-1)./hist.shifts(1:end-1),'--');
        pause(0.1)
        figure(3)
        scatter(hist.Lyap,(hist.DLyap1+hist.DLyap2)./hist.Lyap,'.');
        hold on
end


