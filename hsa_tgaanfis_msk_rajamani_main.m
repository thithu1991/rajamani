%Program for HSA 
clc;
clear all;
close all;
%to read input parameters and its response values
fn=xlsread('c:/awjm_ipop');
data_mrr=fn(:,1:5);
data_kerf=fn(:,[1:4 6]);
data_sr=fn(:,[1:4 7]);
%weight and objective type (Maximization =2; Minnimization =1)
wt=[0.333 0.333 0.333;2 1 1];
nv=4;no=3;
%computing lower and upper limit
ll=min(data_mrr(:,1:4));
ul=max(data_mrr(:,1:4));
%Read anfis files 
anfis_mrr=readfis('c:/mrr_anfis');
anfis_kerf=readfis('c:/kerf_anfis');
anfis_sr=readfis('c:/sr_anfis');
%initialization of HSA parameter
ns=30;
hmcr=0.9;
par=0.5;
nitr=75;
figure
%initialization of parameter values
pv=init_var(ns,ll,ul);
bst=zeros(nitr,1+nv+no);
for i=1:nitr
    %evaluation
    mrr=evalfis(pv,anfis_mrr);
    kerf=evalfis(pv,anfis_kerf);
    sr=evalfis(pv,anfis_sr);
    %conversion of multiobjective into single objective
    mo=[mrr kerf sr];
    [so]=topsis_fun(mo,wt);
    pvov=[pv mo so];
    %selection of best one
    st1=sortrows(pvov,-(1+nv+no));
    if i==1
        bst(i,:)=st1(1,:);
    else
        mo1=[bst(1:i-1,nv+1:nv+no);st1(1,1+nv:nv+no)];
        so1=topsis_fun(mo1,wt);
        st2=sortrows([(1:i)' so1],-2);
        if (st2(1,1)==i)
            bst(i,:)=st1(1,:);
        else
            bst(i,:)=bst(i-1,:);
        end
    end
    %hsa
    [cpv] = hsa_parametertuning(pv,ll,ul,hmcr,par);
    %replacement
    pv=cpv;
end
mo2=bst(:,nv+1:nv+no);
%conversion of multiple to single objective
so2=topsis_fun(mo2,wt);
%plot the performance of HSA
pp=plot(1:nitr,so2','-r','linewidth',1.75);
xlabel('Iteration No.');ylabel('Conversion value of MO');
title('Performance of HSA');
st1=strcat('c:/',num2str(ns),num2str(nitr),num2str(hmcr*10),num2str(par*10),'r1');
%write output into xls file
xlswrite(st1,[bst so2]);
%save the performance of the HSA
saveas(pp,strcat(st1),'jpg');