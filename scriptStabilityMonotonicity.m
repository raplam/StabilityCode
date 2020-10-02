%% This script generates the figures for the paper on stability and monotonicity
clear all
close all
path(genpath(cd),path);
path(genpath('C:\Users\rlamotte\Documents\PhD\Matlab\simulations\github'),path);

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

col=get(gca,'colororder');
longcol=parula(10);
screensize = get( groot, 'Screensize' );
figVerif=figure;
set(figVerif,'Position',[0,0,screensize(3)/2,0.42*screensize(4)]);
figCumPlots=figure;
set(figCumPlots,'Position',[0,0,screensize(3)/2,0.65*screensize(4)]);
figDelta=figure;
set(figDelta,'Position',[0,0,screensize(3)/2,screensize(4)]);
figMetrics=figure;
set(figMetrics,'Position',[0,0,screensize(3)/2,.75*screensize(4)]);

dt=1/60;
departureTimes=-1.5:dt:1.5;
Nt=length(departureTimes);
Capacity=1/2;
congestion=generateBottleneck(Capacity);

settings.maxIter=10000;
settings.display='off'; %'on' 'off'
settings.knownEq=0;

revisionProtocol.exponent=1;
revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);


% %% Heterogeneity and response rate
% du=1.5;
% lambda=[1,5,10];
% stdStar=[0,0.1,0.2,0.3,0.4,0.5];
% % prepare cumplots
% cumplots=cell(length(lambda),length(stdStar));
% lambdaCumPlot=[1;2;3];
% stdStarCumPlot=[2;5;5];
% dayCumPlot=[127,200;129,200;130,200];
% potGainCumPlot=zeros(3,2);
% pShiftsCumPlot=zeros(3,2);
% indCumPlot=1;
% %
% for indl=1:length(lambda)
%     revisionProtocol.rate=lambda(indl)/Nt;
%     for i=1:length(stdStar)
%         if stdStar(i)>0
%             N=10;
%             tstar=-((1:N)-(1+N)/2)*stdStar(i)/sqrt((N^2-1)/12);
%         else
%             tstar=0;
%         end
%         population=generateSParctan(tstar,(1-du/2)*ones(size(tstar)),(1+du/2)*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));
%         [fS,hist]=runIterationsContinuum(departureTimes,settings,congestion,population,revisionProtocol,[]);
%         figure(figVerif)
%         subplot(2,3,indl) % Potential gain
%         plot(1:settings.maxIter,hist.potGain);
%         hold on
%         xlabel('Days');
%         ylabel('Potential gain [\%]');
%         title(['$\lambda=',num2str(lambda(indl)),'$']);
%         ylim([0,100]);
%         subplot(2,3,3+indl)
%         semilogy(1:settings.maxIter,hist.shifts);
%         hold on
%         xlabel('Days');
%         ylim([0.001,1])
%         ylabel('Proportion of shifts');
%         title(['$\lambda=',num2str(lambda(indl)),'$']);
%         [~,I]=ismember([indl,i],[lambdaCumPlot,stdStarCumPlot],'rows');
%         if I>0
%             figure(figCumPlots)
%             % global cumulative I/O
%             subplot(3,3,(indCumPlot-1)*3+1)
%             plot(departureTimes,cumsum(sum(squeeze(hist.R(:,:,dayCumPlot(I,1))),1)),'-','Color',col(1,:));
%             hold on
%             plot(hist.arrivalTimes(dayCumPlot(I,1),:),cumsum(sum(squeeze(hist.R(:,:,dayCumPlot(I,1))),1)),'--','Color',col(1,:));
%             plot(departureTimes,cumsum(sum(squeeze(hist.R(:,:,dayCumPlot(I,2))),1)),'-','Color',col(2,:));
%             plot(hist.arrivalTimes(dayCumPlot(I,2),:),cumsum(sum(squeeze(hist.R(:,:,dayCumPlot(I,2))),1)),'--','Color',col(2,:));
%             ylim([0,1]);
%             xlabel('Time');
%             ylabel('Cum. dep./arr.');
%             title(['$\lambda = ', num2str(lambda(lambdaCumPlot(I))), ', \sigma^*=', num2str(stdStar(stdStarCumPlot(I))),'$']);
%             legend({['Dep., day ',num2str(dayCumPlot(I,1))],...
%                 ['Arr., day ',num2str(dayCumPlot(I,1))],...
%                 ['Dep., day ',num2str(dayCumPlot(I,2))],...
%                 ['Arr., day ',num2str(dayCumPlot(I,2))]});
%             % cumulative I/O per family day 1
%             subplot(3,3,(indCumPlot-1)*3+2)
%             for indf=1:population.N
%                 plot(departureTimes,squeeze(hist.R(indf,:,dayCumPlot(I,1)))/dt,'-','Color',longcol(indf,:));
%                 hold on
%             end
%             xlabel('Time');
%             ylabel('Departure rate');
%             title(['$\lambda = ', num2str(lambda(lambdaCumPlot(I))), ', \sigma^*=', num2str(stdStar(stdStarCumPlot(I))),'$, day ', num2str(dayCumPlot(I,1))]);
%             % cumulative I/O per family day 2
%             subplot(3,3,(indCumPlot-1)*3+3)
%             for indf=1:population.N
%                 plot(departureTimes,squeeze(hist.R(indf,:,dayCumPlot(I,2)))/dt,'-','Color',longcol(indf,:));
%                 hold on
%             end
%             xlabel('Time');
%             ylabel('Departure rate');
%             title(['$\lambda = ', num2str(lambda(lambdaCumPlot(I))), ', \sigma^*=', num2str(stdStar(stdStarCumPlot(I))),'$, day ', num2str(dayCumPlot(I,2))]);
%             legend({['$t^*=', num2str(tstar(1),2),'$'],...
%                 ['$t^*=', num2str(tstar(2),2), '$'],['$t^*=', num2str(tstar(3),2), '$']',...
%                 ['$t^*=', num2str(tstar(4),2), '$'],['$t^*=', num2str(tstar(5),2), '$'],...
%                 ['$t^*=', num2str(tstar(6),2), '$'],['$t^*=', num2str(tstar(7),2), '$'],...
%                 ['$t^*=', num2str(tstar(8),2), '$'],['$t^*=', num2str(tstar(9),2), '$'],['$t^*=', num2str(tstar(10),2), '$']});
%             %
%             potGainCumPlot(I,:)=hist.potGain(dayCumPlot(I,:));
%             pShiftsCumPlot(I,:)=hist.shifts(dayCumPlot(I,:));
%             indCumPlot=indCumPlot+1;
%         end
%     end
% end
% figure(figVerif)
% for i=1:3
% subplot(2,3,lambdaCumPlot(i))
% scatter(dayCumPlot(i,:),potGainCumPlot(i,:),10,col(stdStarCumPlot(i,:),:),'o');
% subplot(2,3,3+lambdaCumPlot(i))
% scatter(dayCumPlot(i,:),pShiftsCumPlot(i,:),10,col(stdStarCumPlot(i,:),:),'o');
% end
% subplot(2,3,6)
% legend({['$\sigma^*=', num2str(stdStar(1)), '$'],...
%     ['$\sigma^*=', num2str(stdStar(2)), '$'],...
%     ['$\sigma^*=', num2str(stdStar(3)), '$'],...
%     ['$\sigma^*=', num2str(stdStar(4)), '$'],....
%     ['$\sigma^*=', num2str(stdStar(5)), '$'],....
%     ['$\sigma^*=', num2str(stdStar(6)), '$']},'fontsize',10);

