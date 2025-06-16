tic
clear all
clc;
rng('default');
rng(0);
data_trian=xlsread('���ݼ�.xlsx');
data_test=xlsread('���ݼ�.xlsx',2);
traind=data_trian(1:1092,1:5);
trainl=data_trian(1:1092,60);
testd=data_test(1:14,1:5);
testl=data_test(1:14,60)';
%��ѵ�����е��������ݾ����Ŀ�����ݾ�����й�һ������
 traind_n=nomalp(traind)';% ������󣨱����� x �����������ݹ�һ��
 output=(nomalp(trainl))';% Ŀ�����Ŀ���� x ��������
 testd_n=nomalp(testd)';
 testl_n=nomalp(trainl);																	
%% 2��ѵ������ 
net = newff(traind_n,output, 4);  					% ��������ṹ��һ�������㣬��50����Ԫ
net.trainparam.epochs = 100;
net.trainparam.goal = 0.0001 ;
net.trainParam.lr = 0.1 ;
net = train(net,traind_n,output);  					% ѵ������
outputs = net(testd_n);            					% ѵ�����
out_out2=enomalp(outputs',testl');
out_out3=out_out2; 
for i=1:10
    out_out2(i)=fix(out_out2(i));
    temp=out_out3(i)-out_out2(i);
    if(temp>=0.5)
        out_out2(i)=out_out2(i)+1;
    end
end

MAPE = mean(abs((out_out2 - testl')./testl')) 


%% 3�����ӻ�  
figure(1)
plot(1:14, testl,'-b.'); hold on   	% ������ʵĿ������
plot(1:14, out_out2, 'b--.');               	% ������Ͻ��
legend('�������', 'Ԥ�����'); hold off
xlabel('��n��')
ylabel('����ֵ')
title('BP������Ԥ�����','fontsize',12)

figure(2) 
plot((out_out2 - testl')./testl','-b.');
xlabel('��n��')
ylabel('������')
title('BP������Ԥ��������','fontsize',12)

toc


