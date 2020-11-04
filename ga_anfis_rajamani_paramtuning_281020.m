clc;
clear all;
close all;
%path c:/msk/optech/gct cbe/ga/ga_anfis_rajamani
%reading input data of lower and upper bound values of parameters
ip=[0.13 0.13 0.13 0.13 0.13 0.65 2;0.5 0.5 0.5 0.5 0.5 0.8 3];
nv=size(ip,2);
disp('The lower and upper bound values of variables:');
disp('----------------------------------------------');
disp(ip);
fn1=xlsread('d:/parameter tuning/awjm_ipop');
data_mrr=fn1(:,[1:4 7]);
wt=[0.5 05; 1 1];
ns=size(data_mrr,1);

mrreqn=regstats(data_mrr(:,5),data_mrr(:,1:4),'quadratic');
cof=mrreqn.beta;
calv=zeros(ns,1);
f1=x2fx(data_mrr(:,1:4),'quadratic');
for i=1:ns
    calv(i,1)=sum(f1(i,:).*cof');
end
mape1=mean(100*abs(calv-data_mrr(:,5))./data_mrr(:,5));
%rms1=sqrt(mrreqn.mse);
rms1=sqrt(mean((calv-data_mrr(:,5)).^2));

%data_kerf=fn1(:,[1:4 6]);
%data_mrr=fn1(:,[1:4 6]);
%data_sr=fn1(:,[1:4 7]);
%data_mrr=fn1(:,[1:4 7]);
ns=size(fn1,1);
epn=30; 
%p=0.75;
%change cross over probability 0.35 to 0.6
% change mutation probability 0.02 to 0.06
%itr=30 50 70
ns1=20;
copro=0.45;
mpro=0.025;
itr=50;
nc=ns1;
str2=strcat('np',num2str(ns1), 'cp', num2str(copro), 'mp',num2str(mpro), 'nitr',num2str(itr));
rslt1=zeros(itr,13);
%initializing the population
[chr1]=pop_ini(nv,nc);
%xlswrite('c:/msk/chr1',chr1);
for i=1:itr
    %conversion of random no. into parameters value
    pv=conv_pv(ip,chr1);
    %evaluation of mrr values
    [opterr aerr acerr ofis ndt]=eval_mrr_anfis(pv,data_mrr);
    %mrr=topsis_fun(opterr(:,3:4),wt);
    mrr=opterr(:,2);
    %xlswrite('c:/msk/pv_mrr',pv_mrr);
    %selecting the best one
    [bfis bst err cerr]=bst_mrr_anfis(pv,opterr,aerr,acerr,ofis,ndt);
    rerr(:,i)=err;
    rcerr(:,i)=cerr;
    %storing the result
    %rslt1(i,:)=bst;
    rfis{i,1}=bfis;
    if i==1
      rslt1(i,:)=bst;
    else
        b2=rslt1(i-1,12);
        if bst(1,12)<b2
            rslt1(i,:)=bst;
        else
            rslt1(i,:)=rslt1(i-1,:);
        end
    end 
    %selection for reproduction
    [chr2]=sel_rep(chr1,mrr);
    %cross over
    [chr3]=cros_over(chr2,copro);
    %Mutation
    [chr4]=mutation(chr3,mpro);
    %100% replacement
    chr1=chr4;
end
rslt1(:,1)=(1:itr)';
%display the best one in all iteration
bstr=sortrows(rslt1,12);
bsto=bstr(1,:);
disp('The best in all the iteration is:');
disp(bsto(1,:));
disp([bsto(1,11:12)]);
%plotting the graph 

h=plot(1:itr,rslt1(:,12),'-r','linewidth',1.75);
xlabel('No. of Iteration');
ylabel('RMSE');
title('No. of Iteration Vs RMSE');


fn=strcat('d:/parameter tuning/haz_',str2,'r1');
writefis(rfis{bstr(1,1),1},fn);

