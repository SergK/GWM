function gwm_nplot(x,varargin)
%function gwm_nplot(x,'name of data')
%   x - data to plot
%   'name of data' - legend

figure;plot(x);
if nargin>1
    h = legend(varargin{:},1);
else
    h = legend('data');
end
set(h,'Interpreter','none');
end