function [AIC,BIC,AICc]=abic(logL,nbp,nbdata)
% GMTD_abic.m 
% copyright Andre Berchtold, 1998-1999
%
% Computation of AIC and BIC
%
%
% Input
% logL : log-Likelihood
% nbp : number of independent parameters of the model
% nbdata : number of data
%
% Output
% AIC : Akaike Information Criterion
% BIC : Bayesian Information Criterion

AIC = -2*logL+2*nbp;
BIC = -2*logL+nbp*log(nbdata);
AICc = AIC + 2*nbp*(nbp+1)/(nbdata-nbp-1);
