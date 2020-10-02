function population = generateSParctanDepartureBasedPricing(tstar,du,t0)
% uO(t), uD(t): marginal utility rate at Origin / Destination.
% UO(t), UD(t): accumulated utility at Origin (resp. destination) when
% departing (resp. arriving) at t.

% if du>0 (resp du>0), the marginal utility rate at destination (resp. origin) is assumed constant
% while the marginal utility rate at origin (resp. destination) increases (resp. decreases) with an arctan
% function, of amplitude du.

% tstar and du should have the same length.
tend=tstar+(tstar-t0);
alpha=1;
if length(tstar)>1 || length(du)>1
    error('pricing only works with homogeneous population');
end
if max(abs(du))>2*alpha
    error('max(abs(du))>2*alpha');
end

population.N=1;
population.L=10;
population.tstar=tstar;
population.du=du;
population.maximizer=tstar;
w=4;

tstar=reshape(tstar,[population.N,1]);
du=reshape(du,[population.N,1]);

normalIntAtan=@(x)-(alpha*(x-tstar)+du/pi*((x-tstar).*atan(w*(x-tstar))-log(w^2*(x-tstar).^2+1)/(2*w)));
normalIntAtanBis=@(x)normalIntAtan(x)-normalIntAtan(tstar);
normalInt2Atan=@(x)-(alpha/2*(x-tstar).^2+du/pi*((w^2*(x-tstar).^2-1).*atan(w*(x-tstar))/(2*w^2)-((x-tstar).*log(w^2*(x-tstar).^2+1)-(x-tstar))/(2*w)));
for i=1:1
    if du>0
        UOtmp=@(x)alpha*(x-population.maximizer(i));
        Ueq=UOtmp(t0)+normalIntAtanBis(t0);
        population.UO{i}=@(x)UOtmp(x)-...
            (x>t0).*(x<tend).*(UOtmp(x)+normalIntAtanBis(x)-Ueq);
        population.UD{i}=@(x)normalIntAtanBis(x);
        intUOtmp=@(x)alpha*(x-population.maximizer(i)).^2/2;
        population.intUD{i}=@(x)normalInt2Atan(x);
        population.intUO{i}=@(x)intUOtmp(x)+...
            (x>t0).*(...
            (x<tend).*(-intUOtmp(x)+intUOtmp(t0)-normalInt2Atan(x)+normalInt2Atan(t0)+(x-t0)*Ueq)+...
            (x>=tend).*(-intUOtmp(tend)+intUOtmp(t0)-normalInt2Atan(tend)+normalInt2Atan(t0)+(tend-t0)*Ueq));
    else
        error('no code for negative du');
    end
end

% test
% t=6:0.01:10;
% figure
% for i=1:1
% %     subplot(3,2,2*i-1);
% %     plot(t,population.uO{i}(t),':k',t,population.uD{i}(t),':r',t,population.UO{i}(t),'-k',t,population.UD{i}(t),'-r');
% %     hold on
% %     plot(t,cumsum(population.uO{i}(t))*0.01+population.UO{i}(t(1)),':k',t,-cumsum(population.uD{i}(t))*0.01+population.UD{i}(t(1)),':r');
%     subplot(3,2,2*i);
%     plot(t,cumsum(population.UO{i}(t))*0.01+population.intUO{i}(t(1)),':k',t,cumsum(population.UD{i}(t))*0.01+population.intUD{i}(t(1)),':r');
% hold on
%     plot(t,population.intUO{i}(t),'-k',t,population.intUD{i}(t),'-r');
% end

