function lo=calc_location(data,num)
%% Read data and sort according to personID
[H,W]=size(data);
data(3,:)=data(3,:);
data(4,:)=data(4,:);
data_sort=sort(data,2,'ascend'); %row rank to get some parameters
num_frame=data_sort(1,W);
%% Calculate the locations
mini=num_frame;
maxi=0;
for i=1:W
    if(data(2,i)==num && data(1,i)>maxi )
        maxi=data(1,i);
    end
    if(data(2,i)==num && data(1,i)<mini)
        mini=data(1,i);
    end
end
lo=zeros(3,maxi-mini+1);
lo(3,:)=mini:maxi;
for i=1:W
    for j=1:maxi-mini+1
        if(data(2,i)==num && data(1,i)==lo(3,j))
            lo(1,j)=data(3,i);
            lo(2,j)=data(4,i);
        end
    end
end
return