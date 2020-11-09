%% This script generates the figures for the paper on stability and monotonicity
clear all
close all
path(genpath(cd),path);
% path(genpath('C:\Users\rlamotte\Documents\PhD\Matlab\simulations\github'),path);

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

% screensize = get( groot, 'Screensize' );
% figVerif=figure;
% set(figVerif,'Position',[0,0,screensize(3)/2,0.42*screensize(4)]);
% figCumPlots=figure;
% set(figCumPlots,'Position',[0,0,screensize(3)/2,0.65*screensize(4)]);
% figDelta=figure(1);
% set(figDelta,'Position',[0,0,screensize(3)/2,screensize(4)]);
% figMetrics=figure;
% set(figMetrics,'Position',[0,0,screensize(3)/2,.75*screensize(4)]);

% col=get(gca,'colororder');
% longcol=parula(10);

dt=1/60;
departureTimes=-1.5:dt:1.5;
Nt=length(departureTimes);
Capacity=1/2;
congestion=generateBottleneck(Capacity);

settings.maxIter=400;
settings.display='off'; %'on' 'off'
settings.knownEq=0;

revisionProtocol.exponent=1;
revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);


%% Heterogeneity and response rate
% du=[-1.5,1.5];
% lambda=1;
% % stdStar=[0,0.1,0.2,0.3,0.4,0.5];
% stdStar=[0,0.2,0.4];
% revisionProtocol.rate=lambda/Nt;
% for indu=1:length(du)
%     for i=1:length(stdStar)
%         if stdStar(i)>0
%             N=10;
%             tstar=-((1:N)-(1+N)/2)*stdStar(i)/sqrt((N^2-1)/12);
%         else
%             tstar=0;
%         end
%         population=generateSParctan(tstar,(1-du(indu)/2)*ones(size(tstar)),(1+du(indu)/2)*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));
%         [fS,hist]=runIterationsContinuum(departureTimes,settings,congestion,population,revisionProtocol,[]);
%         figure(figVerif)
%         if du(indu)>0
%             plot(1:settings.maxIter,hist.potGain,'-','Color',col(i,:));
%         else
%             plot(1:settings.maxIter,hist.potGain,'--','Color',col(i,:));
%         end
%         hold on
%         xlabel('Days');
%         ylabel('Potential gain [\%]');
%         ylim([0,100]);
%     end
% end
% legend({['$\sigma^*=', num2str(stdStar(1)), '$'],...
%     ['$\sigma^*=', num2str(stdStar(2)), '$'],...
%     ['$\sigma^*=', num2str(stdStar(end)), '$']},'fontsize',10);
% %     ['$\sigma^*=', num2str(stdStar(3)), '$'],...
% %     ['$\sigma^*=', num2str(stdStar(4)), '$'],....
% %     ['$\sigma^*=', num2str(stdStar(5)), '$'],....
% 
% % Plot schedule preferences
% col2=parula(10);
% figure
% for i=1:population.N
%     plot(departureTimes,population.uD{i}(departureTimes),'Color',col2(i,:));
%     hold on
% end
% plot(departureTimes,ones(size(departureTimes)),'k');
% xlabel('Time of day');
% ylabel('Marginal utility rate');

%% What about delta?
lambda=[0.001,0.01,0.1,1];
%lambda=[0.01,0.1,1];
stdStar=[0, 0, 0, 0];
du=[-1,1];
% lambda=[0.01];
% stdStar=[0];
% du=[1];
AllCumShifts=cell(length(lambda),length(du));
AllLyap=cell(length(lambda),length(du));
AllIter=cell(length(lambda),length(du));
for i=1:length(lambda)
    for indu=1:length(du)
        revisionProtocol.rate=lambda(i)/length(departureTimes);
        if stdStar(i)>0
            N=10;
            tstar=0-((1:N)-(1+N)/2)*stdStar(i)/sqrt((N^2-1)/12);
        else
            tstar=0;
        end
        settings.maxIter=5000/lambda(i);
        population=generateSParctan(tstar,(1-du(indu)/2)*ones(size(tstar)),(1+du(indu)/2)*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));
        [fS,hist]=runIterationsContinuumWhile(departureTimes,settings,congestion,population,revisionProtocol,[]);
