function [AIC,BIC,AICc,nParam] = gwm_abic(model, nbdata, logLike)
%% function [AIC,BIC,AICc,nParam] = gwm_abic(model, nbdata, logLike)
% INPUT:
%       model or (Number of params): model to evaluate number of parameters
%       nbdata : number of data
%       logLike : log-Likelihood (if omitted than we get in from model.loglike)
% OUTPUT:
%       AIC : Akaike Information Criterion
%       BIC : Bayesian Information Criterion
%       AICc : Akaike Information Criterion with correction
%       nParam : Number of parameters

%% if the first parameter will be the simple number
if isnumeric(model)
    [AIC,BIC,AICc] = abic (logLike, model, nbdata);
    return;
end;%if
if nargin<3; logLike = model.loglike(end);end;

%% Init section
nParam = model.nstates*(model.nstates-1)+...       %Transition Matrix N*(N-1)
         model.nstates-1;                          %pi vector N-1
%% Main calculus
switch lower(model.type)
    case 'gauss'
        %by default we have FULL cov matrix   (using kmeansInitMixGauss)
        %nParam = k*obj.NDimensions * (obj.NDimensions+1)/2;
        nParam = nParam + model.d * model.nstates * (model.d + 1)/2;    %Sigma
        nParam = nParam + model.nstates - 1 + model.nstates * model.d;  %mu, weight
    case 'mhmm'
        %% part for calculating number of Sigmas
        switch lower(model.cov_type)
            case 'full'             
                %nParam = k*obj.NDimensions * (obj.NDimensions+1)/2;
                nParam = nParam + model.d * model.nstates * model.nmix * (model.d + 1)/2;
            case 'diag'
                %nParam = obj.NDimensions * k;
                nParam = nParam + model.d * model.nstates * model.nmix;
            case 'spherical'
                %nParam = k;    %one parameter per component (mixture)
                nParam = nParam + model.nstates * model.nmix;
            otherwise, error('%s is not a valid output type of model Initialization');
        end
        %% common part  nParam = nParam + weight_params+mu_params
        %nParam = nParam + k-1 + k * obj.NDimensions;
        nParam = nParam + model.nstates * model.nmix - 1 + model.nstates * model.nmix * model.d;
        %% mixmat parameter counting
        if model.nmix > 1
            if iscell(model.mixmat)
                error ('Non stationary mixmat is not yet implemented');
            else
                nParam = nParam + model.nstates * (model.nmix-1);
            end
        end
        
    case 'mixgausstied'  , %error('%s not implemeted yet',model.type);
    case 'discrete'      , nParam = nParam + ( model.emission.nstates*(model.emission.nObsStates - 1) );
    case 'student'       , error('%s not implemeted yet');
    case 'hsmm'          ,
        nParam = nParam + model.nstates*(size(model.P,2)-1) + model.nstates*(size(model.B,2)-1);   %+[P matrix]+[B matrix]-> M^2 +MK +MD
    otherwise           , error('%s is not a valid output distribution type');
end

[AIC,BIC,AICc] = abic (logLike, nParam, nbdata);

end