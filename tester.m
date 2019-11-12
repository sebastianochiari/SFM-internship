%% Read data and sort 
data = importdata('real_video_trajectory/ucy_zara01.csv');

[H,W] = size(data);

data_sort = sort(data,2,'ascend'); % ordina la matrice data per ottenere i parametri num_people, num_frame, num_group

num_people = data_sort(2,W); % si calcola il numero di persone
num_frame = data_sort(1,W); % si calcola il numero di frame
num_group = data_sort(5,W); % si calcola il numero di gruppi

%% Get the regression input and output of each personID
Subject_Data_X = zeros(0,0);
Subject_Data_Y = zeros(0,0);
Subject_Score_X = zeros(0,0);
Subject_Score_Y = zeros(0,0);

for i = 1:num_people % per ciascun ID
    group = max(data(5,data(2,:) == i));
    if(group == 0)
        [Data_X,Data_Y,Score_X,Score_Y] = group_scene_vision(data,i);
        Subject_Data_X = [Subject_Data_X;Data_X];
        Subject_Data_Y = [Subject_Data_Y;Data_Y];
        Subject_Score_X = [Subject_Score_X,Score_X];
        Subject_Score_Y = [Subject_Score_Y,Score_Y];
    end
end

%% Conduct Linear regression
% choose some alpha value
alpha = 0.01;
% choose the number of iterations
num_iters = 20000;
% init theta and run gradient descent
thetaX = ones(4,1);
%thetaY = zeros(4,1);
thetaX(2) = 10; 
Subject_Data_Y = Subject_Data_Y(:,1:4);

tic

[thetaX, J_history1] = gradientDescentMulti(Subject_Data_Y, Subject_Score_Y, thetaX, alpha, num_iters);
%[thetaY, J_history2] = gradientDescentMulti(Subject_Data_Y, Subject_Score_Y, thetaY, alpha, num_iters);

toc
% theta=(abs(thetaX)+abs(thetaY))/2

%% Plot of consumption and data fitting of 1st regression
figure(1)
plot(1:numel(J_history1), J_history1, '-b', 'LineWidth', 2);
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
