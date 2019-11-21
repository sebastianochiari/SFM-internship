%% Read data and sort
disp('Read data and sort');

tic

data = importdata('crowded_real_video_trajectory/ucy_zara01.csv');

[H,W] = size(data);

data_sort = sort(data,2,'ascend'); % ordina una copia della matrice data per ottenere i parametri num_people, num_frame, num_group

num_people = data_sort(2,W); % si calcola il numero di persone
num_frame = data_sort(1,W); % si calcola il numero di frame
num_group = data_sort(5,W); % si calcola il numero di gruppi

toc

disp(newline);

%% Get the regression input and output of each personID
disp('Get the regression input and output of each personID');

tic

Subject_Data_X = zeros(0,0);
Subject_Data_Y = zeros(0,0);
Subject_Score_X = zeros(0,0);
Subject_Score_Y = zeros(0,0);

for i = 1:num_people % per ciascun ID
    
    % eliminato l'if che controllava che group == 0
    
    [Data_X,Data_Y,Score_X,Score_Y] = group_scene_vision(data,i);
    Subject_Data_X = [Subject_Data_X;Data_X];
    Subject_Data_Y = [Subject_Data_Y;Data_Y];
    Subject_Score_X = [Subject_Score_X,Score_X];
    Subject_Score_Y = [Subject_Score_Y,Score_Y];
    
    % matrici di dimensione :x104704 o 104704x: perch� vengono scartati il
    % primo e ultimo frame per ogni id (non � possibile calcolare velocit�
    % e accelerazione) > 434 ID x 2 = 868 (=> le 105572 entry
    % [ucy_univ.csv] diventano 104704)

end

toc

disp(newline);

%% Adding crowdness
disp('Adding crowdness');

tic

% creare una nuova matrice, ordinata per ID (deve mantenere le colonne
% intatte)
new_data = sortrows(data.',2).'; % matrice 8x105572

% retrieve Subject_Data_Y rows number
SDY_rows = size(Subject_Data_Y, 1); % 104704
SDY_columns = size(Subject_Data_Y, 2); % 6

% retrieve Subject_Score_Y
SSY_rows = size(Subject_Score_Y, 1); % 1
SSY_columns = size(Subject_Score_Y, 2); % 104704

% impostiamo le due matrici tmp1 (per Subject_Data_Y) e tmp2 (per
% Subject_Score_Y)
tmp1(SDY_rows, 9) = 0; % matrice 104704x9
tmp2(4, SSY_columns) = 0; % matrice 4x104704

tmp1(1:SDY_rows, 1:SDY_columns) = Subject_Data_Y;
tmp2(1:SSY_rows, 1:SSY_columns) = Subject_Score_Y;

Subject_Data_Y = tmp1;
Subject_Score_Y = tmp2;

% pulire new_data eliminando per ciascun id le righe del primo e ultimo
% frame (non usate in group_scene_vision per calcolare le forze dell'SFM)
i = size(new_data,2);
boolean = 1;
while i ~= 1
    if(boolean == 1)
        new_data(:,i) = [];
        boolean = 0;
    elseif(boolean ~= 1)
        if(new_data(2,i) ~= new_data(2, i-1))
            new_data(:,i) = [];
            boolean = 1;
        end
    end
    i = i - 1;
end
new_data(:,1) = [];

% aggiungere tre nuove righe crowdness da new_data con radius = 1, radius = 2 e radius = 5
for i = 1:size(new_data,2)
    % aggiorniamo Subject_Data_Y con new_data
    Subject_Data_Y(i,7) = new_data(6,i);
    Subject_Data_Y(i,8) = new_data(7,i);
    Subject_Data_Y(i,9) = new_data(8,i);
    % aggiorniamo Subject_Score_Y con new_data
    Subject_Score_Y(2,i) = new_data(6,i); 
    Subject_Score_Y(3,i) = new_data(7,i);
    Subject_Score_Y(4,i) = new_data(8,i);
end

% Subject_Data_Y    > (x,7) RADIUS = 1
%                   > (x,8) RADIUS = 2
%                   > (x,9) RADIUS = 5
% Subject_Score_Y   > (2,x) RADIUS = 1
%                   > (3,x) RADIUS = 2
%                   > (4,x) RADIUS = 5

toc

disp(newline);

%% Choose subset of Subject_Score_Y and Subject_Data_Y according to the crowdness level desired
disp('Choose subset of Subject_Score_Y and Subject_Data_Y according to the crowdness level desired');

tic

% definire la crowdness su cui ci interessa realizzare la linear regression
crowdness = 6;

% modificare Subject_Score_Y e Subject_Data_Y di conseguenza
i = size(new_data,2);
while i ~= 0
    if(Subject_Data_Y(i,9) < crowdness)
        Subject_Data_Y(i,:) = [];
    end
    if(Subject_Score_Y(4,i) < crowdness)
        Subject_Score_Y(:,i) = [];
    end
    i = i - 1;
end

toc

disp(newline);

%% Conduct Linear regression
disp('Conduct Linear regression');

% choose some alpha value
alpha = 0.01;
% choose the number of iterations
num_iters = 20000;
% init theta and run gradient descent
thetaX = ones(4,1);
thetaX(2) = 10;

Subject_Data_Y = Subject_Data_Y(:,1:4); % elimina le ultime colonne di Subject_Data_Y, lasciando solo dalla 1 alla 4
Subject_Score_Y = Subject_Score_Y(1,:); % elimino le righe in pi� per riportarlo alla forma iniziale

tic

[thetaX, J_history1] = gradientDescentMulti(Subject_Data_Y, Subject_Score_Y, thetaX, alpha, num_iters);
% thetaX (|v des|, f1, f2, f3)

toc

disp(newline);

%% Plot of consumption and data fitting of 1st regression
% figure(1)
% plot(1:numel(J_history1), J_history1, '-b', 'LineWidth', 2);
% xlabel('Number of iterations');
% ylabel('Cost J')
% figure(2)
% hold on
% plot(1:numel(Subject_Score_Y),Subject_Data_Y*thetaX,'-y', 'LineWidth', 2);
% legend('real weights','regression');
% hold off
% title('1st regression on F1,F2,F3 and speed')

%% Export thetaX parameters to file for post-process and graphic building in plotter.py
disp('Export thetaX parameters to file for post-process and graphic building in plotter.py');

tic

thetaX = transpose(thetaX);
% dlmwrite('1st linear regression/ucy_zara01/radius = 5/ucy_zara01_param-radius5.csv', thetaX, 'delimiter', ',');
dlmwrite('1st linear regression/ucy_zara01/radius = 5/ucy_zara01_param-radius5.csv', thetaX, '-append', 'delimiter', ',');


toc