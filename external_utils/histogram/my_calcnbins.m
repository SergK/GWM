for i=1:size(data,2)
    nbins_all(1,i) = calcnbins(data(:,i), 'all');
    nbins_middle(i,1) = calcnbins(data(:,i), 'middle');
end
