%% Read data and sort 
clc; clear;
data = importdata('ucy_univ.csv');
[H,W]=size(data);
data_sort=sort(data,2,'ascend'); %row rank to get some parameters
[~,ind]=sort(data(2,:),'ascend');
num_people=data_sort(2,W);
num_frame=data_sort(1,W);
num_group=data_sort(5,W);
people_par=zeros(8,num_people);
for i=1:num_people
    people_par(1,i)=i;
end
%% Get the regression input and output of each personID
alpha = 0.01;
num_iters = 20000;
Subject_Data_Dense =zeros(0,0);Subject_Score_Dense=zeros(0,0);
Subject_Data_Sparse =zeros(0,0);Subject_Score_Sparse=zeros(0,0);
Group_Data_Dense =zeros(0,0); Group_Data_Sparse =zeros(0,0);
Group_Score_Dense =zeros(0,0); Group_Score_Sparse = zeros(0,0);
for i=1:num_people
%    if(max(data(5,data(2,:)==i))==0)
      [Data_X,Data_Y,Score_X,Score_Y,XY,dense]=group_scene_vision(data,i);
      people_par(8,i)=dense;
      if(dense==1)
         if(XY==1)
           Subject_Data_Dense=[Subject_Data_Dense;Data_X];
           Subject_Score_Dense=[Subject_Score_Dense,Score_X];
         else
          Subject_Data_Dense=[Subject_Data_Dense; Data_Y];
          Subject_Score_Dense=[Subject_Score_Dense, Score_Y];
        end
      else
         if(XY==1)
           Subject_Data_Sparse=[Subject_Data_Sparse;Data_X];
           Subject_Score_Sparse=[Subject_Score_Sparse,Score_X];
         else
          Subject_Data_Sparse=[Subject_Data_Sparse; Data_Y];
          Subject_Score_Sparse=[Subject_Score_Sparse, Score_Y];
        end
      end
%    end
%    if(max(data(5,data(2,:)==i))~=0)
%       [Data_X,Data_Y,Score_X,Score_Y,XY,dense]=group_scene_vision(data,i);
%       people_par(8,i)=dense;
%      if(dense==1)
%         if(XY==1)
%           Group_Data_Dense=[Group_Data_Dense;Data_X];
%           Group_Score_Dense=[Group_Score_Dense,Score_X];
%         else
          Group_Data_Dense=[Group_Data_Dense; Data_Y];
          Group_Score_Dense=[Group_Score_Dense, Score_Y];
%         end
%      else
%         if(XY==1)
%           Group_Data_Sparse=[Group_Data_Sparse;Data_X];
%           Group_Score_Sparse=[Group_Score_Sparse,Score_X];
%         else
          Group_Data_Sparse=[Group_Data_Sparse; Data_Y];
          Group_Score_Sparse=[Group_Score_Sparse, Score_Y];
%         end
%      end
%   end
end
%% Regression on dense and sparse crowds respectively
tic
theta1=[2;11;2;1]; theta2 = [2;1.5];
Subject_Score_Dense=Subject_Score_Dense-(Subject_Data_Dense(:,5:6)*theta2)';
Subject_Data_Dense=Subject_Data_Dense(:,1:4);
[theta1, ~] = gradientDescentMulti(Subject_Data_Dense, Subject_Score_Dense,theta1, alpha, num_iters);
%[Group_Input,Group_Output]=group_scene_group(Group_Data_Dense,Group_Score_Dense,theta1);
%[theta2, ~] = gradientDescentMulti(Group_Input,Group_Output,theta2, alpha, num_iters);
for i=1:num_people
    if(people_par(8,i)==1)
        people_par(2:5,i)=theta1;
        people_par(6:7,i)=theta2;
    end
end
theta1=[2;11;2;1]; theta2 = [2;1.5];
Subject_Score_Sparse=Subject_Score_Sparse-(Subject_Data_Sparse(:,5:6)*theta2)';
Subject_Data_Sparse=Subject_Data_Sparse(:,1:4);
[theta1, ~] = gradientDescentMulti(Subject_Data_Sparse, Subject_Score_Sparse,theta1, alpha, num_iters);
%[Group_Input,Group_Output]=group_scene_group(Group_Data_Sparse,Group_Score_Sparse,theta1);
%[theta2, ~] = gradientDescentMulti(Group_Input,Group_Output,theta2, alpha, num_iters);
for i=1:num_people
    if(people_par(8,i)==0)
        people_par(2:5,i)=theta1;
        people_par(6:7,i)=theta2;
    end
end
toc
%% save the parameters

people_par=people_par';
dlmwrite('ucy_univ_dense_sparse.csv',people_par, 'delimiter', ',','precision', 6,'newline', 'pc')