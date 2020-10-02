function population = generateSPabg(tstar)
% The schedule preferences correspond to the alpha-beta-gamma preferences, with
% w=@(x,ts,a,b,g)(x>ts)*(a+g)+(x<=ts)*(a-b);
% h=@(x,ts,a,d)a;

population.N=length(tstar);
population.L=10;
population.tstar=tstar;

alpha=ones(population.N,1);
beta=0.5*ones(population.N,1);
gamma=2*ones(population.N,1);
tstar=reshape(tstar,[population.N,1]);
population.maximizer=tstar;

for i=1:population.N
    population.h{i}=@(x)alpha(i);
    population.w{i}=@(x)(x>tstar(i))*(alpha(i)+gamma(i))+(x<=tstar(i))*(alpha(i)-beta(i));
    population.H{i}=@(x)alpha(i)*(x-tstar(i));
    population.W{i}=@(x)-(alpha(i)+gamma(i))*(x>tstar(i)).*(x-tstar(i))-(alpha(i)-beta(i))*(x<=tstar(i)).*(x-tstar(i));
    population.intH{i}=@(x)alpha(i)/2*(x-tstar(i)).^2;
    population.intW{i}=@(x)-(alpha(i)+gamma(i))*(x>tstar(i)).*(x-tstar(i)).^2/2-(alpha(i)-beta(i))*(x<=tstar(i)).*(x-tstar(i)).^2/2;
end
end

