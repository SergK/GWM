function [Loglike,sumLogLike,errors] = mhmmLogprob(model, data)
%%function [Loglike,sumLogLike,errors] = mhmmLogprob(model, data)
%   - Loglike(i) = log p(data{i} | model), data{i} is 1*T
% if data is a single sequence, we compute logp = log p( {data} | model)
%   - sumLogLike is simple sum(LogLike)
%
%This file is based on code from pmtk3.googlecode.com
% LOG_LIK_MHMM Compute the log-likelihood of a dataset using a (mixture of) Gaussians HMM
% [loglik, errors] = log_lik_mhmm(data, prior, transmat, mu, sigma, mixmat)
%
% data{m}(:,t) or data(:,t,m) if all cases have same length
% errors  is a list of the cases which received a loglik of -infinity
%
% Set mixmat to ones(Q,1) or omit it if there is only 1 mixture component



mu = model.mu;
Sigma = model.Sigma;
mixmat = model.mixmat;
prior = model.pi;
transmat = model.A;

%data = cellwrap(data);
%ncases = numel(data);

errors = [];

if ~iscell(data)
  data = num2cell(data, [1 2]); % each elt of the 3rd dim gets its own cell
end
ncases = length(data);
Loglike = zeros(ncases, 1);

for m=1:ncases
    obslik = mixgauss_prob(data{m}, mu, Sigma, mixmat);
    [Loglike(m)] = hmmFilter(prior, transmat, obslik);
    if Loglike(m)==-inf
        errors = [errors m];
    end
    %Loglike = Loglike + ll;
end
sumLogLike = sum(Loglike);
end