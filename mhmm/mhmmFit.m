function [model, loglikHist] = mhmmFit(data, nstates, nmix, varargin)
%function [model, loglikHist] = mhmmFit(data, nstates, nmix, varargin)
%% Fit an hmm model with mixture of gaussian (MoG)
%   INPUT:
%           - data - data(i,:); data{ex}(:,t) or data(:,t,ex) if all sequences have the same length
%           - nstates - Number of states
%           - nmix - Number of mixtures per state (if nmix==1 we don't care about mixmat0)
%           varargin:
%               - 'pi0'
%               - 'trans0'
%               - 'mu0'
%               - 'Sigma0'
%               - 'mixmat0'
%               - 'cov_type'   'full'(default), 'diag' or 'spherical'
%               - 'init_type'  'random'(default), 'manual', 'auto'
%               - 'max_iter'   default=100;
%               - 'useBuiltInKmeans' - (1 - use built-in kmeans ; 0 - use mixGaussFit PMTK(default)) 
%               - 'verbose' - (1 - be verbose; 0 - silent mode (default)
% data(O,T,nex):
%                   O = 8;          %Number of coefficients in a vector (data dimention)
%                   T = 420;        %Number of vectors in a sequence
%                   nex = 1;        %Number of sequences
% See also hmmFit

% This file is based on the code from pmtk3.googlecode.com

if ~iscell(data)
    if isvector(data) % scalar time series
        data = rowvec(data);
    end
    data = {data};
end

[   pi0                         , ...
    trans0                      , ...
    mu0                         , ...
    Sigma0                      , ...
    mixmat0                     , ...
    model.cov_type              , ...
    model.init_type             , ...
    max_iter                    , ...
    useBuiltInKmeans            , ...
    verbose                     ] ...
    = process_options(varargin  , ...
    'pi0'                       , []                        , ...
    'trans0'                    , []                        , ...
    'mu0'                       , []                        , ...
    'Sigma0'                    , []                        , ...
    'mixmat0'                   , []                        , ...
    'cov_type'                  , 'full'                    , ...
    'init_type'                 , 'random'                  , ...
    'max_iter'                  , 100                       , ...
    'useBuiltInKmeans'          , 0                         , ...
    'verbose'                   , true);

model.nstates = nstates;
model.type = 'mhmm';
model.nmix = nmix;
stackedData = cell2mat(data');
[d T] = size(stackedData);
model.d = d;    %data dimension

%% Mixture weight init
if nmix>1
    mixmat = mkStochastic(rand(nstates,nmix));
else
    mixmat = [];
end

%% MixGaussInit. Helper for Initialization of starting values
if useBuiltInKmeans  %mixModel is used in auto mode
    [mu, Sigma, ~, mixModel] = mixgauss_init(nstates*nmix, stackedData, model.cov_type);
else
    mixModel = mixGaussFit(stackedData', nstates*nmix,  'verbose', false, 'maxIter', 200, 'nrandomRestarts',1);
    mu = mixModel.cpd.mu;
    %Sigma = mixModel.cpd.Sigma;
    Sigma = bsxfun(@plus, mixModel.cpd.Sigma, eye(model.d)); % regularize MLE
end
mu = reshape(mu, [d nstates nmix]);
Sigma = reshape(Sigma, [d d nstates nmix]);

%% Different init_type
switch lower(model.init_type)
    case 'random'
        pi = normalize(rand(nstates,1));
        A = mkStochastic(rand(nstates,nstates));
        
    case 'auto'
        
        %% mixGaussInferLatent (model, stackedData);
        if useBuiltInKmeans
            post = gmmpost(mixModel,stackedData');
        else
            post = mixGaussInferLatent(mixModel, stackedData');
        end
        [~,z] = max(post,[],2);
        z = colvec(z);
        
        %% if we have nmix>1 we have to compress more states wih less
        % A =1 2 3 4 5 6  - (nstates*nmix)
        % wrap in A to nstates
        if nmix > 1
            rA = 1:nstates*nmix;
            rA = reshape(rA, [nstates nmix]);
            for i=1:nstates
                z(ismember(z,rA(i,:)))=i;
            end
        end
        %%
        A = accumarray([z(1:end-1), z(2:end)], 1, [nstates, nstates]); % count transitions
        A = normalize(A + ones(size(A)), 2);       % regularize
        seqidx   = cumsum([1, cellfun(@(seq)size(seq, 2), {stackedData})]);
        pi       = histc(z(seqidx(1:end-1)), 1:nstates);
        pi = normalize(pi + ones(size(pi))); % regularize
        
    case 'manual'
        pi = pi0;
        A = trans0;
        
        if ~isempty(mixmat0)
            mixmat = mixmat0;
        end     % else we have already defined mixmat with random values
        
        if ~isempty(mu0) && ~isempty(Sigma0)
            mu = mu0;Sigma = Sigma0;
        end
    otherwise           , error('%s is not a valid Init type of model',model.init_type);
end
model.pi_Prior = pi;
model.A_Prior = A;

%% Begin learning
[loglikHist, model.pi, model.A, model.mu, model.Sigma, model.mixmat] = ...
    mhmm_em(data, pi, A, mu, Sigma, mixmat, 'max_iter', max_iter,'verbose',verbose, 'cov_type', model.cov_type);
model.loglike = loglikHist;

%% Calculating AIC,BIC,AICc, nParams
[model.AIC, model.BIC, model.AICc, model.nParam] = gwm_abic(model, length(stackedData));
end