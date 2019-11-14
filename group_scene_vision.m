
function [Subject_Data_X,Subject_Data_Y,Subject_Score_X,Subject_Score_Y,XY,dense] = group_scene_vision(data,m);

%% Read data and sort according to personID
[H,W] = size(data);
data(3,:) = data(3,:); % perché copia la riga su se stessa?
data(4,:) = data(4,:); % idem con patate

data_sort = sort(data,2,'ascend'); % ordina le righe di data per ottenere poi facilmente num_people, num_frame e num_group

num_people = data_sort(2,W); % si ricalcola il numero di persone
num_frame = data_sort(1,W); % si ricalcola il numero di frame
num_group = data_sort(5,W); % si ricalcola il numero di gruppi

%% Calculate velocity and acceleration of person with ID == m
mini = num_frame;
maxi = 0;

group = max(data(5, data(2,:) == m)); % prende il massimo numero del gruppo di appartenenza

% trova entry e exit point nel frame dell'ID m
for i = 1:W
	if(data(2,i) == m) % se l'ID è corretto (cioè == m)
		if(data(1,i) > maxi) % se il frame è maggiore di maxi
			maxi = data(1,i); % aggiorna maxi fino a trovare il frame exit point dell'ID m
		end
		if(data(1,i) < mini) % se il frame è minore di mini
			mini = data(1,i); % aggiorna mini fino a trovare il frame entry point dell'ID m
		end
	end
end

lo = zeros(3,maxi-mini+1); % coordinate nello spazio dell'ID
ve = zeros(3,maxi-mini); % velocità dell'ID
ac = zeros(3,maxi-mini-1); % accelerazione dell'ID

% assegna alla terza riga della matrice i frame in cui l'ID si muove all'interno del video
lo(3,:) = mini:maxi;

% riempie la matrice lo con la posizione X e Y di ID in ciascun frame
for i = 1:W % scorre data
    for j = 1:(maxi - mini + 1) % scorre lo
        if(data(2,i) == m && data(1,i) == lo(3,j)) % se l'ID è corretto e il frame corrisponde
            lo(1,j) = data(3,i); % X dell'ID
            lo(2,j) = data(4,i); % Y dell'ID
        end
    end
end

% riempie le matrici ve e ac con rispettivamente velocità e accelerazione di ID nel frame i
for i = 1:maxi-mini
        ve(1,i) = (lo(1,i+1) - lo(1,i)) * 25; % vX (moltiplica per 25fps in modo da ottenere la velocità per frame)
        ve(2,i) = (lo(2,i+1) - lo(2,i)) * 25; % vY (moltiplica per 25fps in modo da ottenere la velocità per frame)
        ve(3,i) = lo(3,i);
        if(i > 1)
            ac(1,i-1) = (ve(1,i) - ve(1,i-1)) * 25; % aX (moltiplica per 25fps in modo da ottenere la velocità per frame)
            ac(2,i-1) = (ve(2,i) - ve(2,i-1)) * 25; % aY (moltiplica per 25fps in modo da ottenere la velocità per frame)
            ac(3,i-1) = ve(3,i-1);
        end
end

% check sulla direzione di spostamento preponderante
% y = range(X) returns the difference between the maximum and minimum values of sample data in X.
RX = range(lo(1,:));
RY = range(lo(2,:));
if(RX > RY)
    XY = 1; % si sta spostando più orizzontalmente lungo X
else
    XY = 2; % si sta spostando più verticalmente lungo Y
end

