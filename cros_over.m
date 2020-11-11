function [chr3]=cros_over(chr2,copro)
%copro=0.40;
%copro = input('Enter Cross Over Probability (0.4 to 0.6):');
sz=size(chr2);
nc=sz(1,1);
nv=sz(1,2);
chr3=zeros(nc,nv);
%cpt=fix(1+rand(nc,1)*nv);
cpt=1+randint(nc,1,nv);
r2=rand(nc,1);
%xlswrite('d:/msk/ayyappan/gce/r2',r2,'sheet1');
%xlswrite('d:/msk/ayyappan/gce/r2',cpt,'sheet1');
for i=1:nc
    if r2(i,1)<=copro
        %j=cpt(i)+1;
        if (cpt(i)~= nv)
            k=nv-cpt(i);
            chr3(i,1:k)=chr2(i,1+cpt(i):nv);
            k1=k+1;
            chr3(i,k1:nv)=chr2(i,1:cpt(i));
        else
            ro=nv:-1:1;
            chr3(i,:)=chr2(i,ro);
        end
    else
        chr3(i,:)=chr2(i,:);
    end
end
disp('Chromosomes before cross over and rno:');
disp('---------------------------------------');
disp([chr2 r2]);
disp('Cutting point:');
disp('-------------:');
disp(cpt);
disp('Chromosomes after cross over:');
disp('-----------------------------');
disp(chr3);
%xlswrite('d:/msk/cros_over',[chr2 r2 cpt chr3]);s
end
