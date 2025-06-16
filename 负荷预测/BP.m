%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行
rng('default');
rng(0);

%%  导入数据
res1 = xlsread('数据集.xlsx');
res2 = xlsread('数据集.xlsx',2);

%%  划分训练集和测试集
temp = randperm(103);

P_train = res1(1012:1092,1:5)';
T_train = res1(1012:1092,60)';
M = size(P_train, 2);

P_test = res2(1:14,1:5)';
T_test = res2(1:14,60)';
N = size(P_test, 2);

%%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  创建网络
net = newff(p_train, t_train, 50);

%%  设置训练参数
net.trainParam.epochs = 100;     % 迭代次数 
net.trainParam.goal = 1e-6;       % 误差阈值
net.trainParam.lr = 0.01;         % 学习率

%%  训练网络
net= train(net, p_train, t_train);

%%  仿真测试
t_sim1 = sim(net, p_train);
t_sim2 = sim(net, p_test );

%%  数据反归一化
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);


%%  绘图

figure
plot(1: N, T_test, '-b.', 1: N, T_sim2, 'b--.')
legend('期望输出', '预测输出')
xlabel('第n天')
ylabel('负荷值')
title('BP神经网络预测输出','fontsize',12)


figure 
plot((T_sim2 - T_test)./T_test,'-b.');
xlabel('第n天')
ylabel('相对误差')
title('BP神经网络预测相对误差','fontsize',12)

%%  相关指标计算

MAPE = mean(abs((T_sim2 - T_test)./T_test))

