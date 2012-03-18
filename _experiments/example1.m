%% The 1st example: shows how to make experiments:

%% we have to load data
data = gwm_loadData('auver');
% split data for test and train
[Train,Test] = gwm_splitData(data,[0.8,0.2]);


%% define some parameters of the future models
nStates = 2;        % number of states
nMix = 1;           % number of mixtures per states

%% define some runtime options
verbose = false;    % show additional information while running
nRuns = 6;          % how 
nModels = 8;        % number of models to generate
models = cell(nRuns,nModels);       % cell matrix to store models
models_ll = cell(nRuns,nModels);    % cell matrix to store loglikes

% prepare parallel execution
isOpen = matlabpool('size') > 0;
if ~isOpen
    matlabpool(3);
end;

%% Model Initialization 
% we support the following types of models with different types of initialization:
%   - hmm - hidden Markov Model:
%       see also: hmmFit with init options 'gauss', 'mixGaussTied', 'discrete', or 'student'
%   - mhmm - hidden Markov Model with Guss Mixtures:
%       see also: mhmmFit
%   - hsmm - hidden semi-Markov Model
%       see also: hsmmFit
% Each model has different type of params please see also section

%% Let's make some simple model with random init param initialization
for j = 1:nModels
    fprintf('\n\t\t(%d of %d). Number of states = %d\n',j,nModels,(nStates+j)*nMix);
    % [trans0, pi0] = gwm_createStochasticMatrix(nStates+j,'MatrixType', 'uniform');
    parfor i=1:nRuns
        fprintf('nRuns = %d',i);
        [models{i,j},models_ll{i,j}] = hmmFit(data,nStates+j,'gauss','verbose',verbose);
    end
end
%% The result
% we have model{i,j} cell matrix where and the same loglikes matrix:
%   j---> nModels(nStates) ---->
%   |
%   |
%  nRuns
%   |
% 

%% Let's take the best models (based on some criteria, for exmpl. LogLike, AIC, BIC, AICc )
% the default is loglike
[bestmodels best_models_idx best_models_vals] = gwm_selectBestModels(models);

%% Plotting results
% we can plot transition matrix for the best models
for i=1:nModels
    figure;gwm_plotTransMatrix(bestmodels{i}.A);
end
placeFigures;
% or even Loglikes
figure;plot(best_models_vals,'ro-');

%% or Just use show experimental result
[logLikes, best_models_Loglike_val, best_models_BIC_val] = gwm_showExperimentResult(models);
