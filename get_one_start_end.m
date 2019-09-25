function [out,lo]=get_one_start_end(data,people)
% data = importdata('eth_hotel.csv');
% people=22;
%% Calculate all the locations of the persons
data_sort=sort(data,2,'ascend');
[~,W]=size(data);
num_frame=data_sort(1,W);
mini=num_frame;
maxi=0;
group=max(data(5,data(2,:)==people));
for i=1:W
    if(data(2,i)==people && data(1,i)>maxi )
        maxi=data(1,i);
    end
    if(data(2,i)==people && data(1,i)<mini)
        mini=data(1,i);
    end
end
lo=zeros(3,maxi-mini+1);
lo(3,:)=mini:maxi;
for i=1:W
    for j=1:maxi-mini+1
        if(data(2,i)==people && data(1,i)==lo(3,j))
            lo(1,j)=data(3,i);
            lo(2,j)=data(4,i);
        end
    end
end
%% Calculate the start and end of the pedestrain
out=zeros(8,1);
if(~isempty(lo))
  out(1,1)=people;
  out(2,1)=mini;
  out(3,1)=lo(1,1);
  out(4,1)=lo(2,1);
  out(5,1)=maxi;
  out(6,1)=lo(1,maxi-mini+1);
  out(7,1)=lo(2,maxi-mini+1);
  out(8,1)=group;
end
return