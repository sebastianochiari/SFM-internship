%% Read data from .txt file
function [Subject_Data_X,Subject_Data_Y,Subject_Score_X,Subject_Score_Y]=group_scene(data,m);
%% Read data and sort according to personID
[H,W]=size(data);
data(3,:)=data(3,:);
data(4,:)=data(4,:);
data_sort=sort(data,2,'ascend'); %row rank to get some parameters
[~,ind]=sort(data(2,:),'ascend');
num_people=data_sort(2,W);
num_frame=data_sort(1,W);
num_group=data_sort(5,W);
%% Calculate velocity and acceleration of Person 1
mini=num_frame;
maxi=0;
group=max(data(5,data(2,:)==m));
for i=1:W
    if(data(2,i)==m && data(1,i)>maxi )
        maxi=data(1,i);
    end
    if(data(2,i)==m && data(1,i)<mini)
        mini=data(1,i);
    end
end
lo=zeros(3,maxi-mini+1);
ve=zeros(3,maxi-mini);
ac=zeros(3,maxi-mini-1);
lo(3,:)=mini:maxi;
for i=1:W
    for j=1:maxi-mini+1
        if(data(2,i)==m && data(1,i)==lo(3,j))
            lo(1,j)=data(3,i);
            lo(2,j)=data(4,i);
        end
    end
end

for i=1:maxi-mini
        ve(1,i)=lo(1,i+1)-lo(1,i);
        ve(2,i)=lo(2,i+1)-lo(2,i);
        ve(3,i)=lo(3,i);
        if(i>1)
            ac(1,i-1)=(ve(1,i)-ve(1,i-1))/0.5;
            ac(2,i-1)=(ve(2,i)-ve(2,i-1))/0.5;
            ac(3,i-1)=ve(3,i-1);
        end
end
%% Calculate all the forces on the Person 
fo=zeros(num_people+num_group+2,maxi-mini-1,4); %force from people and group
fo(1,:,1)=ac(3,:); %frame
start_X=-1500;
if(lo(1,1)<0)
    start_X=-start_X;
end
for i=1:maxi-mini-1
    fo(num_people+num_group+2,i,1)=((start_X-lo(1,i))/sqrt((start_X-lo(1,i))^2+(500-lo(2,i))^2))/0.5;         % assume relaxtion time 0.5
    fo(num_people+num_group+2,i,2)=((500-lo(2,i))/sqrt((start_X-lo(1,i))^2+(500-lo(2,i))^2))/0.5;      % assume relaxtion time 0.5
    ac(1,i)=ac(1,i)+ve(1,i)/0.5;
    ac(2,i)=ac(2,i)+ve(2,i)/0.5;