%         figure(figDelta)
%         subplot(3,1,1) % Potential gain
        step=max(1,round(1/10/lambda(i)));
        tmp=cumsum(hist.shifts);
        AllCumShifts{i,indu}=tmp(1:step:end);
        AllLyap{i,indu}=hist.Lyap(1:step:end);
        AllIter{i,indu}=1:step:length(tmp);
%         tmp=cumsum(hist.shifts);
%         step=max(1,round(1/10/lambda(i)));
%         if du(indu)>0
%             plot(tmp(1:step:end),hist.potGain(1:step:end),'--','Color',col(i,:));
%         else
%             plot(tmp(1:step:end),hist.potGain(1:step:end),'-','Color',col(i,:));
%         end
%         hold on
%         xlabel('Average number of updates (per user)');
%         ylabel('Potential gain [\%]');
%         title('(a)');
%         xlim([0,5]);
%         subplot(3,1,3) % Potential gain
%         if du(indu)>0
%             semilogy(tmp(1:step:end),1:step:length(tmp),'--','Color',col(i,:));
%         else
%             semilogy(tmp(1:step:end),1:step:length(tmp),'-','Color',col(i,:));
%         end
%         xlim([0,5]);
%         hold on
%         xlabel('Average number of updates (per user)');
%         ylabel('Number of iterations');
%         title('(c)');
% %         figure(3) % Cost decomposition
%         plot(cumsum(hist.shifts),-hist.TU,cumsum(hist.shifts),-hist.TU-hist.TotDelay,cumsum(hist.shifts),hist.TotDelay);
%         AnaCost=-population.UD{1}(0.5/Capacity)-population.UO{1}(0.5/Capacity);
%         AnaSP=-population.intUD{1}(0.5/Capacity)-population.intUO{1}(0.5/Capacity);
%         hold on
%         plot([0,5],[AnaCost,AnaCost],'--','Color',col(1,:));
%         plot([0,5],[AnaSP,AnaSP],'--','Color',col(2,:));
%         plot([0,5],[AnaCost-AnaSP,AnaCost-AnaSP],'--','Color',col(3,:));
%         xlabel('Average number of updates (per user)');
%         subplot(3,1,2)
%         if du(indu)>0
%             semilogy(tmp(1:step:end),hist.Lyap(1:step:end),'--','Color',col(i,:));
%         else
%             semilogy(tmp(1:step:end),hist.Lyap(1:step:end),'-','Color',col(i,:));
%         end
%         hold on
%         xlabel('Average number of updates (per user)');
%         ylabel('Net gain');
%         title('(b)');
%         xlim([0,5]);
    end
end
% save('workspace_deterministe')
save('workspace_deterministe_light', 'AllCumShifts','AllLyap','AllIter','lambda','du')
% figure(figDelta)
% subplot(3,1,1)
% legend({'$\lambda=10^{-3}$ (PM) ',...
%     '$\lambda=10^{-3}$ (AM)',...
%     '$\lambda=10^{-2}$ (PM)',...
%     '$\lambda=10^{-2}$ (AM)',...
%     '$\lambda=10^{-1}$ (PM)',...
%     '$\lambda=10^{-1}$ (AM)',...
%     '$\lambda=1$ (PM)',...
%     '$\lambda=1$ (AM)'},'fontsize',11,'NumColumns',2);
% subplot(3,1,2)
% ylim([10^(-8);10^(-1)])
% set(gca, 'ytick', [10^(-8);10^(-6);10^(-4);10^(-2)]);
% subplot(3,1,3)
% ylim([1;10^8])
% set(gca, 'ytick', [1;10^2;10^4;10^6;10^8]);
% savefig(figDelta,'figDelta.fig','compact');
% saveas(figDelta,'figDelta','epsc');

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
