function [chr2]=sel_rep(chr1,ofn)
nfn=exp(-0.5*ofn);
sz=size(chr1);
nc=sz(1,1);
nv=sz(1,2);
cpro=zeros(nc,1);
chr2=zeros(nc,nv);
pro=nfn/sum(nfn);
for i=1:nc
    cpro(i,1)=sum(pro(1:i,1));
end
rnd=rand(nc,1);
for i=1:nc
    nu=find(cpro>rnd(i,1),1);
    chr2(i,:)=chr1(nu,:);
end
disp('Chromosomes,ffn,nffn pro, cpro and rno:');
disp('---------------------------------------');
disp([chr1 ofn nfn pro cpro rnd]);
%xlswrite('d:/msk/sel_rep',[chr1 ofn nfn pro cpro rnd]);
disp('Chromosomes after selection for eproduction:');
disp('--------------------------------------------');
disp(chr2);
end
