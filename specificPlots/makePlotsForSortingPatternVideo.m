if iter==1
    screensize = get( groot, 'Screensize' );
    figVideo=figure;
    set(figVideo,'Position',[0,0,screensize(3)*0.5,0.2*screensize(4)]);
    % Video
    % Set up the movie.
    writerObj = VideoWriter(['Capacity', num2str(round(100*congestion.C)), '.m4v'],'MPEG-4'); % Name it.
    writerObj.FrameRate = 20; % How many frames per second.
    open(writerObj);
else
    figure(figVideo)
end
subplot(1,3,1)
colormap jet
scatter(t(indDep),population.L(I_s2f),6,population.tstar(I_s2f),'o');
xlabel('Departure Time');
ylabel('Trip length');
title(['Day ',num2str(iter)]);
xlim([4,11]);
box on
hold off
subplot(1,3,2)
colormap jet
scatter(t(indExDep),population.L(I_s2f),6,population.tstar(I_s2f),'x');
xlabel('Arrival Time');
ylabel('Trip length');
title(['Day ',num2str(iter)]);
xlim([4,11]);
box on
hold off
subplot(1,3,3)
plot(t,v);
xlabel('Time');
ylabel('Speed');
title(['Day ',num2str(iter)]);
axis([4,11,0,1]);
F = getframe(figVideo);
writeVideo(writerObj, F);
if iter==settings.maxIter
    close(writerObj);
end