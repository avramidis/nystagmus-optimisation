function normalized = normalize_var(array, x, y)
%NORMALIZE_VAR Normalise a vector to given lower and upper bounds.
%
% Syntax:  normalized = normalize_var(array, x, y)
%
% Inputs:
%   array       - Unnormalised vector
%   x           - Normalisation lower bound
%   y           - Normalisation upper bound
%
% Outputs:
%   normalized  - Normalised vector
%
% Example:
%    normalized = normalize_var(ts, 0, 1)
%    This example normalises the ts vector to the range [0, 1] and stores
%    the normalised vector to variable normalized.
%
% Other m-files required: none
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

% Normalize to [0, 1]:
m = min(array);
range = max(array) - m;
array = (array - m) / range;

% Then scale to [x,y]:
range2 = y - x;
normalized = (array*range2) + x;
