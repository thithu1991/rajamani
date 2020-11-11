function [cpv] = pv_chk(pv,ll,ul)
sz=size(pv);ns=sz(1,1);nv=sz(1,2);
for i=1:ns
    for j=1:nv
        if (pv(i,j) < ll(1,j) || pv(i,j)>ul(1,j))
            pv(i,j)=ll(1,j)+rand*(ul(1,j)-ll(1,j));
        end
    end
end
cpv=pv;
end

