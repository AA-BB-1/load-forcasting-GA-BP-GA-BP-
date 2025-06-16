%%  ��ջ�������
warning off             % �رձ�����Ϣ
close all               % �رտ�����ͼ��
clear                   % ��ձ���
clc                     % ���������
rng('default');
rng(0);

%%  ��������
res1 = xlsread('���ݼ�.xlsx');
res2 = xlsread('���ݼ�.xlsx',2);

%%  ����ѵ�����Ͳ��Լ�
temp = randperm(103);

P_train = res1(1012:1092,1:5)';
T_train = res1(1012:1092,60)';
M = size(P_train, 2);

P_test = res2(1:14,1:5)';
T_test = res2(1:14,60)';
N = size(P_test, 2);

%%  ���ݹ�һ��
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  ��������
net = newff(p_train, t_train, 50);

%%  ����ѵ������
net.trainParam.epochs = 100;     % �������� 
net.trainParam.goal = 1e-6;       % �����ֵ
net.trainParam.lr = 0.01;         % ѧϰ��

%%  ѵ������
net= train(net, p_train, t_train);

%%  �������
t_sim1 = sim(net, p_train);
t_sim2 = sim(net, p_test );

%%  ���ݷ���һ��
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);


%%  ��ͼ

figure
plot(1: N, T_test, '-b.', 1: N, T_sim2, 'b--.')
legend('�������', 'Ԥ�����')
xlabel('��n��')
ylabel('����ֵ')
title('BP������Ԥ�����','fontsize',12)


figure 
plot((T_sim2 - T_test)./T_test,'-b.');
xlabel('��n��')
ylabel('������')
title('BP������Ԥ��������','fontsize',12)

%%  ���ָ�����

MAPE = mean(abs((T_sim2 - T_test)./T_test))

