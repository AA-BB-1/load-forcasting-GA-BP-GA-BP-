clear all
clc;

% 读取数据集
data1 = xlsread('数据集.xlsx');
data2 = xlsread('数据集.xlsx', 2);

% 分割数据集为训练和测试集
X_train = data1(1:1092, 1:5);
y_train = data1(1:1092, 60);
X_test = data2(1:14, 1:5);
y_test = data2(1:14, 60);

% 遗传算法参数
populationSize = 50;
maxGenerations = 100;
mutationRate = 0.1;
crossoverRate = 0.8;

% 初始化种群
population = rand(populationSize, size(X_train, 2));  % 每个个体为5个特征权重

% 适应度函数
fitnessFunction = @(weights) calculateFitness(weights, X_train, y_train);

% 遗传算法主循环
for generation = 1:maxGenerations
    % 计算适应度
    fitnessValues = zeros(populationSize, 1);
    for i = 1:populationSize
        fitnessValues(i) = fitnessFunction(population(i, :));
    end
    
    % 选择
    selectedIndividuals = selection(population, fitnessValues, populationSize);
    
    % 交叉
    offspring = crossover(selectedIndividuals, crossoverRate);
    
    % 变异
    offspring = mutate(offspring, mutationRate);
    
    % 更新种群
    population = offspring;
end

% 找到最佳个体
[~, bestIndex] = min(fitnessValues);
bestWeights = population(bestIndex, :);

% 使用最佳权重进行预测
y_pred = X_test * bestWeights';

% 确保 y_test 和 y_pred 都是列向量
y_test = y_test(:);
y_pred = y_pred(:);

% 计算平均绝对百分比误差（MAPE）
MAPE = mean(abs((y_test - y_pred)./ y_test))

figure(1)
plot(1:14, y_test,'-b.'); hold on   	% 绘制真实目标曲线
plot(1:14, y_pred, 'b--.');               	% 绘制拟合结果
legend('期望输出', '预测输出'); hold off
xlabel('第n天')
ylabel('负荷值')
title('遗传算法预测输出','fontsize',12)

figure(2) 
plot((y_pred - y_test)./y_test,'-b.');
xlabel('第n天')
ylabel('相对误差')
title('遗传算法预测相对误差','fontsize',12)


% 定义计算适应度的函数
function fitness = calculateFitness(weights, X, y)
    % 计算个体的适应度（均方误差）
    y_pred = X * weights';
    fitness = mean((y - y_pred).^2);
end

% 定义选择函数
function selected = selection(population, fitnessValues, numIndividuals)
    % 轮盘赌选择
    probabilities = 1 ./ fitnessValues;  % 适应度值越小，选择概率越高
    probabilities = probabilities / sum(probabilities);  % 归一化
    cumProbabilities = cumsum(probabilities);
    
    selected = zeros(numIndividuals, size(population, 2));
    for i = 1:numIndividuals
        r = rand;
        index = find(cumProbabilities >= r, 1, 'first');
        if isempty(index)
            index = length(cumProbabilities);  % 确保index始终有效
        end
        selected(i, :) = population(index, :);
    end
end

% 定义交叉函数
function offspring = crossover(parents, crossoverRate)
    % 单点交叉
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

% 定义变异函数
function mutated = mutate(offspring, mutationRate)
    % 随机变异
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