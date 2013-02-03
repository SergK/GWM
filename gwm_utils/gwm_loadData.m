function data = gwm_loadData(DataSourceName, varargin)
%function x = gwm_loadData(DataSourceName, varargin)
%   FUNCTION is used:
%                     - to load data (with format {'runtime','h','dm','dw','dy','m','wy';});
%                     - to remove extreme values (One extreme value by default), can be set by 'nExtremeVals',Value
%                     - to group values by some time:
%                           {'h','dm','dw','dy','m','wy'}
%                           h - hour
%                           dm - day of month
%                           dw - day of week
%                           dy - day of year (default)
%                           m - month
%                           wy - week of year
%                           hy - hour of year
%
%  INPUT:  DataSourceName - name of file with data:
%           'auver', 'das2', 'g5000', 'lcg', 'nordu', 'shar'
%  EXAMPLE:
%       data = gwm_loadData(DataSourceName, 'nExtremeVals', 1, 'group_by', 'dw')
%%
[   group_by                    , ...
    nExtremeVals                ] ...
    = process_options(varargin  , ...
    'group_by'                 , 'dy', ...
    'nExtremeVals'             , 1);

switch(lower(DataSourceName))
    case 'auver'
        load full_Runtime_AuverGrid;
        nExtremeVals = 16;
    case 'das2'
        load full_Runtime_DAS2;
        nExtremeVals = 2;
    case 'g5000'
        load full_Runtime_Grid5000;
        nExtremeVals = 4;
    case 'lcg'
        load full_Runtime_LCG;
        nExtremeVals = 0;
    case 'nordu'
        load full_Runtime_NorduGrid;
        nExtremeVals = 5;
    case 'shar'
        load full_Runtime_SHARCNET;
        nExtremeVals = 1;
    otherwise
        error('%s - is not supported data source',DataSourceName);
end
x = gwm_replaceValues(x,'all');     %remove -1 values from all
if nExtremeVals>0
    [~,idx] = gwm_maxminnd(x(:,1),1:nExtremeVals,'max');     %remove rows with EXTREME values
    x(idx,:) = [];
end

%% we just add this functionality. So we already have grouped data by some criteria
% group by days          ---------> x(:,5)
% data = gwm_prepareSequence(x(:,[1]),x(:,5),1);

switch lower(group_by)
    case 'h'
        data = gwm_prepareSequence(x(:,[1]),x(:,2),1);
    case 'dm'
        data = gwm_prepareSequence(x(:,[1]),x(:,3),1);
    case 'dw'
        data = gwm_prepareSequence(x(:,[1]),x(:,4),1);
    case 'dy'
        data = gwm_prepareSequence(x(:,[1]),x(:,5),1);
    case 'm'
        data = gwm_prepareSequence(x(:,[1]),x(:,6),1);
    case 'wy'
        data = gwm_prepareSequence(x(:,[1]),x(:,7),1);
    case 'hy'
        % day*24+hour
        x(:,8) = x(:,5)*24+x(:,2);
        data = gwm_prepareSequence(x(:,[1]),x(:,8),1);
    otherwise
        error('%s - is not supported Group by option',group_by);
end