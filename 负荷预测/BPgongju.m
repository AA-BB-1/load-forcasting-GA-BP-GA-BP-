tic
clear all
clc;
rng('default');
rng(0);
data_trian=xlsread('数据集.xlsx');
data_test=xlsread('数据集.xlsx',2);
traind=data_trian(1:1092,1:5);
trainl=data_trian(1:1092,60);
testd=data_test(1:14,1:5);
testl=data_test(1:14,60)';
%对训练集中的输入数据矩阵和目标数据矩阵进行归一化处理
 traind_n=nomalp(traind)';% 输入矩阵（变量数 x 样本数）数据归一化
 output=(nomalp(trainl))';% 目标矩阵（目标数 x 样本数）
 testd_n=nomalp(testd)';
 testl_n=nomalp(trainl);																	
%% 2、训练网络 
net = newff(traind_n,output, 4);  					% 定义网络结构，一个隐含层，含50个神经元
net.trainparam.epochs = 100;
net.trainparam.goal = 0.0001 ;
net.trainParam.lr = 0.1 ;
net = train(net,traind_n,output);  					% 训练网络
outputs = net(testd_n);            					% 训练结果
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


%% 3、可视化  
figure(1)
plot(1:14, testl,'-b.'); hold on   	% 绘制真实目标曲线
plot(1:14, out_out2, 'b--.');               	% 绘制拟合结果
legend('期望输出', '预测输出'); hold off
xlabel('第n天')
ylabel('负荷值')
title('BP神经网络预测输出','fontsize',12)

figure(2) 
plot((out_out2 - testl')./testl','-b.');
xlabel('第n天')
ylabel('相对误差')
title('BP神经网络预测相对误差','fontsize',12)

toc


