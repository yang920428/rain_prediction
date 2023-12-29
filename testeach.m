weak_classifier1 = @(data) 2*double(data(:, 3) >= 99)-1;
weak_classifier2 = @(data) 2*double(data(:, 2) < data(:,2) - (100 - data(:,3))/5 )-1;
weak_classifier3 = @(data) 2*double( data(:,2) < gamma(data(:,2) , data(:,3) , A , B) )-1;

Weak = cell(num_classifiers,1);
Weak{1} = weak_classifier1;
Weak{2} = weak_classifier2;
Weak{3} = weak_classifier3;

num_classifiers = 3;
% test
all_acc = zeros(28,1);
for t=1:28
    numname = "D:\\Program_set\\project_zike\\numOnly\\numOnly_"+string(t-1)+".txt";
    labelname = "D:\\Program_set\\project_zike\\label\\label_"+string(t-1)+".txt";
    test_data = importdata(numname,' ',0);
    test_labels = importdata(labelname,' ',0);
    
    num_test = length(test_data(:,1));
    ensemble_predictions = zeros(num_test, 1);
    alpha = [0.3411,
    -0.2211,
    0.1525];
    for i = 1:num_classifiers
        ensemble_predictions = ensemble_predictions + alpha(i) * Weak{i}(test_data);
    end
    
    final_predictions = sign(ensemble_predictions);
    
    %輸出誤差
    accuracy = sum(final_predictions == test_labels)/num_test;
    % fprintf('Accuracy: %f%\n', accuracy);
    all_acc(t) = accuracy;
end
function val = gamma(T , RH , a , b)
    val = a.*T./(b+T)+log(RH./100);
end