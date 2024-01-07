clc;clear ; close all;
% 假设你有实际的 X_train 和 y_train 数据
datapath = "D:\\Program_set\\project_zike\\numOnly\\totalnumdata.txt";
labelpath = "D:\\Program_set\\project_zike\\numOnly\\totallabel.txt";

all_data = importdata(datapath,' ',0);
all_label = importdata(labelpath , ' ', 0);
num_samples = length(all_data(:,1))/2;
num_features = 6;

% 生成随机的训练数据和标签
X_train = all_data(1:num_samples , :);
y_train = all_label(1:num_samples);

y_train(find(y_train == -1)) = 0;

% 使用梯度提升树进行训练
num_trees = 10;  % 设置树的数量
tree_model = fitensemble(X_train, y_train, 'Bag', num_trees, 'Tree', 'Type', 'classification');

% 进行预测（这里仅为演示，实际上你会用测试数据进行预测）
% X_test 是大小为 [num_test_samples, num_features] 的矩阵
X_test = all_data(num_samples+1 :length(all_data(:,1)) ,:);
y_pred = predict(tree_model, X_test);

% 显示预测结果
disp(sum(y_pred == all_label(num_samples+1 :length(all_data(:,1))))/num_samples);
