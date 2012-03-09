function [val, idx] = gwm_maxminnd(x,n,criteria)
%function [val, idx] = gwm_maxminnd(x,n,criteria)
%   INPUT:
%       - x - array or matrix to search
%       - [1:n] or [1,3,4:6] - number of max values to return
%           [val,idx] = maxnd(x,[1:15]) - return 15 max values
%       - criteria - 'max', 'min'
%   OUTPUT:
%       - val - values to return
%       - idx - indexes to return

% [num] = max(x(:));
% [x y] = ind2sub(size(x),find(x==num));

% very slow solution if we have to return multiple valeus

if strcmpi(criteria,'max')
    [xu ind]=sort(x(:),'descend');
else
    [xu ind]=sort(x(:),'ascend');
end
if numel(xu)<numel(n)  % we have less unique values than requested
    warning('We have less (max/min) values than requested');
    val = xu;idx = ind;
    return;
end
val = xu(n);
idx = ind(n);

end