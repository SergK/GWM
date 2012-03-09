function [bestmodels best_models_idx best_models_vals]=gwm_selectBestModels(models,varargin)
%function bestmodels=gwm_selectBestModels(models,varargin)
%   Select best models with some 
%
%INPUT:
%     models        - Matrix of experiments, where:
%     models{nRuns,nModels} =     model   model1  model2   model13
%                                 model   model1  model2   model13
%                                 model   model1  model2   model13
%    'criteria'     - best model criteria 'loglike' (default), 'aic', 'bic', 'aicc'
%    'nBestModels'  - number of best models to return or [1,3,6] return 1st 3rd and 6th model: default (1)
%    'in Groups'    - select best models by groups (in each column)[default]

%%
[   criteria                    , ...
    nBestModels                 , ...
    inGroups                    ] ...
    = process_options(varargin  , ...
    'criteria'                  , 'loglike'                        , ...
    'nBestModels'               , 1                                , ...
    'inGroups'                  , true);

[nRuns nModels] = size(models);
if inGroups
    bestmodels = cell(1,nModels);best_models_idx = zeros(1,nModels);best_models_vals = zeros(1,nModels);
    for i=1:nModels
        [bestmodels(i) best_models_idx(i) best_models_vals(i)] = gwm_selectBestModels(models(:,i),'criteria',criteria,'nBestModels',nBestModels,'inGroups',false);
    end
    return;
end

loglike = false;

switch lower(criteria)
    case 'loglike'
        val = cellfun(@(x) x.loglike(end), models(:), 'Uniform', 1);
        loglike = true;
    case 'aic'
        val = cellfun(@(x) x.AIC, models(:), 'Uniform', 1);
    case 'bic'
        val = cellfun(@(x) x.BIC, models(:), 'Uniform', 1);
    case 'aicc'
        val = cellfun(@(x) x.AICc, models(:), 'Uniform', 1);
        
    otherwise           , error('%s is not a valid criteria type',criteria);
end % switch
val = reshape(val,nRuns,nModels);
if loglike      % if we have LogLike than best model is MAX
    [best_models_vals, best_models_idx] = gwm_maxminnd(val,nBestModels,'max');
else
    [best_models_vals, best_models_idx] = gwm_maxminnd(val,nBestModels,'min');    %best model is MIN (AIC, BIC or AICc)
end

bestmodels = models(best_models_idx);
end