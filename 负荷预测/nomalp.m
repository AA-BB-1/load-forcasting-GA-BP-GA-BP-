
function output=nomalp(input)

[~,w]=size(input); % ��ȡ������������w

mm=mean(input); % ����ÿ�е�ƽ��ֵ

ml=[1:w]; % ��ʼ��һ���� 1 �� w ������

% ���н���ȥ��ֵ����
for i=1:w
    output(:,i)=input(:,i)-mm(1,i); 
end

% ����ÿ�еı�׼��
for i=1:w
    ml(i)=std(output(:,i));
end

% ���н��б�׼������
for i=1:w
    if ml(i)==0
        % �����׼��Ϊ0������������ֵ����ͬ�����򲻽��б�׼������
    else   
        output(:,i)=output(:,i)/ml(i); % ��ÿ�г������׼��
    end
end

end