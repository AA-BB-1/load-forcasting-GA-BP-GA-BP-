
function output=enomalp(nomalp,ongnizep)

[~,w]=size(ongnizep);

mm=mean(ongnizep);%每行求平均值

ml=[1:w];

for i=1:w
    output(:,i)=ongnizep(:,i)-mm(1,i); 
end

for i=1:w
    ml(i)=std(output(:,i));
end

for i=1:w
    if ml(i)==0;
    else   
         output(:,i)=output(:,i)/ml(i);
    end
end

for i=1:w
    if ml(i)==0;
    else   
         output(:,i)=nomalp(:,i)*ml(i)+mm(1,i);
    end
end
end
