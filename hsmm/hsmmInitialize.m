function [A,B,P,PAI,Vk,O,K]=hsmmInitialize(O,M,D,K)
% 
% Author: Shun-Zheng Yu
% Available: http://sist.sysu.edu.cn/~syu/Publications/hsmmInitialize.m
% 
% To initialize the matrixes of A,B,P,PAI for hsmm_new.m, to get 
% the observable values and to transform the observations O
% from values to their indexes.
%
% Usage: [A,B,P,PAI,Vk,O,K]=hsmmInitialize(O,M,D,K)
% 
%  This program is free software; you can redistribute it and/or
%  modify it under the terms of the GNU General Public License
%  as published by the Free Software Foundation; either version
%  2 of the License, or (at your option) any later version.
%  http://www.gnu.org/licenses/gpl.txt
%
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

%    PAI=rand(M,1)+1;
    PAI=ones(M,1);
    PAI=PAI./sum(PAI);           %the initial probability

    A=ones(M);
%   A=rand(M)+1;
%    for i=1:M
%       A(i,i)=0;
%    end
    A=A./(sum(A')'*ones(1,M));      %The Transition Probability Matrix of active states
    
%   P=0.99.*exp(log(ones(M,1).*0.01)*(0:D-1));
%   P=rand(M,D)+1;
%    P=ones(M,D);
    P=repmat((1:D).^2,M,1);
    P=P./(sum(P')'*ones(1,D));
    
    lambda=(max(O)-min(O))/M;
    lambda=(min(O)+lambda/2):lambda:max(O);
    for i=1:K
        ss(i)=sum(log(1:i));
    end
    B=exp(log(lambda')*(1:K)-ones(M,1)*ss-lambda'*ones(1,K));
    B=B+(max(B')'.*0.01)*ones(1,K);
    B=B./(sum(B')'*ones(1,K));      %The observation symbol probability distribution
