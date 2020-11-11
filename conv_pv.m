function [pv]=conv_pv(ip,chr1)
sz=size(chr1);
nc=sz(1,1);
nv=sz(1,2);
pv=zeros(nc,nv);
for i=1:nc
    pv(i,:)=ip(1,:)+chr1(i,:).*(ip(2,:)-ip(1,:));
end
disp('Initial values of variables:');
disp('----------------------------');
disp(pv);
end
