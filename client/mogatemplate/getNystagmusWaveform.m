function osc = getNystagmusWaveform(ts)
%GETNYSTAGMUSWAVEFORM Finds the nystagmus waveform for a give time series
%
% Syntax:  osc = getNystagmusWaveform(ts)
%
% Inputs:
%   ts      - Nystagmus time series
%
% Outputs:
%   osc     - Nystagmus waveform
%
% Example:
%    osc = getNystagmusWaveform(ts)
%    This example extracts and saves to variable osc the waveform of the 
%    nystagmus time series ts. If there is no oscillatory waveform then the 
%    osc variable is set to 0.
%
% Other m-files required: normalize_var.m
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis $
% @email: el.avramidis@gmail.com $
% @date: 29/05/2017 $
% @version: 1.0 $
% @copyright: MIT License

ts=ts-min(ts);

normalized = normalize_var(ts, 0, 1);

% @todo Develop a better method for finding the peaks. One peak for each
% period. The method used in the upoextraction method could be examined for
% this perpose.
[pks2,locs2] = findpeaks(normalized.*(-1));
pks2=pks2.*(-1);

locs2=locs2(pks2<=0.2);

if length(locs2)<3
    osc=0;
    return;
end

try
    osc=ts(locs2(end-1):locs2(end));
    osc=osc-min(osc);
catch
    osc=0;
end

end
