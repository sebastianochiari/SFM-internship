function [ade,diff,corr,deri,dtw_d]=calc_diff_non(lo1,lo2)
[~,W1]=size(lo1);
[~,W2]=size(lo2);
W=min(W1,W2);
%lo1=lo1(:,W); lo2=lo2(:,W);
diff=sqrt((lo2(1,1:W)-lo1(1,1:W)).^2+(lo2(2,1:W)-lo1(2,1:W)).^2);      
corr=corr2(lo1(1:2,1:W),lo2(1:2,1:W));
deri=std(complex(lo2(1,1:W)-lo1(1,1:W),lo2(2,1:W)-lo1(2,1:W)));
ade=mean(diff);
%dtw_d=dtw(lo1(1:2,:),lo2(1:2,:));
dtw_d=dtw(lo2(1:2,:),lo1(1:2,:))/W;
return