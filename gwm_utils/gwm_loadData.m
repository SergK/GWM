function data = gwm_loadData(DataSourceName)
%function x = gwm_loadData(DataSourceName)
%   FUNCTION is used:
%                     - to load data;
%                     - to remove extreme values;
%                     - to group values by days
%  INPUT:  DataSourceName - name of file with data:
%           'auver', 'das2', 'g5000', 'lcg', 'nordu', 'shar'

nExtremeVals = 1;   %Number of extreme values to cut
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
data = gwm_prepareSequence(x(:,[1]),x(:,5),1);


end