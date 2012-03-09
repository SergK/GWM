function [model,ll]=hsmmFit(data,M,D,K,varargin)
%function model=hsmmFit(data,M,D,K,varargin)
%   data - train data
%   M - number of states
%   D - max duration
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
%   jump_step - constrained jump for left-right model (default - max)
    %%
[   init_type,  ...
    iter,       ...
    jump_step ] ...
    = process_options(varargin  , ...
    'init_type'                 , 'uniform',...
    'iter'                      ,  100,     ...   %Number of iteration for model EM
    'jump_step'                 ,  M-1);            
%Data check and convert it to column form
if isrowvec(data)
    data=data';
end

%Model init

    %[A,B,P,PAI,Vk,O,K]=hsmmInitialize_new(data,M,D,K,'init_type',init_type);
    [model]=hsmmCreate(data,M,D,K,'init_type',init_type,'jump_step',jump_step);

    %model re-estimation
    [PAI,A,B,P,Qest,lkh,ll]=hsmm_new(model.PAI,model.A,model.B,model.P,model.O,iter);
    model.PAI=PAI;
    model.A=A;
    model.B=B;
    model.P=P;
    model.Qest=Qest;
    model.lkh=lkh;
    model.ll=ll;
    model.K=K;
end