function c=rle2hist(data)
%%function c=rle2hist(data)
%Convert rle2hist
%{value 1}-->{1 2 3 3 1 1 6 4 5 6 4}
%{value 2}-->{1 2 2 3 2 1 1 2 3 2 1 2 3 4 5 6 4}
    values=data{1};
    values_length=data{2};
    uval=unique(values);
    ll=size(uval,2);    %number of unique values
    c=cell(ll,2);       %cell for values
    for i=1:ll
        c{i,1}=uval(i);
        c{i,2}=values_length((values==uval(i)));
    end
end