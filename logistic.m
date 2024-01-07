% 假设你有6000个样本，每个样本有6个特征
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

% 使用 fitglm 进行逻辑回归模型训练
logistic_model = fitglm(X_train, y_train, 'Distribution', 'binomial', 'Link', 'logit');

% 显示逻辑回归模型的摘要
disp(logistic_model);

% 进行预测（这里仅为演示，实际上你会用测试数据进行预测）
X_test = all_data(num_samples+1 : end ,:);
y_pred = predict(logistic_model, X_test);

% 显示预测结果
disp(y_pred);
