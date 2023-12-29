clc;clear;close all;

% 读取数据
data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

% 将数据划分为训练集和测试集
num_samples = size(data, 1);
num_folds = 5;

% 选择一个部分作为训练集
fold_to_train = 3;  % 选择第一个部分，你可以根据需要修改

% 计算训练集的索引
train_indices = mod(1:num_samples, num_folds) == fold_to_train;

% 训练集
train_data = data(train_indices, :);
train_labels = labels(train_indices);

% 测试集
test_data = data(~train_indices, :);
test_labels = labels(~train_indices);

% 移除温度列
train_data(:, 2) = [];
test_data(:, 2) = [];

% 使用Adaboost进行训练
num_classifiers = 2;  % 移除了温度特征
WeakClassifiers = cell(num_classifiers, 1);
alpha = zeros(num_classifiers, 1);

for i = 1:num_classifiers
    % 根据不同特征进行判别
    switch i
        % case 1
        %     % 气压 >= 900
        %     weak_classifier = @(data) double(data(:, 1) >= 900);
        case 1
            % 相对湿度 >= 99
            weak_classifier = @(data) double(data(:, 2) >= 90);
        case 2
            % 日照时数 <= 0.4
            weak_classifier = @(data) double(data(:, 5) <= 0.4);
        % case 3
        %     % 日照时数 <= 0.4
        %     weak_classifier = @(data) double(data(:, 5) <= 0.4);
    end

    % 计算误差率
    predictions = weak_classifier(train_data);
    errors = sum(predictions ~= train_labels) / length(train_labels);

    % 计算弱分类器的权重
    alpha(i) = 0.5 * log((1 - errors) / errors);

    % 保存弱分类器
    WeakClassifiers{i} = weak_classifier;
end

% 使用Adaboost进行测试
num_test = size(test_data, 1);
ensemble_predictions = zeros(num_test, 1);

for i = 1:num_classifiers
    weak_classifier = WeakClassifiers{i};
    predictions = weak_classifier(test_data);

    % 更新总体预测
    ensemble_predictions = ensemble_predictions + alpha(i) * predictions;
end

% 最终预测结果
final_predictions = sign(ensemble_predictions);

% 计算准确度
accuracy = sum(final_predictions == test_labels) / num_test;
fprintf('Accuracy: %.2f%%\n', accuracy * 100);

% % 读取数据
% data = importdata('totalnumdata.txt', ' ', 0);
% labels = importdata('totallabel.txt', ' ', 0);
% 
% % 将数据划分为训练集和测试集
% % 数据分成五个部分
% num_samples = size(data, 1);
% num_folds = 5;
% 
% % 选择一个部分作为训练集
% fold_to_train = 1;  % 选择第一个部分，你可以根据需要修改
% 
% % 计算训练集的索引
% train_indices = mod(1:num_samples, num_folds) == fold_to_train;
% 
% % 训练集
% train_data = data(train_indices, :);
% train_labels = labels(train_indices);
% 
% % 测试集
% test_data = data(~train_indices, :);
% test_labels = labels(~train_indices);
% 
% % 使用Adaboost进行训练
% num_classifiers = 1;  % 只使用相对湿度
% WeakClassifiers = cell(num_classifiers, 1);
% alpha = zeros(num_classifiers, 1);
% 
% % 根据相对湿度 >= 99 进行判别
% weak_classifier = @(data) double(data >= 99);
% 
% % 计算误差率
% predictions = weak_classifier(train_data);
% errors = sum(predictions ~= train_labels) / num_train;
% 
% % 计算弱分类器的权重
% alpha = 0.5 * log((1 - errors) / errors);
% 
% % 使用Adaboost进行测试
% num_test = size(test_data, 1);
% ensemble_predictions = alpha * weak_classifier(test_data);
% 
% % 最终预测结果
% final_predictions = sign(ensemble_predictions);
% 
% % 计算准确度
% accuracy = sum(final_predictions == test_labels) / num_test;
% fprintf('Accuracy: %.2f%%\n', accuracy * 100);
% 
