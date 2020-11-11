function [opterr aerr acerr ofis ndt]=eval_mrr_anfis(pv,data_mrr)
ns=size(data_mrr,1);
ns1=size(pv,1);nv=size(data_mrr,2)-1;epn=30;
xin=data_mrr(:,1:nv);xout=data_mrr(:,nv+1);
aerr=zeros(epn,ns1);
acerr=zeros(epn,ns1);
oerr=zeros(ns1,1);
ocerr=zeros(ns1,1);
rms=zeros(ns1,1);
mape=zeros(ns1,1);
%ofis=zeross(ns1,1);
ndt=zeros(ns1,1);
for i=1:ns1
    ndt(i,1)=round(ns*pv(i,2+nv));
    trndata=data_mrr(1:ndt(i,1),1:5);
    chkdata=data_mrr(1+ndt(i,1):end,1:5);
    infis=genfis2(xin,xout,pv(i,1:nv+1),[],[pv(i,7) 0.5 0.15 0]);
    %[fis,err]=anfis(trndata,infis,30);
    [fis,err,stp,cfis,cerr]=anfis(trndata,infis,epn,[],chkdata,1);
    aerr(:,i)=err;
    acerr(:,i)=cerr;
    oerr(i,1)=min(err);
    ocerr(i,1)=min(cerr);
    rms(i,1)=sqrt(mean((data_mrr(:,nv+1)-evalfis(data_mrr(:,1:nv),cfis)).^2));
    mape(i,1)=mean(100*abs((data_mrr(:,nv+1)-evalfis(data_mrr(:,1:nv),cfis))./data_mrr(:,nv+1)));
    ofis{i,1}=cfis;
end
opterr=[oerr ocerr rms mape];
end
