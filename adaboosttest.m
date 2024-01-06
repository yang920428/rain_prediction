clc;close all;

data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

num_sample = size(data , 1);

sample_choose = 3;
part_num = 28;
%sample_index = 1+(sample_choose-1)*floor(num_sample/part_num):min((sample_choose)*floor(num_sample/part_num),num_sample);
%sample_index = union((434*2+1):(434*3) ,union((434*5+1):(434*6) , union((434*9+1):(434*10) , union((434*15+1):(434*16) ,union((434*16+1):(434*17), (434*17+1):(434*18)) ))) );
sample_set = {(434*2+1):(434*3) , (434*4+1):(434*5) , (434*5+1):(434*6) , (434*8+1):(434*9) , (434*9+1):(434*10) , (434*24+1):(434*25)};
sample_index = [];
sample_num = length(sample_set);
for i=1:length(sample_set)
    sample_index = union(sample_index , sample_set{i});
end
% sample_index = union( sample_set{:} );
disp(length(sample_index));
train_data = data(sample_index ,:);
train_labels = labels(sample_index);

% test_data = data(setdiff(1:num_sample , sample_index ),:);
% test_labels = labels(setdiff(1:num_sample , sample_index));
test_data = data(setdiff(1:num_sample , sample_index ),:);
test_labels = labels(setdiff(1:num_sample , sample_index ));

% adaboost
num_classifiers = 5;
WeakClassifiers = cell(num_classifiers, 1);
alpha = zeros(num_classifiers, 1);

N = length(train_data(:,1)) ; 
D = zeros ( N , 1);
T = find(train_labels == 1);
D (T) = 1/(2*(size(T , 1)));
D(setdiff(1:N , T) )= 1/(2*(length( setdiff(1:1:N , T))));

A = 17.27;
B = 237.7;
for i = 1:num_classifiers
    % classifiers
    D = D / sum(D);

    weak_classifier1 = @(data) 2*double(data(:, 3) >= 99)-1;
    % weak_classifier2 = @(data) 2*double(data(:, 2) < data(:,2) - (100 - data(:,3))/5 )-1;
    weak_classifier2 = @(data) 2*double( data(:,2) < gamma(data(:,2) , data(:,3) , A , B) )-1;
    weak_classifier3 = @(data) 2*double( data(:,1) >= 1000 )-1;
    weak_classifier4 = @(data) 2*double( data(:,3) >= 90 )-1;
    weak_classifier5 = @(data) 2*double( data(:,6) <= 0.4 )-1;

    Weak = cell(num_classifiers,1);
    Weak{1} = weak_classifier1;
    Weak{2} = weak_classifier2;
    Weak{3} = weak_classifier3;
    Weak{4} = weak_classifier4;
    Weak{5} = weak_classifier5;
    

    r = zeros(1, num_classifiers);
    r(1) = sum(D.*(train_labels.*weak_classifier1(train_data)));
    r(2) = sum(D.*(train_labels.*weak_classifier2(train_data)));
    r(3) = sum(D.*(train_labels.*weak_classifier3(train_data)));
    r(4) = sum(D.*(train_labels.*weak_classifier4(train_data)));
    r(5) = sum(D.*(train_labels.*weak_classifier5(train_data)));
    

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

% alpha = [0.5 ; 1.3 ; 0 ; 0 ; 0];

for i = 1:num_classifiers
    ensemble_predictions = ensemble_predictions + alpha(i) * Weak{i}(test_data);
end

final_predictions = sign(ensemble_predictions);

%輸出誤差
table = zeros(2);
table(1,1) = sum(test_labels == 1 & final_predictions == 1)/sum(test_labels == 1);
table(1,2) = sum(test_labels == -1 & final_predictions == 1)/sum(test_labels == -1);
table(2,1) = sum(test_labels == 1 & final_predictions == -1)/sum(test_labels == 1);
table(2,2) = sum(test_labels == -1 & final_predictions == -1)/sum(test_labels == -1);
accuracy = sum(final_predictions == test_labels)/num_test;
fprintf('Accuracy: %f%\n', accuracy);
fprintf("\n");
disp(table);
disp(alpha);

function val = gamma(T , RH , a , b)
    val = a.*T./(b+T)+log10(RH./100);
end