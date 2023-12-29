clc;clear;close all;

% 假设你有一个特征矩阵 X 和对应的标签向量 Y
data = importdata('totalnumdata.txt', ' ', 0); % 特征矩阵
% 
labels = importdata('totallabel.txt', ' ', 0); % 标签向量

num_sample = size(data , 1);

sample_choose = 6;
part_num = 28;
sample_index = 1+(sample_choose-1)*floor(num_sample/part_num):min((sample_choose)*floor(num_sample/part_num),num_sample);
train_data = data(sample_index ,:);
train_labels = labels(sample_index);

test_data = data(setdiff(1:num_sample , sample_index),:);
test_labels = labels(setdiff(1:num_sample , sample_index));


% 使用 Adaboost 算法训练分类器
numLearners = 50; % 设置弱分类器的数量
boostedModel = fitensemble(train_data, train_labels, 'AdaBoostM1', 20, 'Tree');

% 进行预测
newData = test_data; % 待预测的新数据
predictions = predict(boostedModel, newData);
fprintf("ac: %f\n" , sum(predictions == test_labels) / length(test_labels));