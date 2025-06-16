
function output=nomalp(input)

[~,w]=size(input); % 获取输入矩阵的列数w

mm=mean(input); % 计算每列的平均值

ml=[1:w]; % 初始化一个从 1 到 w 的向量

% 逐列进行去均值操作
for i=1:w
    output(:,i)=input(:,i)-mm(1,i); 
end

% 计算每列的标准差
for i=1:w
    ml(i)=std(output(:,i));
end

% 逐列进行标准化操作
for i=1:w
    if ml(i)==0
        % 如果标准差为0（即该列所有值都相同），则不进行标准化处理
    else   
        output(:,i)=output(:,i)/ml(i); % 将每列除以其标准差
    end
end

end