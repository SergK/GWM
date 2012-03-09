function result = gwm_prepareSequence(data,groupping, last)
%%function result = gwm_sequencePrepare(data,groupping, last)
%Prepare sequence for HMM learning
%       INPUT:
%               data        - data to partition
%               groupping   - groupping variable to partition the data
%               last        - if last = 1 then {[1 x N]
%                                               [1 x N]}
%                             last = 1 for training the model
%                             last = 0 for further patritioning
%       OUTPUT:
%               result - cell(Num_of_groups,1)
%%

if nargin<3; last = 1; end;

[G,GN,GL] = grp2idx(groupping);
Nb_Grp = length(GL);    %number of groups

result = cell(Nb_Grp,1); %{N,1} cells
if last
    for i=1:Nb_Grp
        result{i,1} = data(G==i,:)';
    end
else
    for i=1:Nb_Grp
        result{i,1} = data(G==i,:);
    end
end
end