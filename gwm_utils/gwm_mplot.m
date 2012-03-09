function h = gwm_mplot(cell_to_plot, varargin)
%function gwm_mplot(cell_to_plot,style,multiple)
% OUTPUT:
%   h               - the list of plot objects
%   h{i}            - returns in case of cell_to_plot is used with group options
%
% INPUT:
%   cell_to_plot    -     array {i,:}(plotting by rows)
%                   1) {[1......N]
%                       [1......N]}
%                         or ({a,b,c,d,...}) cell for plotting
%                   2) {[1...N],[1..N],[1......N]}
%                   3) {[group1],[group2]...[groupN]}, group has the same format as 1),2)
%                      you have to place 'plot_type' as 'group'
%                               Examples:   {[ll ll1],[ll2]}
%                                           {[ll] [ll1] [ll2] [ll3]}
%                                           h= gwm_mplot({am1;mm1;rm1},'plot_type','group')
%
%   'plot_type':    - 'foreach'     - ALL plot for ALL figures with ONE color (default);
%                   - 'single'      - ALL plot on ONE figure with ONE color
%                   - 'mult'        - ALL plot on ONE figure with MANY colors;
%                   - 'group'       - plot like 'mult' but each group with the same color;
%                   - 'groupiscol'  - plotting like 'group' where each group is in Columns
%   'style':        - 'b-' the same styles as for plot
%   'showLegend'    - true       - Show the legend; false (default)

%%
[   plot_type                    , ...
    showLegend                   , ...
    style                       ] ...
    = process_options(varargin  , ...
    'plot_type'                 , 'single'                        , ...
    'showLegend'                , false                           , ...
    'style'                     , 'b-');

if ~iscell(cell_to_plot)
    if isvector(cell_to_plot)
        cell_to_plot = {rowvec(cell_to_plot)};
    else % we have matrix, than plot by rows
        cell_to_plot = mat2cellRows(cell_to_plot);
    end
end

if cellDepth(cell_to_plot)>1
    plot_type = 'group';
end
%%
switch lower(plot_type)
    case 'mult'
        s = prepareStyles(cell_to_plot);
        figure;hold on;
        h = cellfun(@(data,line_style) plot(data,line_style), cell_to_plot, s);
        hold off;
    case 'single'
        hold on;
        h = cellfun(@(data)plot(data,style),cell_to_plot);
        hold off;
    case 'foreach'
        h = cellfun(@(data)nplot(data,style),cell_to_plot);
        hold off;
    case 'group'
        % we have the following format {{}{}{}{}}
        style_for_groups = prepareStyles(cell_to_plot);    % make each style for group
        h = cell(1,numel(cell_to_plot));
        figure;hold on;
        for i=1:numel(cell_to_plot)
            h{i} = gwm_mplot(cell_to_plot{i},'plot_type','single','style',style_for_groups{i});
        end;
        hold off;
        h_group = cellfun(@(x) x(1), h(:), 'Uniform', 1)';
        legend_txt = arrayfun(@(x)sprintf('%s%d','group',x),[1:numel(h_group)],'unif',0);
        legend(h_group,legend_txt);
    case 'groupiscol'
        h = gwm_mplot(mat2cellRows(cell_to_plot'),'plot_type','group');
    otherwise           , error('%s is not a valid plot_style',plot_type);
end % switch
if showLegend
    legend('toggle');
end
end

%% helper for plotting multiple figures per plot
function h = nplot(data,style)
figure;
h = plot(data,style);
end

%% helper for plotting with different styles
function s = prepareStyles(cell_to_plot)
[~, ~, ~, str] =  gwm_plotStyles();
%% if  we have mor then 15 rows to plot we have to repmat str styles
num_of_rows = numel(cell_to_plot);
s = str(1:num_of_rows)';
s = s(1:num_of_rows)';
end
