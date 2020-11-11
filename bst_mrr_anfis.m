function [bofis bst err cerr]=bst_mrr_anfis(pv,opterr,aerr,acerr,ofis,ndt)
ns1=size(pv,1);
%wt=[0.5 0.5;1 1];
%[c]=topsis_fun(opterr(:,3:4),wt);
%bst1=[(1:ns1)' pv opterr c];
bst1=[(1:ns1)' pv opterr ndt];
%st1=sortrows(bst1,13);
st1=sortrows(bst1,12);
bofis=ofis{st1(1,1),1};
bst=st1(1,:);
err=aerr(:,st1(1,1));
cerr=acerr(:,st1(1,1));
end