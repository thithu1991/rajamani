function [chr4]=mutation(chr3,mpro)
sz=size(chr3);
nc=sz(1,1);
nv=sz(1,2);
%mpro=0.03;
%smpro = input('Enter Muation Probability (0.02 to 0.06):');
%chr4=zeros(nc,nv);
%k1=zeros(nc,nv);
r3=rand(nc,nv);
disp('Chromosomes before mutation and rno:');
disp('------------------------------------');
disp([chr3 r3]);
%xlswrite('d:/msk/optech/ga/r3',r3);
for i=1:nc
    for j=1:nv
        if (r3(i,j)<=mpro)
            if j==nv
              k=chr3(i,nv);
              chr3(i,j)=chr3(i,1);
              chr3(i,1)=k;
            else
               k=chr3(i,j+1);
               chr3(i,j+1)=chr3(i,j);
               chr3(i,j)=k;
            end
        else
            chr3(i,j)=chr3(i,j);
        end
    end
end
chr4=chr3;
disp('Chromosomes after mutation');
disp('----------------------- -----');
disp(chr4);
%xlswrite('d:/msk/mutation',[chr3 r3 chr4]);
end
