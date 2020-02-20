%% Read data and sort
disp('Read data and sort');

tic

data = importdata('crowded_real_video_trajectory/ucy_zara01.csv');

[H,W] = size(data);

data_sort = sort(data,2,'ascend'); % ordina una copia della matrice data per ottenere i parametri num_people, num_frame, num_group

num_people = data_sort(2,W); % si calcola il numero di persone
num_frame = data_sort(1,W); % si calcola il numero di frame

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

%% Creating the two matrices combining X and Y axis
disp('Creating the two matrices combining X and Y axis');

tic

% retrieve Subject_Data_X dimensions
SDX_rows = size(Subject_Data_X, 1); % 104704
SDX_columns = size(Subject_Data_X, 2); % 6

% create the blank matrix
Subject_Data(SDX_rows, SDX_columns) = 0;

% fill the matrix with the cartesian product of the two X and Y components
for i = 1:SDX_rows
    for j = 1:SDX_columns
        Subject_Data(i,j) = ( (Subject_Data_X(i,j) ^ 2) + (Subject_Data_Y(i,j) ^ 2) ) ^ (1/2);
    end
end

% retrieve Subject_Score_X dimensions
SSX_rows = size(Subject_Score_X, 1);  % 1
SSX_columns = size(Subject_Score_X, 2); % 104704

% create the blank matrix
Subject_Score(SSX_rows, SSX_columns) = 0;

% fill the matrix with the cartesian product of the two X and Y components
for i = 1:SSX_rows
    for j = 1:SSX_columns
        Subject_Score(i,j) = ( (Subject_Score_X(i,j) ^ 2) + (Subject_Score_Y(i,j) ^ 2) ) ^ (1/2);
    end
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
SD_rows = size(Subject_Data, 1); % 104704
SD_columns = size(Subject_Data, 2); % 6

% retrieve Subject_Score_Y
SS_rows = size(Subject_Score, 1); % 1
SS_columns = size(Subject_Score, 2); % 104704

% impostiamo le due matrici tmp1 (per Subject_Data_Y) e tmp2 (per
% Subject_Score_Y)
tmp1(SD_rows, 9) = 0; % matrice 104704x9
tmp2(4, SS_columns) = 0; % matrice 4x104704

tmp1(1:SD_rows, 1:SD_columns) = Subject_Data_Y;
tmp2(1:SS_rows, 1:SS_columns) = Subject_Score_Y;

Subject_Data = tmp1;
Subject_Score = tmp2;

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
    % aggiorniamo Subject_Data con new_data
    Subject_Data(i,7) = new_data(6,i);
    Subject_Data(i,8) = new_data(7,i);
    Subject_Data(i,9) = new_data(8,i);
    % aggiorniamo Subject_Score con new_data
    Subject_Score(2,i) = new_data(6,i); 
    Subject_Score(3,i) = new_data(7,i);
    Subject_Score(4,i) = new_data(8,i);
end

%% Choose the radius for the regression
disp("Choosing the radius for the regression");

% inserire il raggio scelto
radius = 5;

if radius == 1
    
    SD_radius = 7;
    SS_radius = 2;
    
elseif radius == 2
    
    SD_radius = 8;
    SS_radius = 3;
    
elseif radius == 5
    
    SD_radius = 9;
    SS_radius = 4;
    
end

toc

disp(newline);

%% Choose subset of Subject_Score and Subject_Data according to the crowdness level desired
disp('Choose subset of Subject_Score and Subject_Data according to the crowdness level desired');

tic

% definire la crowdness su cui ci interessa realizzare la linear regression
crowdedness_down = 8; % incluso
crowdedness_up = 50; % escluso

% MODIFICARE LE CONDIZIONI DEGLI IF PER ELIMINARE LE COLONNE CHE NON
% RISPETTANO LA CROWDEDNESS CHE SI VUOLE ANDARE AD INDAGARE
i = size(new_data,2);
while i ~= 0
    if(Subject_Data(i,SD_radius) < crowdedness_down || Subject_Data(i,SD_radius) >= crowdedness_up)
        Subject_Data(i,:) = [];
    end
    if(Subject_Score(SS_radius,i) < crowdedness_down || Subject_Score(SS_radius,i) >= crowdedness_up)
        Subject_Score(:,i) = [];
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
theta = ones(4,1);
theta(2) = 10;
theta(3) = 2;
theta(4) = 0.5;

Subject_Data = Subject_Data(:,1:4); % elimina le ultime colonne di Subject_Data_Y, lasciando solo dalla 1 alla 4
Subject_Score = Subject_Score(1,:); % elimino le righe in più per riportarlo alla forma iniziale

tic

[theta, J_history1] = gradientDescentMulti(Subject_Data, Subject_Score, theta, alpha, num_iters);
% theta (|v des|, f1, f2, f3)

toc

disp(newline);

%% Export theta parameters to file for post-process and graphic building in plotter.py
disp('Export theta parameters to file for post-process and graphic building in plotter.py');

tic

theta = transpose(theta);

% dlmwrite('crowdedness/ucy_zara01/ucy_zara01_param-radius5.csv', theta, 'delimiter', ',');
dlmwrite('crowdedness/ucy_zara01/ucy_zara01_param-radius5.csv', theta, '-append', 'delimiter', ',');

load gong
sound(y,Fs)

toc