end
for i=1:W
    for j=1:maxi-mini-1
        if(fo(1,j,1)==data(1,i))
            if(data(2,i)~=m) % repulsive force
                if(data(2,i)==1 && m~=1)
                   fo(m,j,1)=lo(1,j)-data(3,i);
                   fo(m,j,2)=lo(2,j)-data(4,i);
                   fo(m,j,3)=sqrt(fo(m,j,1)^2+fo(m,j,2)^2);
                   if(data(5,i)~=0) %pedestrain with group information 
                     if(data(5,i)==group) % attraction force
                       fo(m,j,4)=group;
                       fo(group+num_people+1,j,1)=fo(group+num_people+1,j,1)+data(3,i);
                       fo(group+num_people+1,j,2)=fo(group+num_people+1,j,2)+data(4,i);
                       fo(group+num_people+1,j,4)=fo(group+num_people+1,j,4)+1;
                     elseif(data(5,i)~=group) % vision force
                       fo(data(5,i)+num_people+1,j,1)=fo(data(5,i)+num_people+1,j,1)+data(3,i);
                       fo(data(5,i)+num_people+1,j,2)=fo(data(5,i)+num_people+1,j,2)+data(4,i);
                       fo(data(5,i)+num_people+1,j,4)=fo(data(5,i)+num_people+1,j,4)+1;
                     end
                   end
                else
                   fo(data(2,i),j,1)=lo(1,j)-data(3,i);
                   fo(data(2,i),j,2)=lo(2,j)-data(4,i);
                   fo(data(2,i),j,3)=sqrt(fo(data(2,i),j,1)^2+fo(data(2,i),j,2)^2);
                   if(data(5,i)~=0) %pedestrain with group information
                     if(data(5,i)==group) % attraction force
                       fo(data(2,i),j,4)=group;
                       fo(group+num_people+1,j,1)=fo(group+num_people+1,j,1)+data(3,i);
                       fo(group+num_people+1,j,2)=fo(group+num_people+1,j,2)+data(4,i);
                       fo(group+num_people+1,j,4)=fo(group+num_people+1,j,4)+1;
                     elseif(data(5,i)~=group) % vision force
                       fo(data(5,i)+num_people+1,j,1)=fo(data(5,i)+num_people+1,j,1)+data(3,i);
                       fo(data(5,i)+num_people+1,j,2)=fo(data(5,i)+num_people+1,j,2)+data(4,i);
                       fo(data(5,i)+num_people+1,j,4)=fo(data(5,i)+num_people+1,j,4)+1;
                     end
                   end
                end
            end
        end
    end
end
%calculate group force
for i=1:maxi-mini-1
    for j=num_people+1:num_people+num_group+1
        if(fo(j,i,4)~=0) 
            if(j~=num_people+1+group) %vision force
              fo(j,i,1)=fo(j,i,1)/fo(j,i,4)-lo(1,i);
              fo(j,i,2)=fo(j,i,2)/fo(j,i,4)-lo(2,i);
              fo(j,i,3)=sqrt(fo(j,i,1)^2+fo(j,i,2)^2);
            else %attraction force
%               fo(j,i,4)=fo(j,i,4)+1;
%               fo(j,i,1)=(fo(j,i,1)+lo(1,i))/fo(j,i,4)-lo(1,i);
%               fo(j,i,2)=(fo(j,i,2)+lo(2,i))/fo(j,i,4)-lo(2,i);
%               fo(j,i,3)=sqrt(fo(j,i,1)^2+fo(j,i,2)^2);
              fo(j,i,1)=fo(j,i,1)/fo(j,i,4)-lo(1,i);
              fo(j,i,2)=fo(j,i,2)/fo(j,i,4)-lo(2,i);
              fo(j,i,3)=sqrt(fo(j,i,1)^2+fo(j,i,2)^2);
            end
        end
    end
