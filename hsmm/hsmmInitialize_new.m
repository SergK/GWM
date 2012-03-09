function [A,B,P,PAI,Vk,O,K]=hsmmInitialize_new(O,M,D,K,varargin)
% 
% Author: Shun-Zheng Yu
% Available: http://sist.sysu.edu.cn/~syu/Publications/hsmmInitialize.m
% 
% To initialize the matrixes of A,B,P,PAI for hsmm_new.m, to get 
% the observable values and to transform the observations O
% from values to their indexes.
%
% Usage: [A,B,P,PAI,Vk,O,K]=hsmmInitialize(O,M,D,K,init_type)
%
%   O - observation
%   M - Number of States
%   D - Duration
%   K - Max value
%   init_type - 'uniform' or 'random' initialization default value is UNIFORM
%
%  This program is free software; you can redistribute it and/or
%  modify it under the terms of the GNU General Public License
%  as published by the Free Software Foundation; either version
%  2 of the License, or (at your option) any later version.
%  http://www.gnu.org/licenses/gpl.txt
%

%     if (nargin<5) 
%         init_type='uniform';
%     else
%         init_type=varargin{1};
%     end
    %%
[   init_type ] ...
    = process_options(varargin  , ...
    'init_type'                 , 'uniform');      %using uniform init by default
    
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
        case 'diag'
            PAI=mkStochastic(rand(M,1));
            A=mk_stochastic_diag(rand(M,M));
            P=mkStochastic(rand(M,D));
        case 'left-right'
            PAI=mkStochastic(rand(M,1));
            A=mkStochastic(triu(rand(M,M),0));
            P=mkStochastic(rand(M,D));
        case 'zero-diag'
            PAI=ones(M,1);
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
    end
    %[O,Vk]=canonizeLabels(X);
    [x,I]=sort(O);
    tmp=([1;diff(x)]~=0);
    Vk=x(tmp);                  %observable values
    Num=diff(find([tmp;1]==1));
    if length(Vk)<K
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
