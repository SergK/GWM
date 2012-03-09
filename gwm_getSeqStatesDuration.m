function c = gwm_getSeqStatesDuration(x)
%function result = gwm_getSeqStatesDuration(data)
% Getting statistics for repeating sequences in data

%% rle part of code by Stefan Eireiner
if ~isrowvec(x), x = x'; end    % if x is a column vector, transpose
i = [ find(x(1:end-1) ~= x(2:end)) length(x) ];
data{2} = diff([ 0 i ]);        %values_length
data{1} = x(i);                 %values
%% rle2hist
% values=data{1};
% values_length=data{2};
uval=unique(data{1});
nuval=size(uval,2);    %number of unique values
c=cell(nuval,2);       %cell for values
for i=1:nuval
    c{i,1}=uval(i);
    c{i,2}=data{2}((data{1}==uval(i)));
end


end