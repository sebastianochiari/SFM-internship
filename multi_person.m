%% Read data and sort 
data = importdata('ucy_zara01.csv');
[H,W]=size(data);
%data(2,:)=data(2,:)+1;
data_sort=sort(data,2,'ascend'); %row rank to get some parameters
[~,ind]=sort(data(2,:),'ascend');
num_people=data_sort(2,W);
num_frame=data_sort(1,W);
num_group=data_sort(5,W);
%% Get the regression input and output of each personID
 Subject_Data_X =zeros(0,0);Subject_Data_Y =zeros(0,0);
 Subject_Score_X =zeros(0,0);Subject_Score_Y = zeros(0,0);
for i=1:num_people
    if(max(data(5,data(2,:)==i))==0)
      [Data_X,Data_Y,Score_X,Score_Y]=group_scene_vision(data,i);
      Subject_Data_X=[Subject_Data_X;Data_X]; Subject_Data_Y=[Subject_Data_Y;Data_Y];
      Subject_Score_X=[Subject_Score_X,Score_X]; Subject_Score_Y=[Subject_Score_Y,Score_Y];
    end
end
% Subject_Data_X=complex(Subject_Data_X,Subject_Data_Y);
% Subject_Score_X=complex(Subject_Score_X,Subject_Score_Y);
%% Conduct Linear regression
% Choose some alpha value
alpha = 0.01;
num_iters = 20000;
% Init Theta and Run Gradient Descent 
thetaX = ones(4,1);
%thetaY = zeros(4,1);
thetaX(2)=10; 
Subject_Data_Y=Subject_Data_Y(:,1:4);
tic
[thetaX, J_history1] = gradientDescentMulti(Subject_Data_Y, Subject_Score_Y, thetaX, alpha, num_iters);
%[thetaY, J_history2] = gradientDescentMulti(Subject_Data_Y, Subject_Score_Y, thetaY, alpha, num_iters);
toc
% theta=(abs(thetaX)+abs(thetaY))/2
%% Plot of Consumption and dta fitting of 1st regression
figure(1)
plot(1:numel(J_history1), J_history1, '-b', 'LineWidth', 2);
% hold on
%  plot(1:numel(J_history2), J_history2, '-r', 'LineWidth', 2);
% hold off
xlabel('Number of iterations');
ylabel('Cost J')
%  thetaX(2)=10; thetaY(2)=10;
figure(2)
%plot(1:numel(Subject_Score_Y),[Subject_Data_X]*[1.3;10;2;0.5],'-b', 'LineWidth', 2);
hold on 
plot(1:numel(Subject_Score_Y),Subject_Data_Y*thetaX,'-y', 'LineWidth', 2);
%plot(1:numel(Subject_Score_Y),[Subject_Score_X],'-r', 'LineWidth', 2);
legend('real weights','regression');
hold off
title('1st regression on F1,F2,F3 and speed')
%% Second time linear regression
 Group_Data_X =zeros(0,0); Group_Data_Y =zeros(0,0);
 Group_Score_X =zeros(0,0); Group_Score_Y = zeros(0,0);
for i=1:num_people
    if(max(data(5,data(2,:)==i))~=0)
      [Data_X,Data_Y,Score_X,Score_Y,fo]=group_scene_vision(data,i);
      Group_Data_X=[Group_Data_X;Data_X]; Group_Data_Y=[Group_Data_Y;Data_Y];
      Group_Score_X=[Group_Score_X,Score_X]; Group_Score_Y=[Group_Score_Y,Score_Y];
    end
end
% Group_Data_X=complex(Group_Data_X,Group_Data_Y);
% Group_Score_X=complex(Group_Score_X,Group_Score_Y);
[Group_input,Group_output]=group_scene_group(Group_Data_Y,Group_Score_Y,thetaX);
thetaX2 = [5;5];
tic
[thetaX2, J_history2] = gradientDescentMulti(Group_input,Group_output,thetaX2,0.01,20000);
toc
theta=[thetaX;thetaX2];
%% Plot of Consumption and dta fitting of 2nd regression
figure(3)
plot(1:numel(J_history2), J_history2, '-b', 'LineWidth', 2);
xlabel('Number of iterations');
ylabel('Cost J')
figure(4)
%plot(1:numel(Group_output),Group_input*[2;1.5],'-b', 'LineWidth', 2);
hold on 
plot(1:numel(Group_output),Group_input*thetaX2,'-y', 'LineWidth', 2);
%plot(1:numel(Group_output),Group_output,'-r', 'LineWidth', 2);
legend('real weights','regression');
hold off
title('2nd regression on group force')


