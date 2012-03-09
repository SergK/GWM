function [styles, colors, symbols, str] =  gwm_plotStyles()
% Use plot(x,y,str{i}) to print in i'th style
% We use colors and linestyles, not markers

% This file is based on the plotColor example from pmtk3.googlecode.com

%colors =  ['b' 'r' 'k' 'g' 'c' 'y' 'm'];
%no yellow color yet
colors =  ['b' 'r' 'k' 'g' 'c' 'm'];
symbols = ['o' 'x' '*' '>' '<' '^' 'v' '+' 'p' 'h' 's' 'd'];
styles = {'-', ':', '-.', '--' };
nColors = length(colors);
nSymbols = length(symbols);
nStyles = length(styles);
str = cell(nColors, nSymbols, nStyles);
for i=1:nColors
    for j = 1:nSymbols
        %str{i} = sprintf('-%s%s', colors(i), symbols(i));
        for k = 1:nStyles
            str{i,j,k} = sprintf('%s%s%s', colors(i), symbols(j), styles{k});
        end
    end
end
str = reshape(str,1,nColors*nSymbols*nStyles)';
perm = randperm(numel(str));
str   = str(perm);
end
