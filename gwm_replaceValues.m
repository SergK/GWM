function data = gwm_replaceValues(data, inColumn, OldValue, NewValue)
%function data = gwm_replaceValues(data, inColumn, OldValue, NewValue)
% Replace OldValue with NewValue in inColumn
% by default we replace (CUT rows) with -1 in all columns:
%   1) gwm_replaceValues(data, 'all') - remove all rows with -1 in all Columns
%                 A =
%                      1    -1
%                     -1     2        =>  A =   3      3
%                      3     3
%   2) gwm_replaceValues(A,2,-1,100) - replace [-1] with [100] in 2nd column
%                 A =                     A =
%                      1    -1                  1      100
%                     -1     2        =>       -1      2
%                      3     3                  3      3
if nargin<4; NewValue = false;end
if nargin<3; OldValue = -1;end
if strcmpi(inColumn,'all'); all = true;else all = false; end;

if ~NewValue        % delete rows with -1
    if all
        data(sum((data==OldValue),2)>0,:) = [];
    else
        data(sum((data(:,inColumn)==OldValue),2)>0,:) = [];
    end
else
    if all
        data(data==OldValue)=NewValue;
    else
        data(data(:,inColumn)==OldValue,inColumn)=NewValue;
    end
end
end