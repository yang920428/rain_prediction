clear; clc; close all;

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
train_data = data;
train_labels = labels;
% training
numTrees = 50;
Mdl = TreeBagger(numTrees, train_data, train_labels, 'Method', 'classification');

% test_data = data(setdiff(1:num_sample , sample_index ),:);
% test_labels = labels(setdiff(1:num_sample , sample_index));
% test_data = data(setdiff(1:num_sample , sample_index ),:);
% test_labels = labels(setdiff(1:num_sample , sample_index ));

chinese = importdata("D:\\Program_set\\project_zike\\stationname\\site.txt");
t = 0;
datapath = "D:\\Program_set\\project_zike\\numOnly\\totalnumdata.txt";
labelpath = "D:\\Program_set\\project_zike\\numOnly\\totallabel.txt";
all_data = importdata(datapath , ' ' , 0);
all_labels = importdata(labelpath,' ', 0);



% accuracy_set = zeros(28,1);
% for ind = 1:28
%     test_data = all_data((434 * (ind-1) + 1):(434 * ind), :);
%     test_labels = all_labels((434 * (ind-1) + 1):(434 * ind), :);
% 
%     % training
%     numTrees = 50;
%     Mdl = TreeBagger(numTrees, train_data, train_labels, 'Method', 'classification');
% 
%     % prediction and test
%     predictions = Mdl.predict(test_data);
%     final_predictions = zeros(length(predictions), 1);
%     for i = 1:length(predictions)
%         final_predictions(i) = str2num(predictions{i});
%     end
%     table = zeros(2);
%     % table(1,1) = sum(test_labels == 1 & final_predictions == 1)/sum(test_labels == 1);
%     % table(1,2) = sum(test_labels == -1 & final_predictions == 1)/sum(test_labels == -1);
%     % table(2,1) = sum(test_labels == 1 & final_predictions == -1)/sum(test_labels == 1);
%     % table(2,2) = sum(test_labels == -1 & final_predictions == -1)/sum(test_labels == -1);
%     table(1,1) = sum(test_labels == 1 & final_predictions == 1);
%     table(1,2) = sum(test_labels == -1 & final_predictions == 1);
%     table(2,1) = sum(test_labels == 1 & final_predictions == -1);
%     table(2,2) = sum(test_labels == -1 & final_predictions == -1);
%     accuracy = sum(final_predictions == test_labels)/length(test_labels);
%     % disp(table);
%     % fprintf('Accuracy: %f%\n', accuracy);
%     accuracy_set(ind) = accuracy;
% end
% plot(1:28 , accuracy_set);



%predict all site
table_data = {'新北'; '淡水'; '鞍部'; '臺北'; '竹子湖'; '基隆'; '彭佳嶼'; '花蓮'; '新屋'; '宜蘭'; '金門'; '田中'; '東吉島'; '澎湖'; '臺南'; '高雄'; '嘉義'; '臺中'; '阿里山'; '大武'; '玉山'; '新竹'; '恆春'; '成功'; '蘭嶼'; '日月潭'; '臺東'; '馬祖'};
%sitenamepath = "D:\\Program_set\\project_zike\\stationname\\site.txt";
%table_data = readtable(sitenamepath, 'Delimiter', '\n', 'ReadVariableNames', true, 'TextType', 'string', 'Encoding', 'UTF-8');

while 1
    back = input("input time: ");
    if (back<0 || back>=434)
        break;
    end
    sum = 0;
    for t=1:28
        numname = "D:\\Program_set\\project_zike\\numOnly\\numOnly_"+string(t-1)+".txt";
        labelname = "D:\\Program_set\\project_zike\\label\\label_"+string(t-1)+".txt";
        all_test_data = importdata(numname,' ',0);
        all_test_labels = importdata(labelname,' ',0);
        test_data = all_test_data(1:length(all_test_labels)-1-back , :);
        test_labels = all_test_labels(1:length(all_test_labels)-1-back);

        num_test = length(test_data(:,1));
        ensemble_predictions = zeros(num_test, 1);
        % alpha = [0.7379,
        % 0.3494,
        % 0.1975,
        % 0.1053,
        % 0.1700];


        
        % prediction and test
        predictions = Mdl.predict(test_data);
        final_predictions = zeros(length(predictions), 1);
        for i = 1:length(predictions)
            final_predictions(i) = str2num(predictions{i});
        end
        


        T = [0.99 0.01; 0.01 0.99];
        Z = [0.1714 , 0.0470; 0.8286 , 0.9530];

        z = final_predictions;
        filter = [0.5 0.5]';
        for i=1:length(z)
            if z(i) == 1
                Zi = [Z(1,1) 0 ; 0 Z(2,1)];
                filter = Zi*T'*filter;
                filter = (1/(filter(1)+filter(2)))*filter;
            else
                Zi = [Z(1,2) 0 ; 0 Z(2,2)];
                filter = Zi*T'*filter;
                filter = (1/(filter(1)+filter(2)))*filter;
            end
        end

        predict = T*filter;
        if predict(1)>predict(2)
            pre = 1;
            fprintf("site %s T , acc = %d \n" ,table_data{t} , pre == all_test_labels(length(all_test_labels)-back));
        else
            pre = -1;
            fprintf("site %s F , acc = %d \n" , table_data{t} , pre == all_test_labels(length(all_test_labels)-back));
        end
        % disp(pre == test_labels(length(test_labels)));
        if pre == all_test_labels(length(all_test_labels)-back)
            sum = sum+1;
        end
    end
    fprintf("ac rate: %f\n" , sum/28);
end