function population = generateSPabg(tstar,u1,u2,uref)
% Generates a population with alpha-beta-gamma preferences and a constant marginal utility
% rate. 
% The inputs should be such that 0<u1<uref<u2. alpha=uref, beta=uref-u1,
% gamma=u2-uref;
% The inputs tstar, u1, u2 and uref should all have the same number of elements.
% Last modified by Raphael Lamotte, on November 30, 2018.

population.tstar=reshape(tstar,1,[]);
population.N=length(population.tstar);
if length(unique([numel(tstar),numel(u1),numel(u2),numel(uref)]))~=1
    error('All inputs should have the same number of elements');
else
    u1=reshape(u1,1,[]);
    u2=reshape(u2,1,[]);
    uref=reshape(uref,1,[]);
end
for i=1:population.N
    population.uO{i}=@(x)uref(i)*ones(size(x)); % marginal utility rate at origin
    population.uD{i}=@(x)u1(i)*(x<tstar(i))+u2(i)*(x>=tstar(i)); % marginal utility rate at destination
    population.UO{i}=@(x)uref(i)*(x-tstar(i)); % integral of marginal utility rate at origin
    population.UD{i}=@(x)u1(i)*max(tstar(i)-x,zeros(size(x)))-u2(i)*max(x-tstar(i),zeros(size(x)));
    population.intUO{i}=@(x)uref(i)*(x-tstar(i)).^2/2; % integral of UO (used to compute average UO over an interval)
    population.intUD{i}=@(x)-u1(i)/2*(tstar(i)-x).*max(tstar(i)-x,zeros(size(x)))-u2(i)/2*max(x-tstar(i),zeros(size(x))).*(x-tstar(i));
end
end
