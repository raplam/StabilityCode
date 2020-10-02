function population = generateSPlinear(ud0,ud1)
% Marginal utility at origin is constant and equal to 1.
% Marginal utility at destination increases linearly, is equal to ud0>=0 at
% the beginning of the first time window, and to ud1 1 time unit later.

if length(unique([numel(ud0),numel(ud1)]))~=1
    error('All inputs should have the same number of elements');
else
    population.N=numel(ud0);
    ud0=reshape(ud0,1,[]);
    ud1=reshape(ud1,1,[]);
end
tstar=(1-ud0)./(ud1-ud0);
population.tstar=(1-ud0)./(ud1-ud0);
population.maximizer=tstar;
population.ud0=ud0;
population.ud1=ud1;

for i=1:population.N
    population.uO{i}=@(x)ones(size(x)); % marginal utility rate at origin
    population.uD{i}=@(x)ud0(i)+x*(ud1(i)-ud0(i)); % marginal utility rate at destination
    population.UO{i}=@(x)(x-tstar(i)); % integral of marginal utility rate at origin
    population.UD{i}=@(x)ud0(i)*(tstar(i)-x)-x.^2/2*(ud1(i)-ud0(i))+tstar(i).^2/2*(ud1(i)-ud0(i)); % integral of marginal utility rate at destination, with x as lower limit
    population.intUO{i}=@(x)(x-tstar(i)).^2/2; % integral of UO (used to compute average UO over an interval)
    population.intUD{i}=@(x)-ud0(i)*(tstar(i)-x).^2/2-x.^3/6*(ud1(i)-ud0(i))+x.*tstar(i).^2/2*(ud1(i)-ud0(i)); % integral of UD (used to compute average UD over an interval)
end
end

