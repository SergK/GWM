function gwm_plot_rows(x,on_the_same,varargin)

%%function gwm_plot_rows(x,on_the_same,varargin)
%   x - data to plot
%   on_the_same - do plot on the same figure (true | false)
%   'plot' - simple plot
%   'norm' - for norm plot
%   'acf' - for acf plot
%   'hist' - for acf plot
%   'cdf' - for acf plot
    x_size=rows(x);
    if nargin==2
        init_type='plot';
    else
        init_type = varargin{1};
    end
    hold on;
   [styles, colors, symbols, str] =  plotColors();
    switch lower(init_type)
        case 'plot'
            for i=1:x_size
                if ~on_the_same; figure(i);plot(x(i,:));
                else
                plot(x(i,:),str{i});
                end;
            end
        case 'acf'
            for i=1:x_size
                if ~on_the_same; figure(i);plot(acf(x(i,:),round(sizePMTK(x(i,:))/3)));
                else
                plot(acf(x(i,:),round(sizePMTK(x(i,:))/3)),str{i});
                end;
            end
        case 'norm'
            for i=1:x_size
                if ~on_the_same; figure(i);end;
                normplot(x(i,:));
            end
        case 'hist'
            for i=1:x_size
                if ~on_the_same; figure(i);end;
                hist(x(i,:),30);
            end
        case 'cdf'
            for i=1:x_size
                if ~on_the_same; figure(i);end;
                cdfplot(x(i,:));
            end
        otherwise
            for i=1:x_size
                if ~on_the_same; figure(i);plot(x(i,:));
                else
                plot(x(i,:),str{i});
                end;
            end
    end
    placeFigures;
    hold off;
end