function [logLikes, best_models_Loglike_val, best_models_BIC_val] = gwm_showExperimentResult(models, varargin)
%[logLikes, best_models_Loglike_val, best_models_BIC_val] = gwm_showExperimentResult(models)
% The function plots LogLike for group of experiments
% INPUTS:
%     models        - Matrix of experiments, where:
%     models{nRuns,nModels} =     model   model1  model2   model13
%                                 model   model1  model2   model13
%                                 model   model1  model2   model13
%     'title'       - [] Title to plot on figures
% OUTPUTS:
%     logLikes                  - Loglikes for each model in matrix;
%     best_models_Loglike_val   - best Loglike value in each group of experiment
%     best_models_BIC_val       - best BIC value in each group of experiment
%

[title_text] = process_options(varargin, ...
    'title'     , [] );   

%% get experements results (Number of runs per models and number of models)
[nRuns nModels] = size(models);

%%take LogLikes info from each models
logLikes = cellfun(@(x) x.loglike, models(:), 'Uniform', 0);
logLikes = reshape(logLikes,nRuns,nModels);

%% building groups for group plotting (each group is in Column)
group_plot = cell(1,nModels);
mylegend = cell(1,nModels);
for i=1:nModels
    group_plot{i} = logLikes(:,i);
    if isempty(models{1,i}.nmix)
        mylegend{i} = sprintf('%d-states',models{1,i}.nstates);
    else
        mylegend{i} = sprintf('%d-states;%d-mix',models{1,i}.nstates,models{1,i}.nmix);
    end
end
h = gwm_mplot(group_plot,'plot_type','group');title(sprintf('%s (%s)',title_text,'Plot by groups'));
r = cellfun(@(x) x(1),h);                       %we get the first handle in each group
legend(r,mylegend,'Location','SouthEast');      %legend([h1 h2],{'label1', 'label2'});
xlabel('Iteration');ylabel('LogLike');

%% select best model on LogLike in each group (max ll in each column)
%return index of the best model in each column(bootstrap)
[best_models_Loglike_val best_models_idx] = max(cellfun(@(x) x(end),logLikes),[],1);   %return index of the best model in each column(bootstrap)
best_models_Loglike = cell(nModels,1);
best_models_BIC_val = zeros(1,nModels);
for i=1:nModels
    best_models_Loglike(i,1) = logLikes(best_models_idx(i),i);      %(row,col)
    if isempty(models{best_models_idx(i),i}.nmix)
        mylegend{i} = sprintf('%d-states;(LogLike=%d)',models{best_models_idx(i),i}.nstates,...
                                                            models{best_models_idx(i),i}.loglike(end));
    else
    mylegend{i} = sprintf('%d(%d)-states(mix);(LogLike=%d)',models{best_models_idx(i),i}.nstates,...
                                                            models{best_models_idx(i),i}.nmix,...
                                                            models{best_models_idx(i),i}.loglike(end));
    end
    best_models_BIC_val(i) = models{best_models_idx(i),i}.BIC;                                                   
end
gwm_mplot(best_models_Loglike,'plot_type','mult');title(sprintf('%s (%s)',title_text,'The best (max Loglike) models for each groups'));
legend(mylegend,'Location','SouthEast');
xlabel('Iteration');ylabel('LogLike');

%% plot loglike evolution
figure;
plot([models{1}.nstates:models{1,nModels}.nstates],best_models_Loglike_val,'ro-');title(sprintf('%s (%s)',title_text,'LogLike evolution'));
xlabel('nStates');ylabel('LogLike');

%% plot BIC evolution for the best (max LogLike) models
figure;
plot([models{1}.nstates:models{1,nModels}.nstates],best_models_BIC_val,'ro-');title(sprintf('%s (%s)',title_text,'BIC evolution'));
xlabel('nStates');ylabel('BIC');

end