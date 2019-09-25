function [Data_X,Score_X]=group_scene_group(Subject_Data_X,Subject_Score_X,thetaX);

len_X = numel(Subject_Score_X); % function numel(A) returns the number of elements in the array A
Data_X = zeros(len_X,2); 
Score_X = zeros(1,len_X);

%% Assign the group force
for i = 1:len_X
  Data_X(i,1:2) = Subject_Data_X(i,5:6);
  Score_X(1,i) = Subject_Score_X(1,i) - (Subject_Data_X(i,1:4) * thetaX(1:4,1))';
end
