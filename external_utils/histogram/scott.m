function [w,bins] = scott(c,normal,factor);
% function [w,bins] = scott(c,normal,factor);
% Calculate bins width and bins vector using the Scott's rule applied to vector c
% normal = 1 : Use Normal rule
% normal = 0 : Use Correct normal rule with skewness factor
% factor : Multiply calculated width by factor

% Copyright (c) 2004-2006 Alessio Botta, Alberto Dainotti, Antonio Pescapè
% Email: {a.botta , alberto , pescape }@unina.it
% DIS - Dipartimento di Informatica e Sistemistica 
% University of Napoli Federico II, ITALY
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
% 3. Redistributions of source code or in binary form must clearly reproduce
%    the reference to the web site from which they were downloaded.
%
% THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
% OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
% LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
% OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
% SUCH DAMAGE.

if nargin < 3
	factor = 1;
end
if nargin < 2
	normal = 1;
end

% Compute bins width by Scott's rule 
w = 3.49 * std(c) * length(c)^(-1/3);

if normal ~= 1
	% Distribution in lognormal-like
	s = std(log10(c));
	skew = (2^(1/3) * s) / ( exp(5/4*s^2) * (s^2 + 2)^(1/3) * (exp(s^2)-1)^(1/2) );
	clear s;
	fprintf('Skewness factor: %d (inverse: %d)\n', skew, 1/skew);
	w = w * skew;
end	

w = w * factor;

% Establish bins vector
bins = (min(c)+w/2):w:max(c);
