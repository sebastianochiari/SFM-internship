%% Extarct the start and end destination of all persons
  data = importdata('eth_hotel.csv');
  [H,W]=size(data);
  data_sort=sort(data,2,'ascend');
  num_people=data_sort(2,W);
  data_out=zeros(8,num_people);
  for i=1:num_people
      [start_end,lo]=get_one_start_end(data,i);
      data_out(:,i)=start_end;
  end
  data_out=data_out';
  data_out(data_out(:,1)==0,:)=[];
  data_out=sortrows(data_out,2);
  %data_out(data(1,:)==0,:)={};
  dlmwrite('eth_hotel_start_end.csv',data_out, 'delimiter', ',','precision', 6,'newline', 'pc')