%% Calculate all the forces on the Person 
fo = zeros(num_people+2,maxi-mini-1,4); % force from people and group
fo(1,:,1)=ac(3,:); % frame
target_X = lo(1, maxi-mini+1); % punto di uscita dell'ID in X
target_Y = lo(2, maxi-mini+1); % punto di uscita dell'ID in Y
for i = 1:maxi-mini-1
    if(target_X-lo(1,i+1) ~= 0) % ~ è la negazione in matlab
      fo(num_people+2,i,1) = ((target_X-lo(1,i+1))/sqrt((target_X-lo(1,i+1))^2+(target_Y-lo(2,i+1))^2))/0.5; % assume relaxtion time 0.5
    else
      fo(num_people+2,i,1) = 0;
    end
    if(target_Y-lo(2,i+1) ~= 0)
      fo(num_people+2,i,2) = ((target_Y-lo(2,i+1))/sqrt((target_X-lo(1,i+1))^2+(target_Y-lo(2,i+1))^2))/0.5; % assume relaxtion time 0.5
    else
      fo(num_people+2,i,2) = 0;
    end
end

for i = 1:W
    for j = 1:maxi-mini-1
        if(fo(1,j,1)==data(1,i)) % se il frame è corretto
            if(data(2,i) ~= m) % repulsive force > se l'ID non corrisponde all'individuo che si sta analizzando
                if(data(2,i) == 1 && m ~= 1) % computational convenient
                   fo(m,j,1) = lo(1,j+1) - data(3,i); % distanza X tra l'ID e il pedestrian considerato
                   fo(m,j,2) = lo(2,j+1) - data(4,i); % distanza Y tra l'ID e il pedestrian considerato
                   fo(m,j,3) = sqrt(fo(m,j,1)^2+fo(m,j,2)^2); % modulo vettore distanza tra ID e pedestrian considerato
                   if(data(5,i) ~= 0 && data(5,i) == group) % pedestrain with group information 
                       fo(m,j,4) = group;
                       fo(num_people+1,j,1) = fo(num_people+1,j,1) + data(3,i);
                       fo(num_people+1,j,2) = fo(num_people+1,j,2) + data(4,i);
                       fo(num_people+1,j,4) = fo(num_people+1,j,4) + 1;
                   end
                else
                   fo(data(2,i),j,1) = lo(1,j+1) - data(3,i);
                   fo(data(2,i),j,2) = lo(2,j+1) - data(4,i);
                   fo(data(2,i),j,3) = sqrt(fo(data(2,i),j,1)^2 + fo(data(2,i),j,2)^2);
                   if(data(5,i) ~= 0 && data(5,i) == group) % pedestrain with group information 
                       fo(data(2,i),j,4) = group;
                       fo(num_people+1,j,1) = fo(num_people+1,j,1) + data(3,i);
                       fo(num_people+1,j,2) = fo(num_people+1,j,2) + data(4,i);
                       fo(num_people+1,j,4) = fo(num_people+1,j,4) + 1;
                   end
                end
            end
        end
    end
end

%calculate group force
density_people = fo(num_people+1,:,4);
for i = 1:maxi-mini-1
        if(fo(num_people+1,i,4) ~= 0)      
              fo(num_people+1,i,4) = fo(num_people+1,i,4) + 1;
              fo(num_people+1,i,1) = (fo(num_people+1,i,1) + lo(1,1+i)) / fo(num_people+1,i,4) - lo(1,i+1);
              fo(num_people+1,i,2) = (fo(num_people+1,i,2) + lo(2,1+i)) / fo(num_people+1,i,4) - lo(2,i+1);
              fo(num_people+1,i,3) = sqrt(fo(num_people+1,i,1)^2 + fo(num_people+1,i,2)^2);
        end
end

%% Prepare Data 
d1 = 0.5; % first repulsive radius 
d2 = 1.0; % second repulsive radius 
d3 = 4.0; % third repulsive radius 

Subject_Data_X = zeros(maxi-mini-1,6); 
Subject_Score_X = zeros(1,maxi-mini-1);
Subject_Data_Y = zeros(maxi-mini-1,6);
Subject_Score_Y = zeros(1,maxi-mini-1);

