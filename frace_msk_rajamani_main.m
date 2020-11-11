%Program to tune HSA parameters using F-race method
clc;
clear all;
close all;
%read parameter tuning data
ipop=xlsread('c:/hsa_data');
%itertion start here
ns=size(ipop,1);
itr=1;
i1=1;
while (ns>5)
    clear rcon;
    ns=size(ipop,1);
    %block size
    bs=5;
    nitr=fix(ns/bs);
    pseq=randperm(ns);
    sn=1;
    k=1;
    for it=1:nitr
        pos=0;
        en=it*bs;
        seq=pseq(1,sn:en);
        for i=1:bs
            ip(i,:)=ipop(seq(1,i),:);
        end
        op(sn:en,:)=ip;
        %friedman test
        [fp, ft, fs]=friedman(ip',1,'off');
        fmp(it,:)=[fp seq fs.meanranks];
        rk=sortrows([(1:bs)' (fs.meanranks)'],2);
        %best configuration
        bst=rk(1,1);
        if fp<0.05
            for i=1:bs
                if i~=bst
                    disp([seq(1,i) seq(1,bst)]);
                    %pairwise t test
                    [h p]=ttest(ip(:,bst),ip(:,i));
                    tt(i,:)=[h p];
                    if p<0.05
                        pos=1;
                        rcon(k,1)=seq(1,i);
                        k=k+1;
                    end
                end           
            end
         end
        sn=en+1;
    end
    if pos==1
        disp(rcon);
        sz(itr,1)=ns-size(rcon,1);
        %removing the worst configuration from the initial parametric configuration PC
        ipop(rcon,:)=[];
    else
        if itr==1
            sz(itr,1)=ns;
        else
            sz(itr,1)=sz(itr-1,1);
        end
    end
    %next race
    itr=itr+1;
    if itr>3500
        break;
    end
end
disp(size(ipop,1));
%performance of F-race
plot(1:itr-1,sz(:,1),'-r','linewidth',1.75);
xlswrite('c:/fraceopt',ipop);