%% Read data and sort 
data = importdata('eth_hotel.csv');
[H,W]=size(data);
data(2,:)=data(2,:)+1;
data_sort=sort(data,2,'ascend'); %row rank to get some parameters
[~,ind]=sort(data(2,:),'ascend');
num_people=data_sort(2,W);
num_frame=data_sort(1,W);
num_group=data_sort(5,W);
people_par=zeros(7,num_people);
%% Get the regression input and output of each personID
alpha = 0.01;
num_iters = 20000;
Subject_Data_X =zeros(0,0);Subject_Data_Y =zeros(0,0);
Subject_Score_X =zeros(0,0);Subject_Score_Y = zeros(0,0);
tic
for i=1:num_people
    if(max(data(5,data(2,:)==i))==0)
      [Data_X,Data_Y,Score_X,Score_Y,XY]=group_scene_vision(data,i);
      people_par(1:7,i)=[i; 1; 11; 1; 1; 0; 0];
      if(XY==1)
        Data_X=Data_X(:,1:4);
        [people_par(2:5,i), ~] = gradientDescentMulti(Data_X, Score_X, people_par(2:5,i), alpha, num_iters);
      else
        Data_Y=Data_Y(:,1:4);
        [people_par(2:5,i), ~] = gradientDescentMulti(Data_Y, Score_Y, people_par(2:5,i), alpha, num_iters);
      end
    end
    if(max(data(5,data(2,:)==i))~=0)  
      [Data_X,Data_Y,Score_X,Score_Y,XY]=group_scene_vision(data,i);
      people_par(1:7,i)=[i; 1; 11; 1; 1; 1; 1];
      if(XY==1)
        [people_par(2:7,i), ~] = gradientDescentMulti(Data_X, Score_X, people_par(2:7,i), alpha, num_iters);
      else
        [people_par(2:7,i), ~] = gradientDescentMulti(Data_Y, Score_Y, people_par(2:7,i), alpha, num_iters);
      end
    end
end
toc
%% save the parameters
people_par=people_par';
dlmwrite('eth_hotel_param.csv',people_par, 'delimiter', ',','precision', 6,'newline', 'pc')