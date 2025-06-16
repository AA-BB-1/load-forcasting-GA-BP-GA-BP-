clear all
clc;

% ��ȡ���ݼ�
data1 = xlsread('���ݼ�.xlsx');
data2 = xlsread('���ݼ�.xlsx', 2);

% �ָ����ݼ�Ϊѵ���Ͳ��Լ�
X_train = data1(1:1092, 1:5);
y_train = data1(1:1092, 60);
X_test = data2(1:14, 1:5);
y_test = data2(1:14, 60);

% �Ŵ��㷨����
populationSize = 50;
maxGenerations = 100;
mutationRate = 0.1;
crossoverRate = 0.8;

% ��ʼ����Ⱥ
population = rand(populationSize, size(X_train, 2));  % ÿ������Ϊ5������Ȩ��

% ��Ӧ�Ⱥ���
fitnessFunction = @(weights) calculateFitness(weights, X_train, y_train);

% �Ŵ��㷨��ѭ��
for generation = 1:maxGenerations
    % ������Ӧ��
    fitnessValues = zeros(populationSize, 1);
    for i = 1:populationSize
        fitnessValues(i) = fitnessFunction(population(i, :));
    end
    
    % ѡ��
    selectedIndividuals = selection(population, fitnessValues, populationSize);
    
    % ����
    offspring = crossover(selectedIndividuals, crossoverRate);
    
    % ����
    offspring = mutate(offspring, mutationRate);
    
    % ������Ⱥ
    population = offspring;
end

% �ҵ���Ѹ���
[~, bestIndex] = min(fitnessValues);
bestWeights = population(bestIndex, :);

% ʹ�����Ȩ�ؽ���Ԥ��
y_pred = X_test * bestWeights';

% ȷ�� y_test �� y_pred ����������
y_test = y_test(:);
y_pred = y_pred(:);

% ����ƽ�����԰ٷֱ���MAPE��
MAPE = mean(abs((y_test - y_pred)./ y_test))

figure(1)
plot(1:14, y_test,'-b.'); hold on   	% ������ʵĿ������
plot(1:14, y_pred, 'b--.');               	% ������Ͻ��
legend('�������', 'Ԥ�����'); hold off
xlabel('��n��')
ylabel('����ֵ')
title('�Ŵ��㷨Ԥ�����','fontsize',12)

figure(2) 
plot((y_pred - y_test)./y_test,'-b.');
xlabel('��n��')
ylabel('������')
title('�Ŵ��㷨Ԥ��������','fontsize',12)


% ���������Ӧ�ȵĺ���
function fitness = calculateFitness(weights, X, y)
    % ����������Ӧ�ȣ�������
    y_pred = X * weights';
    fitness = mean((y - y_pred).^2);
end

% ����ѡ����
function selected = selection(population, fitnessValues, numIndividuals)
    % ���̶�ѡ��
    probabilities = 1 ./ fitnessValues;  % ��Ӧ��ֵԽС��ѡ�����Խ��
    probabilities = probabilities / sum(probabilities);  % ��һ��
    cumProbabilities = cumsum(probabilities);
    
    selected = zeros(numIndividuals, size(population, 2));
    for i = 1:numIndividuals
        r = rand;
        index = find(cumProbabilities >= r, 1, 'first');
        if isempty(index)
            index = length(cumProbabilities);  % ȷ��indexʼ����Ч
        end
        selected(i, :) = population(index, :);
    end
end

% ���彻�溯��
function offspring = crossover(parents, crossoverRate)
    % ���㽻��
    numParents = size(parents, 1);
    offspring = parents;
    for i = 1:2:numParents-1
        if rand < crossoverRate
            crossoverPoint = randi(size(parents, 2) - 1);
            temp = offspring(i, crossoverPoint+1:end);
            offspring(i, crossoverPoint+1:end) = offspring(i+1, crossoverPoint+1:end);
            offspring(i+1, crossoverPoint+1:end) = temp;
        end
    end
end

% ������캯��
function mutated = mutate(offspring, mutationRate)
    % �������
    [numOffspring, numGenes] = size(offspring);
    mutated = offspring;
    for i = 1:numOffspring
        for j = 1:numGenes
            if rand < mutationRate
                mutated(i, j) = rand;
            end
        end
    end
end