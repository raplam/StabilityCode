function [Utilities,V,arrivalTimes]=utilityEvaluationMFD(departureTimes,d,t,vf,population)
%evaluate_potential_dep_MFD_atan_vectorized(L,d,t,potDep,vf,H,W,a,b,tstar)
Nt=length(departureTimes);
dti=zeros(1,Nt); % values of d at all departureTimes
V=zeros(1,Nt); % Speed at all departureTimes
Utilities=zeros(population.N,Nt);
%% Compute distances at all departureTimes
next_d=NaN;
for i=1:length(departureTimes)
    [next_d,dti(i),V(i)] = compute_dist_from_t(next_d,d,t,departureTimes(i),vf);
end

%% distances at all arrivalTimes (homogeneous L)
dta=dti+population.L;

%% Compute arrivalTimes
next_a=NaN;
arrivalTimes=zeros(size(dta));
for i=1:length(dta)
    [next_a,arrivalTimes(i)] = compute_ta_from_dta2(next_a,d,t,dta(i),vf);
end
% Compute costs
for i=1:population.N
    Utilities(i,:)=population.UO{i}(departureTimes)+population.UD{i}(arrivalTimes(i,:));
end
end
function [next_d,dist,v] = compute_dist_from_t(next_d,d,t,ti,vf)
if isnan(next_d)% first iteration or ti not in between two events.
    if ti>t(1)
        if ti<t(end)
            TMP=find(t>=ti,1,'first');
            next_d=TMP(1);
            v=(d(next_d)-d(next_d-1))/(t(next_d)-t(next_d-1));
            dist=d(next_d-1)+(ti-t(next_d-1))*v;
        else
            v=vf;
            dist=d(end)+vf*(ti-t(end));
        end
    else %starts too early
        dist=d(1)-vf*(t(1)-ti);
        v=vf;
    end
else
    TMP=find(t(next_d:end)>=ti,1,'first');
    if ~isempty(TMP)
        next_d=next_d-1+TMP(1);
        if next_d==1
            dist=d(1)-vf*(t(1)-ti);
            v=vf;
        else
            v=(d(next_d)-d(next_d-1))/(t(next_d)-t(next_d-1));
            dist=d(next_d-1)+(ti-t(next_d-1))*v;
        end
    else
        next_d=length(d);
        dist=d(end)+vf*(ti-t(end));
        v=vf;
    end
end
end
function [next_a,ta] = compute_ta_from_dta2(next_a,d,t,dta,vf)
if isnan(next_a)%first time or finishes too early or too late
    if dta>d(1)
        if dta>=d(end) %finishes too late
            ta=t(end)+(dta-d(end))/vf;
        else %finishes in time
            TMP=find(d>=dta,1,'first');
            next_a=TMP(1);
            ta=t(next_a-1)+(dta-d(next_a-1))/(d(next_a)-d(next_a-1))*(t(next_a)-t(next_a-1));
        end
    else %finishes too early
        ta=t(1)-(d(1)-dta)/vf;
    end
else
    if dta>d(end)
        next_a=length(d);
        ta=t(end)+(dta-d(end))/vf;
    else
        while d(next_a)<dta
            next_a=next_a+1;
        end
        if next_a==1
            ta=t(next_a)-(d(1)-dta)/vf;
        else
            ta=t(next_a-1)+(dta-d(next_a-1))/(d(next_a)-d(next_a-1))*(t(next_a)-t(next_a-1));
        end
    end
end
end

