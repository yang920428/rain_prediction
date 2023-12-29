clc;clear;close all;

data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

num_sample = size(data , 1);

sample_choose = 1;
part_num = 4;
sample_index = 1+(sample_choose-1)*floor(num_sample/part_num):min((sample_choose)*floor(num_sample/part_num),num_sample);
train_data = data(sample_index ,:);
train_labels = labels(sample_index);

test_data = data(setdiff(1:num_sample , sample_index),:);
test_labels = labels(setdiff(1:num_sample , sample_index));

% adaboost
num_classifiers = 3;
WeakClassifiers = cell(num_classifiers, 1);
alpha = zeros(num_classifiers, 1);

N = length(train_data(:,1)) ; 
D = zeros ( N , 1);
T = find(train_labels == 1);
D (T) = 1/(2*(size(T , 1)));
D(setdiff(1:N , T) )= 1/(2*(length( setdiff(1:1:N , T))));

A = 17.27;
B = 237.7;
alpha = zeros(num_classifiers ,1);
for i = 1:num_classifiers
    % classifiers
    D = D / sum(D);

    weak_classifier1 = @(data) 2*double(data(:, 3) >= 99)-1;
    weak_classifier2 = @(data) 2*double(data(:, 2) < data(:,2) - (100 - data(:,3))/5 )-1;
    weak_classifier3 = @(data) 2*double( data(:,2) < gamma(data(:,2) , data(:,3) , A , B) )-1;

    Weak = cell(num_classifiers,1);
    Weak{1} = weak_classifier1;
    Weak{2} = weak_classifier2;
    Weak{3} = weak_classifier3;
    r = zeros(1, num_classifiers);
    r(1) = sum(D.*(train_labels.*weak_classifier1(train_data)));
    r(2) = sum(D.*(train_labels.*weak_classifier2(train_data)));
    r(3) = sum(D.*(train_labels.*weak_classifier3(train_data)));

    index = find(abs(r) == max(abs(r)));
    index = index(1);


    % 計算權重
    al = log((1+r(index))/(1-r(index)))/2;
    D = D .* exp(-al.* train_labels .* Weak{index}(train_data));
    alpha(i) = al;
end

% test
num_test = length(test_data(:,1));
ensemble_predictions = zeros(num_test, 1);

for i = 1:num_classifiers
    ensemble_predictions = ensemble_predictions + alpha(i) * Weak{i}(test_data);
end

final_predictions = sign(ensemble_predictions);

%輸出誤差
accuracy = sum(final_predictions == test_labels)/num_test;
fprintf('Accuracy: %f%\n', accuracy);

function val = gamma(T , RH , a , b)
    val = a.*T./(b+T)+log(RH./100);
end