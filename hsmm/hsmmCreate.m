function [model]=hsmmCreate(O,M,D,K,varargin)
%function [A,B,P,PAI,Vk,O,K]=hsmmCreate(O,M,D,K,varargin)
% Creates model WITHOUT EM-iteration
% 
%   Usage: [A,B,P,PAI,Vk,O,K]=hsmmInitialize(O,M,D,K,init_type)
%
%   O - observation
%   M - Number of States
%   D - Duration
%   K - Max value of Observation
%   init_type (Transition matrix):
%       - 'uniform'         <-default
%       - 'rand' 
%       - 'rand-zero-diag'  <-random with zero diag
%       - 'left-right'      <-Bakis (full jump example)
%                     A =
%                         0.2025    0.1221    0.6754
%                              0    0.6427    0.3573
%                              0         0    1.0000
%       - 'unif-zero-diag'       <-uniform with zero diag
%

    %%
[   init_type,          ...
    jump_step     ] ...
    = process_options(varargin  , ...
    'init_type'                 , 'uniform',    ...     %using uniform init by default
    'jump_step'                 , M-1             ...     % 0 - full jump (default)
    );                   

%Data check and convert it to column form
if isrowvec(O)
    O=O';
end



    switch lower(init_type)
        case 'uniform'
            PAI=ones(M,1);
            PAI=PAI./sum(PAI);           %the initial probability
 
            A=ones(M);
            A=A./(sum(A,2)*ones(1,M));      %The Transition Probability Matrix of active states
            
            P=repmat((1:D).^2,M,1);
            % My edition
            %    P=repmat((D:-1:1).^2,M,1);
            P=P./(sum(P,2)*ones(1,D));
            %%
        case 'rand'
            PAI=mkStochastic(rand(M,1));
            A=mkStochastic(rand(M,M));
            P=mkStochastic(rand(M,D));
            %%
        case 'rand-zero-diag'
            PAI = rand(M,1);
            PAI(1) = 0;         % we cannot start from this place because of zero diag
            PAI=mkStochastic(PAI);
            A=mk_stochastic_diag(rand(M,M));
            P=mkStochastic(rand(M,D));
        case 'left-right'
            if jump_step > (M-1)
                warning('Jump step could not be greater than NStates-1. Converting jump_step to NStates-1');
                jump_step = M-1;
            elseif jump_step < 1
                warning('Jump step could not be less than 1. Converting jump_step to 1');
                jump_step = 1;
            end
            PAI = zeros(M,1);
            PAI(1) = 1;
            A=mkStochastic(tril(triu(rand(M,M),0),jump_step));
            P=mkStochastic(rand(M,D));
        case 'unif-zero-diag'
            PAI=ones(M,1);
            PAI(1)=0;           % we cannot start from this place because of zero diag
            PAI=PAI./sum(PAI);
            A=ones(M);
            A(eye(size(A))==1)=0;
            A=A./(sum(A,2)*ones(1,M));      %The Transition Probability Matrix of active states
            P=repmat((1:D).^2,M,1);
            P=P./(sum(P,2)*ones(1,D));
        otherwise
            %%we use uniform distribution init by deafault
            PAI=ones(M,1);
            PAI=PAI./sum(PAI);           %the initial probability
            A=ones(M);
            A=A./(sum(A,2)*ones(1,M));      %The Transition Probability Matrix of active states
            P=repmat((1:D).^2,M,1);
            P=P./(sum(P,2)*ones(1,D));
            init_type = 'uniform';
    end
    %[O1,Vk1]=canonizeLabels(O);
    [x,I]=sort(O);
    tmp=([1;diff(x)]~=0);
    Vk=x(tmp);                  %observable values
    Num=diff(find([tmp;1]==1));
    if length(Vk)<K             %if after canonization we have max smaller
        K=length(Vk);
    end
    while length(Vk)>K
        [y,J]=min(diff(Vk));
        Vk(J+1)=(Vk(J)*Num(J)+Vk(J+1)*Num(J+1))/(Num(J)+Num(J+1));
        Vk(J)=[];
        Num(J+1)=Num(J+1)+Num(J);
        Num(J)=[];
    end
    Num=cumsum(Num);
    tmp(:)=0;
    tmp([1;Num(1:end-1)+1])=1;
    O(I)=cumsum(tmp);           %indexes of observable values
%%
%%Poisson?    
    lambda=(max(O)-min(O))/M;
    lambda=(min(O)+lambda/2):lambda:max(O);
    for i=1:K
        ss(i)=sum(log(1:i));
    end
    B=exp(log(lambda')*(1:K)-ones(M,1)*ss-lambda'*ones(1,K));
    B=B+(max(B')'.*0.01)*ones(1,K);
    B=B./(sum(B,2)*ones(1,K));      %The observation symbol probability distribution

    %%
    %function [A,B,P,PAI,Vk,O,K]=hsmmCreate(O,M,D,K,varargin)
    model.PAI=PAI;
    model.A=A;
    model.B=B;
    model.P=P;
    model.Qest=[];              % not yet initialized
    model.lkh=[];               % not yet initialized
    model.ll=[];                % not yet initialized
    model.Vk=Vk;
    model.O=O;
    model.K=K;
    model.init_type = init_type;
    model.type = 'hsmm';
    model.nstates = M;
end