for i = 1:maxi-mini-1

    Subject_Data_X(i,1) = fo(num_people+2,i,1);    % 1st column is desired speed force
    Subject_Data_Y(i,1) = fo(num_people+2,i,2);
    Subject_Score_X(1,i) = ac(1,i) + ve(1,i+1) / 0.5;    
    Subject_Score_Y(1,i) = ac(2,i) + ve(2,i+1) / 0.5;

    for j = 1:num_people

        if(fo(j,i,3) > d2 && fo(j,i,3) < d3) % 4th column is d2-d3 range
            
            if(group == 0)
              density_people(i) = density_people(i) + 1;
              Subject_Data_X(i,4) = Subject_Data_X(i,4) + (d3 - fo(j,i,3)) * fo(j,i,1) / fo(j,i,3) / (d3 - d2);
              Subject_Data_Y(i,4) = Subject_Data_Y(i,4) + (d3 - fo(j,i,3)) * fo(j,i,2) / fo(j,i,3) / (d3 - d2);
            end

        elseif(fo(j,i,3) > d1 && fo(j,i,3) < d2) % 3th column is d1-d2 range

            density_people(i) = density_people(i) + 1;
            Subject_Data_X(i,3) = Subject_Data_X(i,3) + (d2 - fo(j,i,3)) * fo(j,i,1) / fo(j,i,3) / (d2-d1);
            Subject_Data_Y(i,3) = Subject_Data_Y(i,3) + (d2 - fo(j,i,3)) * fo(j,i,2) / fo(j,i,3) / (d2-d1);
            Subject_Data_X(i,4) = Subject_Data_X(i,4) + fo(j,i,1) * (fo(j,i,3) - d1) / fo(j,i,3) / (d2-d1);
            Subject_Data_Y(i,4) = Subject_Data_Y(i,4) + fo(j,i,2) * (fo(j,i,3) - d1) / fo(j,i,3) / (d2-d1);

        elseif (fo(j,i,3) < d1 && fo(j,i,3) ~= 0) % 2nd column is <d1 range
            
            density_people(i) = density_people(i) + 1;
            Subject_Data_X(i,2) = Subject_Data_X(i,2) + (d1 - fo(j,i,3)) * fo(j,i,1) / fo(j,i,3) / d1;
            Subject_Data_Y(i,2) = Subject_Data_Y(i,2) + (d1 - fo(j,i,3)) * fo(j,i,2) / fo(j,i,3) / d1;
            Subject_Data_X(i,3) = Subject_Data_X(i,3) + fo(j,i,3) * fo(j,i,1) / fo(j,i,3) / d1;
            Subject_Data_Y(i,3) = Subject_Data_Y(i,3) + fo(j,i,3) * fo(j,i,2) / fo(j,i,3) / d1;

        end

    end
        
    if(fo(num_people+1,i,4) ~= 0)
    	
    	if(fo(num_people+1,i,3) > ((fo(num_people+1,i,4) - 1) / 2))
    		Subject_Data_X(i,6) = fo(num_people+1,i,1) / fo(num_people+1,i,3); % attraction force
    		Subject_Data_Y(i,6) = fo(num_people+1,i,2) / fo(num_people+1,i,3);  
    	end

        A = [fo(num_people+1,i,1) fo(num_people+1,i,2)]; % A = [B C] concatenation operator
        B = [ve(1,i+1) ve(2,i+1)];
        angel = acos(dot(A,B) / (norm(A) * norm(B)));
        angel = angel * 180 / pi;
        if(angel > 90)
        	angel = angel - 90;
        else
        	angel = 0;
        end
        if(angel > 45)
        	Subject_Data_X(i,5)=-angel*B(1)/(180); %vision force
        	Subject_Data_Y(i,5)=-angel*B(2)/(180);
        end
    end

end

% calcola la densità dello scenario (dense_or_not.m quindi a che serve ?)
people_inter = 0;
for i = mini+1:maxi-1
      people_in_scene = length(data(2,data(1,:)==i));
      if(density_people(i-mini) > people_in_scene/3)
          people_inter = people_inter + 1;
      end
end
if((people_inter/length(density_people)) >= 0.3)
    dense=1;
else
    dense=0;
end

