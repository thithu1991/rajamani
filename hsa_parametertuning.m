function [cpv] = hsa_parametertuning(pv,ll,ul,hmcr,par)
sz=size(pv);
ns=sz(1,1);nv=sz(1,2);
bw=0.2;
rhmcr=rand(ns,nv);rpar=rand(ns,nv);rno=rand(ns,nv);
rhno=randi(ns,ns,nv);
npv=zeros(ns,nv);
%improvization of tune
for i=1:ns
    for j=1:nv
        if (rhmcr(i,j)<hmcr)
            if (rpar(i,j)<par)
                npv(i,j)=pv(rhno(i,j),j)+rno(i,j)*bw;
            else
              npv(i,j)=pv(rhno(i,j),j);
            end
        else
            npv(i,j)=ll(1,j)+rand*(ul(1,j)-ll(1,j));
        end
    end
end
%check the improved tune
cpv=pv_chk(npv,ll,ul);
end

