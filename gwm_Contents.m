% THE Grid Workload Modelling tool :
% 
% /external_utils   - Additional tools from Other authors
%    /histogram - folder contains different tools for working with histogram construction
%    abic.m
%    howmany.m
%    insertrows.m
%    maxnd.m
%
%   /gwm_utils        - different helpers
%     gwm_nplot.m       - new figure plot with legend
%     gwm_plot_acf.m    - plot autocorr function for two sequences
%     gwm_plot_rows.m   - makes different plots
%     gwm_purge.m       - workspace clear utility
%     gwm_splitData     - splits data for [Training, Validation, Testing]
%           
% main folder utils
%     gwm_abic.m                    - calculates AIC, BIC, AICc values for models
%     gwm_createStochasticMatrix.m  - creates different types of stochastic matrices
%     gwm_maxmin.m                  - searches max or min N values in matrix
%     gwm_replaceValues             - replaces/removes VALUES in Matrix: default [-1]
%     gwm_selectBestmodels          - selects best models on some criteria (AIC, AICc, BIC, LL)
%     gwm_prepareSequence           - prepares sequence for HMM learning (groupping, cellwrapping, etc)