end
%% Prepare Data 
d1=0.5*100; d2=1.0*100; d3=4.0*100;
Subject_Data_X=zeros(maxi-mini-1,6); Subject_Score_X=zeros(1,maxi-mini-1);
Subject_Data_Y=zeros(maxi-mini-1,6); Subject_Score_Y=zeros(1,maxi-mini-1);
for i=1:maxi-mini-1
    Subject_Data_X(i,1)=fo(num_people+num_group+2,i,1);    % 1st row is desired speed force
    Subject_Data_Y(i,1)=fo(num_people+num_group+2,i,2);
    Subject_Score_X(1,i)=ac(1,i);    
    Subject_Score_Y(1,i)=ac(2,i);
    for j=1:num_people
        if(fo(j,i,3)>d2 && fo(j,i,3)<d3) % 4th row is d2-d3 range
            if(fo(j,i,4)==0)
              Subject_Data_X(i,4)=Subject_Data_X(i,4)+(d3-fo(j,i,3))*fo(j,i,1)/fo(j,i,3)/(d3-d2);
              Subject_Data_Y(i,4)=Subject_Data_Y(i,4)+(d3-fo(j,i,3))*fo(j,i,2)/fo(j,i,3)/(d3-d2);
            end
        elseif(fo(j,i,3)>d1 && fo(j,i,3)<d2) % 3th row is d1-d2 range
            Subject_Data_X(i,3)=Subject_Data_X(i,3)+(d2-fo(j,i,3))*fo(j,i,1)/fo(j,i,3)/(d2-d1);
            Subject_Data_Y(i,3)=Subject_Data_Y(i,3)+(d2-fo(j,i,3))*fo(j,i,2)/fo(j,i,3)/(d2-d1);
            Subject_Data_X(i,4)=Subject_Data_X(i,4)+fo(j,i,1)*(fo(j,i,3)-d1)/fo(j,i,3)/(d2-d1);
            Subject_Data_Y(i,4)=Subject_Data_Y(i,4)+fo(j,i,2)*(fo(j,i,3)-d1)/fo(j,i,3)/(d2-d1);
        elseif (fo(j,i,3)<d1 && fo(j,i,3)~=0 ) %2nd row is <d1 range
            Subject_Data_X(i,2)=Subject_Data_X(i,2)+(d1-fo(j,i,3))*fo(j,i,1)/fo(j,i,3)/d1;
            Subject_Data_Y(i,2)=Subject_Data_Y(i,2)+(d1-fo(j,i,3))*fo(j,i,2)/fo(j,i,3)/d1;
            Subject_Data_X(i,3)=Subject_Data_X(i,3)+fo(j,i,3)*fo(j,i,1)/fo(j,i,3)/d1;
            Subject_Data_Y(i,3)=Subject_Data_Y(i,3)+fo(j,i,3)*fo(j,i,2)/fo(j,i,3)/d1;
         end
    end
    for j=num_people+1:num_people+num_group+1
        if(fo(j,i,4)~=0)
          if(j==group+num_people+1)% attraction force
              Subject_Data_X(i,6)=fo(j,i,1)/fo(j,i,3);
              Subject_Data_Y(i,6)=fo(j,i,2)/fo(j,i,3);
          else % vision force
              A=[fo(j,i,1) fo(j,i,2)];
              B=[ve(1,i) ve(2,i)];
              angel=acos(dot(A,B)/(norm(A)*norm(B)));
              angel=angel*180/pi;
              if(angel>90)
                  angel=angel-90;
              else
                  angel=0;
              end
              if(angel>45)
                Subject_Data_X(i,5)=Subject_Data_X(i,5)-angel*ve(1,i)/(180*sqrt(ve(1,i)^2+ve(2,i)^2));
                Subject_Data_Y(i,5)=Subject_Data_Y(i,5)-angel*ve(2,i)/(180*sqrt(ve(1,i)^2+ve(2,i)^2));
              end
          end
        end
    end
end
%% Linear regression
% Choose some alpha value
%normalize
%  Subject_Data_X=Subject_Data_X./max(max(Subject_Data_X)); %=Subject_Score_X./max(Subject_Score_X);
% Subject_Data_Y=Subject_Data_Y./max(max(Subject_Data_Y)); %Subject_Score_Y=Subject_Score_Y./max(Subject_Score_Y);
% Compensate to fit the data
% if(Subject_Score_X(1,1)<0)
%  Subject_Score_X=Subject_Score_X+8;
% else
%  Subject_Score_X=Subject_Score_X-8;  
% end
% if(Subject_Score_Y(1,1)<0)
%  Subject_Score_Y=Subject_Score_Y+1;
% else
%  Subject_Score_Y=Subject_Score_Y-1;   %-0.5
% end
% Subject_Score_X=-Subject_Score_X/10;
%Subject_Score_Y=-Subject_Score_Y;
%Subject_Score_X=-(Subject_Score_X-8);  
%% Plot trajectory 
% figure(4)
% for i=1:15
%    for j=1:W
%        if(data(2,j)==i)
%           scatter(data(3,j),data(4,j),[],i);
%           hold on
%        end
%    end
% end
% figure(5)
% for i=1:maxi-mini
%     scatter(lo(1,i),lo(2,i));
%     hold on
% end
