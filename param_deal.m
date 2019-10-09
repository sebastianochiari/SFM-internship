%% Read individual parameters
data = importdata('ucy_univ_param.csv');
[H,W] = size(data);
data_auth = data(data(:,2)>0,:);
data_auth = data_auth(abs(data_auth(:,6))<data_auth(:,2),:);
data_auth = data_auth(abs(data_auth(:,7))<data_auth(:,2),:);

%% Abandon the param if unnormal parameter exist
for i = 1:H
    if(data(i,2) < 0)
        data(i,2:7) = mean(data_auth(:,2:7));
    end
    if(abs(data(i,6)) > data(i,2))
        data(i,2:7) = mean(data_auth(:,2:7));
    end
    if(abs(data(i,7)) > data(i,2))
        data(i,2:7) = mean(data_auth(:,2:7));
    end
end

%% Output the data
data(data(:,2) == 0,:) = [];
dlmwrite('ucy_univ_param.csv',data, 'delimiter', ',','precision', 6,'newline', 'pc')