%% What about delta?
lambda=[0.001,0.01,0.1,1];
stdStar=[0,0,0,0];
du=[-1.5,1.5];
for i=1:length(lambda)
    for indu=1:length(du)
        revisionProtocol.rate=lambda(i)/length(departureTimes);
        if stdStar(i)>0
            N=10;
            tstar=0-((1:N)-(1+N)/2)*stdStar(i)/sqrt((N^2-1)/12);
        else
            tstar=0;
        end
        settings.maxIter=500/lambda(i);
        population=generateSParctan(tstar,(1-du(indu)/2)*ones(size(tstar)),(1+du(indu)/2)*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));
        [fS,hist]=runIterationsContinuum(departureTimes,settings,congestion,population,revisionProtocol,[]);
        figure(figDelta)
        subplot(1,2,1) % Potential gain
        if du(indu)>0
            plot(cumsum(hist.shifts),hist.potGain,'-','Color',col(i,:));
        else
            plot(cumsum(hist.shifts),hist.potGain,'--','Color',col(i,:));
        end
        hold on
        xlabel('Average decision updates');
        ylabel('Potential gain [\%]');
        title(['$\lambda=',num2str(lambda(i)),'$']);
        xlim([0,5]);
        subplot(1,2,2) % Potential gain
        if du(indu)>0
            semilogy(cumsum(hist.shifts),1:settings.maxIter,'-','Color',col(i,:));
        else
            semilogy(cumsum(hist.shifts),1:settings.maxIter,'--','Color',col(i,:));
        end
        xlim([0,5]);
        hold on
        xlabel('Average decision updates');
        ylabel('Iteration');
        title(['$\lambda=',num2str(lambda(i)),'$']);
    end
end
figure(figDelta)
subplot(1,2,1)
% legend({['$\delta=', num2str(du(1)), '$'],...
%     ['$\delta=', num2str(du(2)), '$']},'fontsize',11);

%% Social cost decomposition
% du=[1.5,1.5,-1.5];
% stdStar=[0.1,.4,.4];
% lambda=1:1:10;
% for ind=1:length(stdStar)
%     if stdStar(ind)>0
%         N=10;
%         tstar=0-((1:N)-(1+N)/2)*stdStar(ind)/sqrt((N^2-1)/12);
%     else
%         tstar=0;
%     end
%     for indl=1:length(lambda)
%         revisionProtocol.rate=lambda(indl)/length(departureTimes);
%         population=generateSParctan(tstar,(1-du(ind)/2)*ones(size(tstar)),(1+du(ind)/2)*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));
%         [fS,hist]=runIterationsContinuum(departureTimes,settings,congestion,population,revisionProtocol,[]);
%         plotPhysicalIndices(hist.R,hist.U,departureTimes,hist.arrivalTimes,figMetrics,ind,1,longcol(indl,:))
%     end
%     if du(ind)>0
%         plotTheoreticalEquilibrium(congestion,population,figMetrics,ind);
%     end
%     % add labels
%     for j=3:-1:1
%         subplot(length(stdStar),3,(ind-1)*3+j)
%         title(['$\sigma^*=',num2str(stdStar(ind)),', \delta=',num2str(du(ind)),'$']);
%         xlabel('Potential gain [\%]');
%         xlim([0,100]);
%         box on
%         switch j
%             case 1
%                 ylabel('Average delay');
%             case 2
%                 ylabel('Average schedule penalty');
%             case 3
%                 ylabel('Average congestion cost');
%                 ylims=ylim;
%         end
%         ylim([0,ylims(2)]);
%     end
% end
% subplot(3,3,5)
% legend({'$\lambda=1$','$\lambda=2$','$\lambda=3$','$\lambda=4$',...
%     '$\lambda=5$','$\lambda=6$','$\lambda=7$','$\lambda=8$',...
%     '$\lambda=9$','$\lambda=10$'});
