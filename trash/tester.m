%% Read data and sort 
data = importdata('py-scripts/cartesianDataset.csv');

data = transpose(data);

data_sort = sort(data,2,'ascend');