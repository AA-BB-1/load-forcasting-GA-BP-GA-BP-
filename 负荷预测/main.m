tic
% ��ջ�������
% ��ջ�������
clc
clear
rng('default');
rng(1);
% 
%% ����ṹ����

data_trian=xlsread('���ݼ�.xlsx');
data_test=xlsread('���ݼ�.xlsx',2);
input_train=data_trian(1:1092,1:3)';
output_train=data_trian(1:1092,60)';
input_test=data_test(1:14,1:3)';
output_test=data_test(1:14,60)';


%�ڵ����
inputnum=3;
hiddennum=4;
outputnum=1;


% %%��ȡ����
% load data1 
% %%ѵ�����ݺ�Ԥ������
% input_train=input(1:1900,:)';
% input_test=input(1901:2000,:)';
% output_train=output(1:1900)';
% output_test=output(1901:2000)';

%ѵ����������������ݹ�һ��
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);

%��������
net=newff(inputn,outputn,hiddennum);

%% �Ŵ��㷨������ʼ��
maxgen=100;                         %��������������������
sizepop=10;                        %��Ⱥ��ģ
pcross=[0.4];                       %�������ѡ��0��1֮��
pmutation=[0.2];                    %�������ѡ��0��1֮��

%�ڵ�����
numsum=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;

lenchrom=ones(1,numsum);                       %���峤��
bound=[-3*ones(numsum,1) 3*ones(numsum,1)];    %���巶Χ

individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��
avgfitness=[];                      %ÿһ����Ⱥ��ƽ����Ӧ��
bestfitness=[];                     %ÿһ����Ⱥ�������Ӧ��
bestchrom=[];                       %��Ӧ����õ�Ⱦɫ��
%���������Ӧ��ֵ
for i=1:sizepop
    %�������һ����Ⱥ
    individuals.chrom(i,:)=Code(lenchrom,bound);    %���루binary��grey�ı�����Ϊһ��ʵ����float�ı�����Ϊһ��ʵ��������
    x=individuals.chrom(i,:);
    %������Ӧ��
    individuals.fitness(i)=fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn);   %Ⱦɫ�����Ӧ��
end
FitRecord=[];
%����õ�Ⱦɫ��
[bestfitness bestindex]=min(individuals.fitness);
bestchrom=individuals.chrom(bestindex,:);  %��õ�Ⱦɫ��
avgfitness=sum(individuals.fitness)/sizepop; %Ⱦɫ���ƽ����Ӧ��
%��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
trace=[avgfitness bestfitness]; 

%% ���������ѳ�ʼ��ֵ��Ȩֵ
% ������ʼ
for i=1:maxgen
  
    % ѡ��
    individuals=select(individuals,sizepop); 
    avgfitness=sum(individuals.fitness)/sizepop;
    %����
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
    % ����
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
    
    % ������Ӧ�� 
    for j=1:sizepop
        x=individuals.chrom(j,:); %����
        individuals.fitness(j)=fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn);   
    end
    
    %�ҵ���С�������Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
    [newbestfitness,newbestindex]=min(individuals.fitness);
    [worestfitness,worestindex]=max(individuals.fitness);
    
    %���Ÿ������
    if bestfitness>newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end
    individuals.chrom(worestindex,:)=bestchrom;
    individuals.fitness(worestindex)=bestfitness;
    
    %��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
    avgfitness=sum(individuals.fitness)/sizepop;
    trace=[trace;avgfitness bestfitness]; 
    FitRecord=[FitRecord;individuals.fitness];
end

%% �����ų�ʼ��ֵȨֵ��������Ԥ��
% %���Ŵ��㷨�Ż���BP�������ֵԤ��
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);

net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=B2;

%% BP����ѵ��
%�����������
net.trainParam.epochs=100;
net.trainParam.lr=0.1;
%net.trainParam.goal=0.00001;

%����ѵ��
[net,per2]=train(net,inputn,outputn);

%% BP����Ԥ��
%���ݹ�һ��
inputn_test=mapminmax('apply',input_test,inputps);
an=sim(net,inputn_test);
test_simu=mapminmax('reverse',an,outputps);
error=test_simu-output_test;

%% �Ŵ��㷨������� 
figure(1)
[r c]=size(trace);
plot([1:r]',trace(:,2));
title(['��Ӧ������  ' '��ֹ������' num2str(maxgen)]);
xlabel('��������');ylabel('��Ӧ��');
legend('ƽ����Ӧ��','�����Ӧ��');

%% GA�Ż�BP����Ԥ��������
figure(2)
plot(test_simu,'b--.')
hold on
plot(output_test,'-b.');
legend('Ԥ�����','�������')
xlabel('��n��')
ylabel('����ֵ')
title('GA�Ż�BP����Ԥ�����','fontsize',12)

%Ԥ�����
error=test_simu-output_test;


figure(3)
plot((test_simu-output_test)./output_test,'-b.');
xlabel('��n��')
ylabel('������')
title('GA�Ż�BP������Ԥ��������','fontsize',12)

MAPE = mean(abs((test_simu-output_test)./output_test))

errorsum=sum(abs(error));
toc