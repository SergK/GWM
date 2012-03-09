function [Train,Valid,Test] = gwm_splitData(data,partitions)
% Partition a vector of data into sets of different sizes
% train/validate/test
% function  [Train,Valid,Test] = partitionData(data, partitions)
%   INPUT:
%           Train - data for training
%           Valid - data for validation
%           Test - data for validation
%   OUTPUT:
%           data - data for splitting
%           partitions - number of partitions (allow 2 or 3) 
% Example:
% [Train,Valid,Test] =partitionData(1:105,[0.3,0.2,0.5])
% a= 1:31, b=32:52, c=53:105 (last bin gets all the left over)

% Function based on partitionData from pmtk3.googlecode.com

assert(length(partitions)==2 || length(partitions)==3,'You can split data only for 2 or 3 partitions');
assert(sum(sort(partitions),2)==1,'Partitions proportion should be sum to 1');

indices = partitionData(data, partitions);
Train = indices{1};
Valid = indices{2};
if length(partitions)==3
    Test = indices{3};
end;
end