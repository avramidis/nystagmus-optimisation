function [tsout,sgvec]=noise_clean_svd(tsin,edim,projdim)
%function [tsout,sgvec]=noise_clean_svd(tsin,edim,projdim)
%Ozgur E. Akman                     12/06/13
%Routine to implement the noise cleaning method of Schreiber et al, using the global (rather than local SVD).
%
%INPUTS: tsin -> input time series.
%        edim -> chosen embedding dimension (should be sufficiently large).
%        projdim -> the number of singular values after which to truncate the SVD expansion (OPTIONAL: The default value is taken as that
%                   which captures 99.9% of the variance).
%
%OUTPUTS: tsout -> output time series. 
%         sgvec -> singular values (OPTIONAL).
%
%ROUTINES CALLED: None.
%

%NOISE_CLEAN_SVD Routine to implement the noise cleaning method of 
%                Schreiber et al, using the global (rather than local SVD)
%
% Syntax:  [tsout,sgvec]=noise_clean_svd(tsin, edim, projdim)
%
% Inputs:
%    tsin       - Input time series.
%    edim       - Chosen embedding dimension (should be sufficiently large)
%    projdim    - The number of singular values after which to truncate the 
%                 SVD expansion (OPTIONAL: The default value is taken as that
%                 which captures 99.9% of the variance)
%
% Outputs:
%    tsout      - output time series. 
%    sgvec      - singular values (OPTIONAL)
%
% Example:
%    [tsout,sgvec]=noise_clean_svd(ts_in, 35)
%    This example reduces the noise int he ts_in time series with 35
%    embedding dimention.
%
% Other m-files required: none
% Subfunctions: embeddts, diag_avg
% MAT-files required: none
%
% See also: Schreiber, T., & Grassberger, P. (1991). A simple noise-reduction 
% method for real data. Physics Letters A, 160(5), 411–418.
% E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
%
% @author: Ozgur E. Akman $
% @email: O.E.Akman@exeter.ac.uk $
% @date: 12/06/13 $
% @version: 1.0 $
% @copyright: MIT License

%Subtract the mean of the time series.

mval=mean(tsin);
tsin=tsin-mval;

%Embedd the time series.

mat=embeddts(tsin,edim);

%Perform the SVD.

[smat,sgmat,cmat]=svd(mat,0);
sgvec=diag(sgmat);

%Truncate.

if nargin<3
    chkvar=cumsum(sgvec.^2)/sum(sgvec.^2);
    in=find(chkvar>0.999);
    projdim=in(1);
end

sgmat=diag([sgvec(1:projdim)' zeros(1,edim-projdim)]);
sgvec=sgvec/sqrt(length(tsin));

%Project the data.

projmat=smat*sgmat*cmat';

%Average across diagonals to obtain the noise-cleaned time series.

tsout=diag_avg(projmat);

%Restore the mean.

tsout=tsout+mval;

%-------------------------------------------------------------%
%----------------------Subfunctions---------------------------%
%-------------------------------------------------------------%

%Subfunction to embedd the time series.

function matout=embeddts(datin,eval)

n=length(datin);
numr=n-eval+1;
indvec=1:eval;
indmat=repmat(indvec,[numr 1]);
smat=diag(0:numr-1)*ones(numr,eval);
indmat=smat+indmat;
matout=datin(indmat);

%-------------------------------------------------------------%

%Subfunction to average across diagonals. 

function datout=diag_avg(matin)

[r,c]=size(matin);
matinP=spdiags(matin(:,end:-1:1));
matinP=matinP(:,end:-1:1);
datout=mean(matinP);

%End points.

epvec=[1:c c*ones(1,length(datout)-2*c) c:-1:1];
epvec=c./epvec;
datout=datout.*epvec;