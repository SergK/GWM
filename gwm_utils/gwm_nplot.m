function gwm_nplot(x,varargin)
%function gwm_nplot(x,'name of data')
%   x               -   data to plot
%   'leg'           -   legend
%   'logY'          -   false (default)
%   'style'         -   'b-' default

[   leg                         , ...
    logY                        , ...
    style                       ] ...
    = process_options(varargin  , ...
    'leg'                       , 'data'    , ...
    'logY'                      , false     , ...
    'style'                     , 'b-');

if logY
    figure;semilogy(x,style);
else
    figure;plot(x,style);
end
set(legend(leg),'Interpreter','none');
end