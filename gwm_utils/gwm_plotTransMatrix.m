function gwm_plotTransMatrix(mat)
%% function gwm_plotTransMatrix(mat)
%   function plots Transition matrix
%%

nstates = size(mat,1);
imagesc(mat);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

textStrings = num2str(mat(:),'%0.3f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:nstates);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2),'FontSize',14);  %# Change the text colors
set(gca,'XTick',1:nstates,'YTick',1:nstates,'TickLength',[0 0],'XAxisLocation','top','FontSize',18,'FontWeight','bold');
end