function ts = scale2target(target, simulated)
%SCALE2TRAGE Scales the simulated waveform to the target one. The scaling
%is done only in the time axis and not the amplitude axis.
%
% Syntax:  [ts, endratio] = scale2target(target, simulated)
%
% Inputs:
%    target     - The target waveform
%    simulated  - The waveform to be evaluated
%
% Outputs:
%    ts          - Scaled waveform
%
% Example:
%    ts = scale2target((sin(1:15), cos(1:25))
%    This example scales the second waveform cos(1:25) to the first waveform sin(1:15)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis
% @email: el.avramidis@gmail.com
% @date: 30/09/2012
% @version: 1.0
% @Copyright: MIT License

% make them to have the same start
ts1=target;
ts2=simulated;

t1 = 0:size(ts1,1)-1;
t2 = 0:size(ts2,1)-1;

ts1=ts1(:) - ts1(1);
ts2=ts2(:) - ts2(1);

% max1 = max(ts1);
% max2 = max(ts2);
end1 = size(ts1,1);
end2 = size(ts2,1);

endratio = end1/end2;
% maxratio = max1/max2;

ts1 = [t1', ts1];
ts2 = [t2', ts2];
ts2(:,1) = ts2(:,1)*endratio;
ts = interp1(ts2(:,1),ts2(:,2),ts1(:,1),'spline');

end

