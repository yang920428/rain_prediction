clc;clear;close all;

data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

num_sample = size(data , 1);
for ch = 1:28
    sample_choose = ch;
    part_num = 28;
    sample_index = 1+(sample_choose-1)*floor(num_sample/part_num):min((sample_choose)*floor(num_sample/part_num),num_sample);
    train_data = data(sample_index ,:);
    train_labels = labels(sample_index);
    
    test_data = data(setdiff(1:num_sample , sample_index),:);
    test_labels = labels(setdiff(1:num_sample , sample_index));
    
    % adaboost
    num_classifiers = 3;
    WeakClassifiers = cell(num_classifiers, 1);
    alpha = zeros(num_classifiers, 1);
    
    a = 17.27;
    b = 237.7;
    for i = 1:num_classifiers
        % classifiers
        switch i
            case 1
                % 相對濕度 >= 90
                weak_classifier = @(data) double(data(:, 3) >= 99);
            % case 2
            %     % 氣壓 900~1000
            %     weak_classifier = @(data) double(data(:, 1) <= 1000);
            % case 3
            %     % 氣壓 900~1000
            %     weak_classifier = @(data) double(data(:, 1) >= 900);
            case 2
                weak_classifier = @(data) double(data(:, 2) < data(:,2) - (100 - data(:,3))/5 );
            case 3
                weak_classifier = @(data) double( data(:,2) < gamma(data(:,2) , data(:,3) , a , b) );
            
        end
    
        % 計算誤差
        predictions = weak_classifier(train_data);
        errors = sum(predictions ~= train_labels) / length(train_labels);
    
        % 計算權重
        alpha(i) = 0.5 * log((1 - errors) / errors);
    
        % 保存弱分類器
        WeakClassifiers{i} = weak_classifier;
    end
    
    % test
    num_test = length(test_data(:,1));
    ensemble_predictions = zeros(num_test, 1);
    
    for i = 1:num_classifiers
        weak_classifier = WeakClassifiers{i};
        predictions = weak_classifier(test_data);
        ensemble_predictions = ensemble_predictions + alpha(i) * predictions;
    end
    
    final_predictions = sign(ensemble_predictions);
    
    %輸出誤差
    accuracy = sum(final_predictions == test_labels)/num_test;
    fprintf('%d-th block Accuracy: %.2f%\n',ch, accuracy);
end

function val = gamma(T , RH , a , b)
    val = a*T/(b+T)+log(RH/100);
end