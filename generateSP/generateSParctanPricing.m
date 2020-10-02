function population = generateSParctanPricing(tstar,du,t0)
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
if min(du)<0
    error('pricing only works with du>0');
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
    population.uO{i}=@(x)alpha*ones(size(x));
    population.uD{i}=@(x)du(i)/pi*atan(w*(x-tstar(i)))+alpha;
    population.UO{i}=@(x)alpha*(x-population.maximizer(i));
    Ueq=population.UO{i}(t0)+normalIntAtanBis(t0);
    population.UD{i}=@(x)normalIntAtanBis(x)-...
        (x>=t0).*(x<tend).*(population.UO{i}(x)+normalIntAtanBis(x)-Ueq);
    population.intUO{i}=@(x)alpha*(x-population.maximizer(i)).^2/2;
    population.intUD{i}=@(x)normalInt2Atan(x)-...
        (x>=t0).*(...
        (x<tend).*(population.intUO{i}(x)-population.intUO{i}(t0)+...
        normalInt2Atan(x)-normalInt2Atan(t0)-Ueq*(x-t0))+...
        (x>=tend).*(population.intUO{i}(tend)-population.intUO{i}(t0)+...
        normalInt2Atan(tend)-normalInt2Atan(t0)-Ueq*(tend-t0)));
end

% test
dt=0.001;
t=6:dt:10;
figure
for i=1:1
    subplot(3,2,2*i-1);
    plot(t,population.uO{i}(t),':k',t,population.uD{i}(t),':r',t,population.UO{i}(t),'-k',t,population.UD{i}(t),'-r');
    hold on
    plot(t,cumsum(population.uO{i}(t))*dt+population.UO{i}(t(1)),':k',t,-cumsum(population.uD{i}(t))*dt+population.UD{i}(t(1)),':r');
    subplot(3,2,2*i);
    plot(t,cumsum(population.UO{i}(t))*dt+population.intUO{i}(t(1)),':k',t,cumsum(population.UD{i}(t))*dt+population.intUD{i}(t(1)),':r');
hold on
    plot(t,population.intUO{i}(t),'-k',t,population.intUD{i}(t),'-r');
    subplot(3,2,3)
    plot(t,population.UO{i}(t)+population.UD{i}(t));
end
% % 
