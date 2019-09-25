function [avg_num]=dense_or_not(data,frame)
  num_people=zeros(1,0);
  for i=1:frame
      people=data(2,data(1,:)==i);
      num=length(people);
      num_people=[num_people num];
  end
  num_people(num_people==0)=[];
  avg_num=median(num_people);
end