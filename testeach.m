% test
all_acc = zeros(28,1);
A = 17.27;
B = 237.7;

weak_classifier1 = @(data) 2*double(data(:, 3) >= 99)-1;
% weak_classifier2 = @(data) 2*double(data(:, 2) < data(:,2) - (100 - data(:,3))/5 )-1;
weak_classifier2 = @(data) 2*double( data(:,2) < Td(data(:,2) , data(:,3) , A , B) )-1;
weak_classifier3 = @(data) 2*double( data(:,1) >= 1000 )-1;
% weak_classifier4 = @(data) 2*double( data(:,3) >= 90 )-1;
weak_classifier4 = @(data) 2*double( data(:,6) <= 0.4 )-1;

num_classifiers = 4;
Weak = cell(num_classifiers,1);
Weak{1} = weak_classifier1;
Weak{2} = weak_classifier2;
Weak{3} = weak_classifier3;
Weak{4} = weak_classifier4;
% Weak{5} = weak_classifier5;

for t=1:28
    numname = "D:\\Program_set\\project_zike\\numOnly\\numOnly_"+string(t-1)+".txt";
    labelname = "D:\\Program_set\\project_zike\\label\\label_"+string(t-1)+".txt";
    test_data = importdata(numname,' ',0);
    test_labels = importdata(labelname,' ',0);
    
    num_test = length(test_data(:,1));
    ensemble_predictions = zeros(num_test, 1);
    alpha = [0.3562
0.4726
0.1986
0.1595];
    for i = 1:num_classifiers
        ensemble_predictions = ensemble_predictions + alpha(i) * Weak{i}(test_data);
    end
    
    final_predictions = sign(ensemble_predictions);
    
    %輸出誤差
    accuracy = sum(final_predictions == test_labels)/num_test;
    % fprintf('Accuracy: %f%\n', accuracy);
    % all_acc(t) = accuracy;
    fprintf("site %d acc = %f\n" , t, accuracy);
end



function tem = Td(T ,RH , a , b)
    tem = b*gamma(T,RH ,a ,b)./(a- gamma(T,RH ,a ,b));
end

function val = gamma(T , RH , a , b)
    val = a.*T./(b+T)+log(RH./100);
end