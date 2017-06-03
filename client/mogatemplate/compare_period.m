function yout = compare_period(waveform1, waveform2)
%COMPARE_PERIOD Calculates the period difference fitness of two infantile
%nystagmus waveforms.
%
% Syntax:  yout = compare_period(waveform1, waveform2)
%
% Inputs:
%    waveform1 - The first waveform
%    waveform2 - The second waveform
%
% Outputs:
%    yout - Period difference fitness value
%
% Example:
%    yout = compare_period(sin(1:15), cos(1:25))
%    This example calculates the period difference fitness of the two
%    waveforms sin(1:15) and cos(1:25).
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% $Author: Eleftherios Avramidis $
% $Email: el.avramidis@gmail.com $
% $Date: 30/09/2012 $
% $Version: 1.0 $
% Copyright: MIT License

waveform1_size=size(waveform1(:,1),1);
waveform2_size=size(waveform2(:,1),1);
yout = abs(waveform1_size-waveform2_size);
