function [transmat, pi]=gwm_createStochasticMatrix(NStates, varargin)
%function [transmat, pi]=gwm_createStochasticMatrix(NStates, varargin)
%   'MatrixType' (Transition matrix):
%       - 'uniform'         
%       - 'rand'            <-default
%       - 'rand-zero-diag'  <-random with zero diag
%       - 'unif-zero-diag'  <-uniform with zero diag
%       - 'left-right'      <-Bakis (full jump example)
%                     transmat =
%                         0.2025    0.1221    0.6754
%                              0    0.6427    0.3573
%                              0         0    1.0000
%       - 'jump_step'       <-For left-right model [from 1 to (NStates-1)]: default (NStates-1)
%
%See also
% mkStochastic

[   MatrixType,           ...
    jump_step           ] ...
    = process_options(varargin  ,            ...
    'MatrixType'                , 'rand',    ...     % using uniform init by default
    'jump_step'                 , NStates-1  ...     % full jump (default)
    );

switch lower(MatrixType)
    case 'uniform'  
        pi=ones(NStates,1);
        pi=pi./sum(pi);           
        transmat=ones(NStates);
        transmat=transmat./(sum(transmat,2)*ones(1,NStates));
    case 'rand'
        pi=mkStochastic(rand(NStates,1));
        transmat=mkStochastic(rand(NStates,NStates));
    case 'rand-zero-diag'
        pi = rand(NStates,1);
        pi(1) = 0;         % we cannot start from this place because of zero diag
        pi=mkStochastic(pi);
        transmat=rand(NStates,NStates);
        transmat(eye(size(transmat))==1)=0;
        transmat=mkStochastic(transmat);
    case 'unif-zero-diag'
        pi=ones(NStates,1);
        pi(1)=0;           % we cannot start from this place because of zero diag
        pi=pi./sum(pi);
        transmat=ones(NStates);
        transmat(eye(size(transmat))==1)=0;
        transmat=transmat./(sum(transmat,2)*ones(1,NStates));      %The Transition Probability Matrix of active states
    case 'left-right'
        if jump_step > (NStates-1)
            warning('Jump step could not be greater than NStates-1. Converting jump_step to NStates-1');
            jump_step = NStates-1;
        elseif jump_step < 1
            warning('Jump step could not be less than 1. Converting jump_step to 1');
            jump_step = 1;
        end
        pi = zeros(NStates,1);
        pi(1) = 1;      % we start from the FIRST state
        transmat = tril(triu(rand(NStates,NStates),0),jump_step);
        transmat(NStates) = 1 - sum(transmat(NStates,:));   %allow jump from last state to first
        transmat = mkStochastic(transmat);
        %transmat=mkStochastic(tril(triu(rand(NStates,NStates),0),jump_step));
    otherwise
        %%we use uniform distribution init by deafault
        pi=ones(NStates,1);
        pi=pi./sum(pi);           %the initial probability
        transmat=ones(NStates);
        transmat=transmat./(sum(transmat,2)*ones(1,NStates));      %The Transition Probability Matrix of active states
end

end