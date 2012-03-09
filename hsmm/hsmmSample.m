function [sim, observed, hidden] = hsmmSample(varargin)
%function [sim, observed, hidden] = hsmmSample(PAI,A,B,P,len,nsamples)
% or
%function [sim, observed, hidden] = hsmmSample(model,len,nsamples)
%
%   sim - simulated data with DEcanonization - Vk(Observation)
%   observed - Observation
%   hidden - hidden states

if nargin == 3
    model = varargin{1};          % 1st param Model
    len = varargin{2};            % 2nd param len
    nsamples = varargin{3};       % 3rd param nsamples
else
    model.PAI=varargin{1};
    model.A=varargin{2};
    model.B=varargin{3};  %emission
    model.P=varargin{4};
    len = varargin{5};
    nsamples = varargin{6};
end

SetDefaultValue(3, 'nsamples', 1);
E = model.B;    %define emission matrix

if numel(len) == 1
    len = repmat(len, nsamples, 1);
end
hidden   = cell(nsamples, 1);
observed = cell(nsamples, 1);

for i=1:nsamples
    T = len(i);
    hidden{i}   = rowvec(markovMySample(model, T, 1));
    observed{i} = zeros(1, T);
    for t=1:T
        observed{i}(t) = sampleDiscrete(E(hidden{i}(t), :));
    end
end
if nsamples == 1
    hidden = hidden{1};
    observed = observed{1};
end
sim = model.Vk(observed);       % save simulated data with canonization


function S = markovMySample(model, len, nsamples)
    % Sample from a markov distribution
    % S is of size nsamples-by-len
    %
    
    % This file is from pmtk3.googlecode.com
    
    if nargin < 3, nsamples = 1; end
    pi = model.PAI;
    A = model.A;
    P = model.P;
    
    S = zeros(nsamples, len);
    
    for ii=1:nsamples
        S(ii, 1) = sampleDiscrete(pi);
        duration = sampleDiscrete(P(S(ii,1),:));  %pick up the duration for init state
        S(ii, 1:duration) = S(ii, 1);
        tt=duration+1;
        while tt<=len
            S(ii, tt) = sampleDiscrete(A(S(ii, tt-1), :));
            duration = sampleDiscrete(P(S(ii,tt),:));
            S(ii, tt:tt+duration-1) = S(ii, tt);
            tt=tt+duration;
        end
        
    end
end

end