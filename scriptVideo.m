%% This script generates the videos for the MOOC
clear all
close all
path(genpath(cd),path);


%
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

col=get(gca,'colororder');
longcol=parula(10);
screensize = get( groot, 'Screensize' );
figVideo=figure;
set(figVideo,'Position',[0,0,screensize(3)*0.25,0.38*screensize(4)]);

dt=1/60;
departureTimes=8+(-1.5:dt:1.5);
Nt=length(departureTimes);
Capacity=1/2;
congestion=generateBottleneck(Capacity);

settings.maxIter=400;
settings.display='off'; %'on' 'off'
settings.knownEq=1;

revisionProtocol.exponent=1;
revisionProtocol.fun=@(R,U,lambda)SmithRevisionProtocolExponent(R,U,lambda,revisionProtocol.exponent);

du=1.5;
revisionProtocol.rate=1/Nt;
stdStar=[0.1,0.4];
for i=1:length(stdStar)
    if stdStar(i)>0
        N=10;
        tstar=8+(-((1:N)-(1+N)/2)*stdStar(i)/sqrt((N^2-1)/12));
    else
        tstar=8;
    end
    population=generateSParctan(tstar,(1-du/2)*ones(size(tstar)),(1+du/2)*ones(size(tstar)),ones(size(tstar)),4*ones(size(tstar)));
    [fS,hist]=runIterationsContinuum(departureTimes,settings,congestion,population,revisionProtocol,[]);
    % plot SP
    figure('Position',[0,0,screensize(3)*0.2,0.2*screensize(4)]);
    if population.N>1
        for indf=1:population.N
            plot(departureTimes,population.uO{indf}(departureTimes),'k');
            hold on
            plot(departureTimes,population.uD{indf}(departureTimes),'Color',longcol(indf,:));
        end
    else
        plot(departureTimes,population.uO{1}(departureTimes),'k');
        hold on
        plot(departureTimes,population.uD{1}(departureTimes),'r');
    end
    xlabel('Time');
    ylabel('Marginal utility rate');
    print(['SP', num2str(i)],'-dpng','-r200')
    % Video
    % Set up the movie.
    writerObj = VideoWriter(['sigma', num2str(stdStar(i)), '.m4v'],'MPEG-4'); % Name it.
    writerObj.FrameRate = 20; % How many frames per second.
    open(writerObj);
    figure(figVideo)
    Na=ceil(1000/population.N);
    congestion=computeEquilibriumBottleneck(Na,congestion,population);
    for iter=1:settings.maxIter
        subplot(211)     % travel time profile
        plot(departureTimes,hist.arrivalTimes(iter,:)-departureTimes,'k');
        hold on
        [sortedDep,I]=sort(reshape(congestion.eqDepartures,[],1));
        T=reshape(congestion.eqArrivals-congestion.eqDepartures,[],1);
        plot(sortedDep,T(I),':k');
        if population.N>1
            ylim([0,1])
        else
            ylim([0,1])
        end
        xlabel('Time');
        ylabel('Travel time');
        title(['Day ',num2str(iter)]);
        hold off
        subplot(212)    % Departure rate profile
        hold off
        if population.N>1
            for indf=1:population.N
                plot(departureTimes,squeeze(hist.R(indf,:,iter))/dt,'-','Color',longcol(indf,:));
                hold on
            end
        else
            plot(departureTimes,squeeze(hist.R(1,:,iter))/dt,'-k');
        end
        xlabel('Time');
        ylabel('Departure rate');
        if population.N>1
            ylim([0,0.5])
        else
            ylim([0,2])
        end
        pause(0.01)
        F = getframe(figVideo);
        writeVideo(writerObj, F);
    end
    close(writerObj);
end
