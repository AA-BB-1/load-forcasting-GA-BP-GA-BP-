%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行
rng('default');
rng(0);

%%  导入数据
res = xlsread('数据集.xlsx');

%%  划分训练集和测试集
temp = randperm(103);

P_train = res(temp(1: 80), 1: 7)';
T_train = res(temp(1: 80), 8)';
M = size(P_train, 2);

P_test = res(temp(81: end), 1: 7)';
T_test = res(temp(81: end), 8)';
N = size(P_test, 2);

%%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  创建网络
net = newff(p_train, t_train, 10);

%%  设置训练参数
net.trainParam.epochs = 10;     % 迭代次数 
net.trainParam.goal = 1e-6;       % 误差阈值
net.trainParam.lr = 0.1;         % 学习率

%%  训练网络
net= train(net, p_train, t_train);

%%  仿真测试
t_sim1 = sim(net, p_train);
t_sim2 = sim(net, p_test );

%%  数据反归一化
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  均方根误差
error1 = sqrt(sum((T_sim1 - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2 - T_test ).^2) ./ N);

%%  绘图

figure
plot(1: N, T_test, '-r.', 1: N, T_sim2, '-b.')
legend('期望输出', '预测输出')
title('BP神经网络预测输出','fontsize',12)


%figure 
%plot((T_sim2 - T_test')./T_test','-b.');
%title('BP神经网络预测误差百分比','fontsize',12)

%%  相关指标计算

MAPE = mean(abs((T_sim2 - T_test)./T_test))

