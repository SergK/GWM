function gwm_plot_acf(x,y,lag)
%function y=plot_acf(x,y,lag)
%Plot Autocorr function for two sequences

plot(acf(x,lag),'b-');hold on;
plot(acf(y,lag),'r-');
title('Autocorrelation Function');
end