function upo = upoextraction( ts, vel_thres, dt )
%UPOEXTRACTION Extracts an unstable periodic orbit from a nystagmus
%timeseries.
%
% Syntax:  upo = upoextraction( ts, vel_thres, dt )
%
% Inputs:
%    ts         - Nystagmus time series
%    vel_thres  - Velocity threshold
%    dt         - Time series time step
%
% Outputs:
%    upo        - Unstable periodic orbit
%
% Example:
%    upo  = upoextraction( ts, 70, 0.0004 )
%    This example extracts the upo from the timeseries ts with the time
%    step 0.0004 seconds and velocity threshold 70.
%
%
% Other m-files required: addpoints.m, noise_clean_svd.m
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis $
% @email: el.avramidis@gmail.com $
% @date: 21/05/2014 $
% @version: 1.0 $
% @copyright: MIT License

%% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Arial')
set(0,'DefaultAxesFontSize', 8)
% Change default text fonts.
set(0,'DefaultTextFontname', 'Arial')
set(0,'DefaultTextFontSize', 8)

%% Time series preprocessing 
% Eye blink removal
idx=find(ts<-25);
ts(idx)=[];

% Noise cleaning
ts=noise_clean_svd(ts,35)';

% Add new data point to the time series using interpolation
ts=addpoints(ts,dt,0.0004);
t=(0:0.0004:size(ts,1)*0.0004)';
t=t(1:end-1);

%% Find velocity threshold positions
ts_vel=gradient(ts,0.0004);
idx=[];
count=1;
threshold=vel_thres;
% find the intervals
for j=1:size(ts_vel,1)-1
    if ts_vel(j)<threshold && ts_vel(j+1)>threshold
        idx(count,1)=j+1;
        count=count+1;
    end
end

% Plot velocity threshold intervals
subplot(3,2,[1,2])
plot(t,ts, 'k');
hold on
plot(t(idx),ts(idx), 'r.');
title('Time series - threshold points')
xlabel('Time (s)')
ylabel(['Gaze angle (' char(0176) ')'])
xlim([min(t) max(t)])

%% Reconstruct intervals
for j=1:size(idx,1)-1
    intervals(j)=t(idx(j+1))-t(idx(j));
    intervals_idx(j,:)=[idx(j) idx(j+1)];
end
intervals=intervals';

m = size(intervals,1);
q = intervals;

for n=5:m-5
    q1 = q(n+3)-q(n+1);
    q2 = q(n+2)-q(n+1);
    q3 = q(n)-q(n+1);
    
    x1 = q(n+2)-q(n);
    x2 = q(n+1)-q(n-1);
    x3 = q(n)-q(n-2);
    
    x4 = q(n+1)-q(n);
    x5 = q(n)-q(n-1);
    x6 = q(n-1)-q(n-2);
    
    x7 = q(n-1)-q(n);
    x8 = q(n-2)-q(n-1);
    x9 = q(n-3)-q(n-2);
    
    deter = det([x1, x2 x3; x4, x5, x6; x7, x8, x9]);
    p1 = det([q1, x2, x3; q2, x5, x6; q3, x8, x9])/deter;
    p2 = det([x1, q1, x3; x4, q2, x6; x7, q3, x9])/deter;
    p3 = det([x1, x2, q1; x4, x5, q2; x7, x8, q3])/deter;
    
    s = [p1, p2, p3; 1, 0, 0; 0, 1, 0];
    z(n,:) = inv([1, 0, 0; 0, 1, 0; 0, 0, 1] - s)*([q(n+1), q(n), q(n-1)]' -  s*([q(n), q(n-1), q(n-2)]'));
end

for j=1:size(z,1)
    diag=[1, 1, 1]./sqrt(3);
    zz(j,:)=[z(j,:)-dot(diag,z(j,:))].*diag;
end

for j=1:size(zz,1)
    zzz(j)=[zz(j,1)^2 + zz(j,2)^2 + zz(j,3)^2];
end
zzz2=z(zzz<(0.5));

[nelements,xcenters] = hist(zzz2,0:(25/4)*0.004:200*0.004);
subplot(3,2,3)
plot(xcenters,nelements, 'k');
title('Reconstructed data histogram')
xlabel('Interval size (s)')
ylabel('Number of intervals')

% Choose UPO size for candidate selection
[~,idx]=max(nelements);

idx2=[];
for j=5:m-5
    if intervals(j)<(xcenters(idx)+(25/8)*0.004) && intervals(j)>(xcenters(idx)-(25/8)*0.004)
        idx2=[idx2;j];
    end
end

count=1;
subplot(3,2,4)
for j=idx2'
    temp_ts=ts(intervals_idx(j,1):intervals_idx(j,2));
    t=(0:0.0004:(size(temp_ts,1)-1)*0.0004)';
    plot(t,temp_ts, 'k');
    %     t(intervals_idx(j,2))-t(intervals_idx(j,1))
    hold on
    the_diffs(count)=abs(ts(intervals_idx(j,1))-ts(intervals_idx(j,2)));
    count=count+1;
end
title('Candidate upos')

% Choose UPO
[~,ii]=min(the_diffs);
temp_ts=ts(intervals_idx(idx2(ii),1):intervals_idx(idx2(ii),2));
t=(0:0.0004:(size(temp_ts,1)-1)*0.0004)';
plot(t,temp_ts, 'r', 'LineWidth', 2);
title('Candidate UPOs')
xlabel('Time (s)')
ylabel(['Gaze angle (' char(0176) ')'])

subplot(3,2,5)
t=(0:0.0004:(size(ts,1)-1)*0.0004)';
plot(t,ts, 'k');
hold on
[vv,ii]=min(the_diffs);
temp_ts=ts(intervals_idx(idx2(ii),1):intervals_idx(idx2(ii),2));
t=t(intervals_idx(idx2(ii),1):intervals_idx(idx2(ii),2));
plot(t,temp_ts, 'r');
xlim([t(1)-1 t(end)+1])
xlabel('Time (s)')
ylabel(['Gaze angle (' char(0176) ')'])
title('Selected UPO')

%% Format selected UPO
upo=ts(intervals_idx(idx2(ii),1):intervals_idx(idx2(ii),2));
subplot(3,2,6)
upos=[upo;upo;upo];
upos=upos-min(upos);
t=(0:0.0004:(size(upos,1)-1)*0.0004)';
plot(t, upos, 'k');
hold on

upos_vel=gradient(upos,0.0004);
upos_vel=noise_clean_svd(upos_vel,35)';

[v,idx]=findpeaks(upos_vel);
idx=idx(v>70);

[m_v,m_idx]=min(upos(idx(1):idx(2)));
s_p=m_idx+idx(1);
e_p=s_p+length(upo);
upo=upos(s_p:e_p);
t=t(s_p:e_p);
plot(t, upo, 'r')
xlabel('Time (s)')
ylabel(['Gaze angle (' char(0176) ')'])
title('Formatted UPO')

%% Change the position and size of the figure
pos = get(gcf, 'Position');
pos(2) = pos(2)-pos(2)/2;
pos(4) = pos(4)+pos(4)/2;
set(gcf, 'Position', pos);

end