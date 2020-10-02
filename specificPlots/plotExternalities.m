%% Context
% Specific plots are called within the runIterationsContinuum and runIterationsDiscrete functions,
% right after the normal plots (makePlotsContinuum and MakePlotsDiscrete) 
% This specific code plots externalities for MFD dynamics with homogeneous
% users.
dn=10^-10;
for i=5:5:length(departureTimes)
    [newd,newt,newindDep,newindExChrono,newindExDep,newn,newv] = MFDDynamics(dep4Dyn,L4Dyn,weights+sparse(i,1,dn,length(weights),1),congestion.speed_fct);
    % Fill matrix of arrival times
    figure(2)
    plot(departureTimes,(newt(newindExDep)-t(indExDep))/dn,'Color',col(mod(i/5,7)+1,:));
    hold on
    plot([departureTimes(i),departureTimes(i)],[0,newt(newindExDep(i))-t(indExDep(i))]/dn,'Color',col(mod(i/5,7)+1,:));
    % Fill matrix of utilities
    figure(3)
    newUtilities=zeros(population.N,Nt);
    for j=1:population.N
        newUtilities(j,:)=population.UD{j}(newt(newindExDep));
    end
    newUtilities=newUtilities+UtilitiesAtDep;
    plot(departureTimes,(Utilities-newUtilities)/dn,'Color',col(mod(i/5,7)+1,:));
    hold on
    plot([departureTimes(i),departureTimes(i)],[0,Utilities(i)-newUtilities(i)]/dn,'Color',col(mod(i/5,7)+1,:));
end
figure(2)
hold off
figure(3)
hold off