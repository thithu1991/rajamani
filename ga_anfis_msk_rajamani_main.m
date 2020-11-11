%----Program to generate ANFIS Model for the given parameters 
clc;
clear all;
close all;
%reading input data of lower and upper bound values of ANFIS parameters
ip=[0.13 0.13 0.13 0.13 0.13 0.65 2;0.5 0.5 0.5 0.5 0.5 0.8 3];
nv=size(ip,2);
disp('The lower and upper bound values of variables:');
disp('----------------------------------------------');
disp(ip);
%read input parameter values and its corresponding response value
fn1=xlsread('c:/awjm_ipop');
data_mrr=fn1(:,[1:4 6]);
wt=[0.5 05; 1 1];
ns=size(data_mrr,1);
%to find coefficients of MLRM equation
mrreqn=regstats(data_mrr(:,5),data_mrr(:,1:4),'quadratic');
cof=mrreqn.beta;
calv=zeros(ns,1);
f1=x2fx(data_mrr(:,1:4),'quadratic');
for i=1:ns
    calv(i,1)=sum(f1(i,:).*cof');
end
mape1=mean(100*abs(calv-data_mrr(:,5))./data_mrr(:,5));
rms1=sqrt(mean((calv-data_mrr(:,5)).^2));
ns=size(fn1,1);
epn=30; 
%------------GA parameters
%no. of chromosomes (ns1) 20 30 40
%change cross over probability (copro) 0.35 to 0.6
% change mutation probability (mpro) 0.02 to 0.06
%itr=100 150 200
ns1=20;
copro=0.45;
mpro=0.025;
itr=15;
nc=ns1;
str2=strcat('np',num2str(ns1), 'cp', num2str(copro), 'mp',num2str(mpro), 'nitr',num2str(itr));
rslt1=zeros(itr,13);
%initializing the population
[chr1]=pop_ini(nv,nc);
for i=1:itr
    %conversion of random no. into parameters value
    pv=conv_pv(ip,chr1);
    %evaluation of mrr values
    [opterr aerr acerr ofis ndt]=eval_mrr_anfis(pv,data_mrr);
    mrr=opterr(:,2);
    %selecting the best one
    [bfis bst err cerr]=bst_mrr_anfis(pv,opterr,aerr,acerr,ofis,ndt);
    rerr(:,i)=err;
    rcerr(:,i)=cerr;
    %storing the result
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
disp([bsto(1,11:12); rms1 mape1]);
%plotting the graph 
%{
h=plot(1:itr,rslt1(:,12),'-r','linewidth',1.75);
xlabel('No. of Iteration');
ylabel('RMSE');
title('No. of Iteration Vs RMSE');
%}
fn=strcat('c:/mrr_',str2,'final');
writefis(rfis{bstr(1,1),1},fn);
%to plot surface plot remove %{ and %}
%{
h=plot(1:itr,rslt1(:,12),'-r','linewidth',1.75);
xlabel('No. of Iteration');
ylabel('RMSE');
title('No. of Iteration Vs RMSE');
saveas(h,'c:/mrr_anfis_per.jpg');
xlswrite('c:/mrr_rslt1',rslt1);
disp('Best Fis');disp(bsto);
fn=strcat('c:/mrr_fopt1');
xlswrite(fn,bsto);
writefis(rfis{bstr(1,1),1},fn);
rms=sqrt(mean((data_mrr(:,5)-evalfis(data_mrr(:,1:4),rfis{bstr(1,1),1})).^2));
mape=mean(100*abs((data_mrr(:,5)-evalfis(data_mrr(:,1:4),rfis{bstr(1,1),1}))./data_mrr(:,5)));
%disp([mape rms mape1 rms1 oerr(bstr(1,1),1) ocerr(bstr(1,1),1)]);
xlswrite('c:/mrrganf2_bopt',[bstr(1,:) 0.5 0.15 0 mape rms mape1 rms1]);
h12=figure;
gensurf(rfis{bstr(1,1),1},[1 2],1,[30 30])
xlabel('Nano Clay-wt. %');ylabel('Jet Pressure-MPa');zlabel('MRR-g/min');
saveas(h12,'c:/mrrga_anfis12.jpg');
h13=figure;
gensurf(rfis{bstr(1,1),1},[1 3],1,[30 30])
xlabel('Nano Clay-wt. %');ylabel('Stand-off Distance-mm');zlabel('MRR-g/min');
saveas(h13,'c:/mrrga_anfis13.jpg');
h14=figure;
gensurf(rfis{bstr(1,1),1},[1 4],1,[30 30])
xlabel('Nano Clay-wt. %');ylabel('Traverse Speed-mm/min');zlabel('MRR-g/min');
saveas(h14,'c:/mrrga_anfis14.jpg');
h24=figure;
gensurf(rfis{bstr(1,1),1},[2 4],1,[30 30])
xlabel('Jet Pressure-MPa');ylabel('Traverse Speed-mm/min');zlabel('MRR-g/min');
saveas(h24,'c:/mrrga_anfis24.jpg');
h23=figure;
gensurf(rfis{bstr(1,1),1},[2 3],1,[30 30])
xlabel('Jet Pressure-MPa');ylabel('Stand-off Distance-mm');zlabel('MRR-g/min');
saveas(h23,'c:/mrrga_anfis23.jpg');
h34=figure;
gensurf(rfis{bstr(1,1),1},[3 4],1,[30 30])
xlabel('Stand-off Distance-mm');ylabel('Traverse Speed-mm/min');zlabel('MRR-g/min');
saveas(h34,'c:/mrrga_anfis34.jpg');
h1=figure;
plot(1:epn,rerr(:,bstr(1,1))','ro',1:epn,rcerr(:,bstr(1,1))','b+','linewidth',1.75);
xlabel('Epoch Number');ylabel('Error');
legend({'Training Error','Checking Error'},'location','best');
saveas(h1,'c:mrrga_anfis_err.jpg');
disp([mape mape1 rms rms1]);
save('c:/mrrfis','rfis');
%}


