%% Read Data from real video
clc; clear;
raw_data = importdata('ucy_zara02_group1.txt','\t');
raw_data2 = importdata('ucy_zara02_group2.txt','\t');
raw_data=raw_data';           raw_data2=raw_data2';
[~,W1]=size(raw_data);        [~,W2]=size(raw_data2);
data=zeros(5,W1);             data2=zeros(5,W2);
data(1,:)=raw_data(1,:);      data2(1,:)=raw_data2(1,:);
data(2,:)=raw_data(2,:);      data2(2,:)=raw_data2(2,:);  
data(3,:)=raw_data(5,:);      data2(3,:)=raw_data2(5,:);
data(4,:)=raw_data(3,:);      data2(4,:)=raw_data2(3,:);
data(5,:)=raw_data(9,:);      data2(5,:)=raw_data2(9,:);
data=[data,data2];
data_sort=sort(data,2,'ascend'); %row rank to get some parameters
num_people=data_sort(2,W1+W2);
%% Read Data from simulation
default_data = importdata('ucy_zara02_default1.txt','\t');
default_data2 = importdata('ucy_zara02_default2.txt','\t');
default_data=default_data';           default_data2=default_data2';
[~,L1]=size(default_data);            [~,L2]=size(default_data2);
data3=zeros(5,L1);                    data4=zeros(5,L2);
data3(1,:)=default_data(1,:);         data4(1,:)=default_data2(1,:);
data3(2,:)=default_data(2,:);         data4(2,:)=default_data2(2,:);  
data3(3,:)=default_data(5,:);         data4(3,:)=default_data2(5,:);
data3(4,:)=default_data(3,:);         data4(4,:)=default_data2(3,:);
data3(5,:)=default_data(9,:);         data4(5,:)=default_data2(9,:);
data_real=[data3,data4];
%% Read Data from ground truth
data_truth = importdata('ucy_zara02.csv');
[H,W]=size(data_truth);
%% Compare the trajectory
de=zeros(1,num_people);
diff=zeros(1,0);
corr=zeros(1,0);
deri=zeros(1,0);
dtw_d=zeros(1,0);
figure 
for i=1:num_people
    lo1=calc_location(data_real,i);
    lo2=calc_location(data,i);
    lo3=calc_location(data_truth,i);
     plot(lo1(1,:),lo1(2,:),'-r', 'LineWidth', 2);
     ylim([-12,4]);
     xlim([-12,12]);  
     xlabel('X axis');ylabel('Y axis');
     title('Trajectory Comparison')
     hold on 
     plot(lo2(1,:),lo2(2,:),'-b', 'LineWidth', 2);
     plot(lo3(1,:),lo3(2,:),'-y', 'LineWidth', 2);
     legend('default SFM','learned SFM','ground truth');
     hold off
     %saveas(gcf,['./','default_traj/ucy_zara02/',num2str(i),'.png']);
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