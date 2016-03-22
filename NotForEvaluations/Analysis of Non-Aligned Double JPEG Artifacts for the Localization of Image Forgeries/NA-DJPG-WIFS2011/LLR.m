function [L] = LLR(x, binHist, Q, phase, center, sig)
%
% [L] = LLR(x, binHist, Q, phase, center, sig)
%
% compute log-likelihood map according to simplified model
%
% x: DCT values
% binHist: bin positions
% Q: quantization step 
% phase: mean of quantization/truncation noise after dequantization
% center: index of x = 0 in binHist
% sig: std of quantization/truncation noise
%
% Copyright (C) 2011 Signal Processing and Communications Laboratory (LESC),       
% Dipartimento di Elettronica e Telecomunicazioni - Universit� di Firenze                        
% via S. Marta 3 - I-50139 - Firenze, Italy                   
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% 
% Additional permission under GNU GPL version 3 section 7
% 
% If you modify this Program, or any covered work, by linking or combining it 
% with Matlab JPEG Toolbox (or a modified version of that library), 
% containing parts covered by the terms of Matlab JPEG Toolbox License, 
% the licensors of this Program grant you additional permission to convey the 
% resulting work. 

% define Gaussian kernel
w = ceil(3*sig);
k = -w:w;
g = exp(-k.^2/sig^2/2);
g = g/sum(g);
N = numel(x) / numel(binHist);
% find percentage of nonzero DCT coeff
nz = sum(x(:) ~= 0)/numel(x);

bppm = zeros(size(binHist));
bppm(center + 1 + phase:Q:end) = Q;
bppm(center + 1 + phase:-Q:1) = Q;
bppm = conv(g, bppm);
bppm = bppm(w+1:end-w);
bppm = (bppm*N + 1);
LLRmap = log(bppm / mean(bppm));
LLRmap(center + 1) = nz * LLRmap(center + 1);
L = LLRmap(round(x) + center +1);

return