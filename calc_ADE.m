%% Read Data from real video
clc; clear;
raw_data = importdata('eth_univ_group.txt','\t');
raw_data2 = importdata('ucy_univ_dense2.txt','\t');
raw_data=raw_data';           %raw_data2=raw_data2';
[~,W1]=size(raw_data);        %[~,W2]=size(raw_data2);
data=zeros(5,W1);             %data2=zeros(5,W2);
data(1,:)=raw_data(1,:);      %data2(1,:)=raw_data2(1,:);
data(2,:)=raw_data(2,:);      %data2(2,:)=raw_data2(2,:);  
data(3,:)=raw_data(5,:);      %data2(3,:)=raw_data2(5,:);
data(4,:)=raw_data(3,:);      %data2(4,:)=raw_data2(3,:);
data(5,:)=raw_data(9,:);     % data2(5,:)=raw_data2(9,:);
%data=[data,data2];
data_sort=sort(data,2,'ascend'); %row rank to get some parameters
num_people=data_sort(2,W1);
%% Read Data from simulation
data_real = importdata('eth_univ.csv');
[H,W]=size(data_real);
%% Compare the trajectory
de=zeros(1,num_people);
diff=zeros(1,0);
corr=zeros(1,0);
deri=zeros(1,0);
dtw_d=zeros(1,0);
%figure 
for i=1:num_people
    lo1=calc_location(data_real,i);
    lo2=calc_location(data,i);
%      plot(lo1(1,:),lo1(2,:),'-r', 'LineWidth', 2);
%      ylim([-10,10]);
%      xlim([-10,10]); 
%      hold on 
%      plot(lo2(1,:),lo2(2,:),'-b', 'LineWidth', 2);
%      legend('ground truth','simulation');
%      hold off
%      saveas(gcf,['./','default_traj/ucy_zara01/',num2str(i),'.jpg']);
    if(length(lo2)>3 && length(lo1)>3)
     [de(1,i),diff_temp,corr_temp,deri_temp,dtw_temp]=calc_diff_non(lo1,lo2);
     diff=[diff,diff_temp];
     corr=[corr,corr_temp];
     deri=[deri,deri_temp];
     dtw_d=[dtw_d,dtw_temp];
    end
end
hold off
de(isnan(de))=[];
corr(isnan(corr))=[];
diff(isnan(diff))=[];
ade1=mean(de)
corr_mean=mean(abs(corr))
der_mean=mean(deri)
dtw_mean=mean(dtw_d)
%ade2=mean(diff);
%% Plot the trajectory
 lo1=calc_location(data_real,1);
 lo2=calc_location(data,1);
 [ade_lo,diff_lo]=calc_diff(lo1,lo2);
 ve1=zeros(1,length(lo1)-1);
 ve2=zeros(1,length(lo2)-1);
 for i=1:length(lo1)-1
     ve1(1,i)=sqrt((lo1(1,i+1)-lo1(1,i))^2+(lo1(2,i+1)-lo1(2,i))^2)*25;
 end
 for i=1:length(lo2)-1
     ve2(1,i)=sqrt((lo2(1,i+1)-lo2(1,i))^2+(lo2(2,i+1)-lo2(2,i))^2)*25;
 end
plot(lo1(1,:),lo1(2,:),'-r', 'LineWidth', 2);
ylim([-10,10]);
xlim([-5,5]); 
hold on
plot(lo2(1,:),lo2(2,:),'-b', 'LineWidth', 2);
legend('ground truth','simulation');
hold off