clear; clc; close;
% 假設你的輸入資料為 X，輸出資料為 Y
X_infor = importdata("totalnumdata.txt");
X_label = importdata("totallabel.txt");
X_train = zeros(2431, 6); X_test = zeros(9721, 6);
Y_train = zeros(2431, 1); Y_test = zeros(9721, 1);
for i = 1:12152
    if(mod(i, 5) == 1)
        X_train(ceil(i / 5), :) = X_infor(i, :);
        Y_train(ceil(i / 5)) = X_label(i);
    else
        X_test(ceil(i / 5), :) = X_infor(i, :);
        Y_test(ceil(i / 5)) = X_label(i);
    end
end

% 將資料轉換成適當的格式
X_train = X_train';
X_test = X_test';
Y_train = Y_train';
Y_test = Y_test';

% 設定輸入特徵數量和LSTM單元數量
numFeatures = size(X_train, 1); % 輸入特徵數量
numHiddenUnits = 100; % LSTM單元數量

% 建立LSTM神經網路
layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(1)
    regressionLayer];

% 設定訓練選項
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 64, ...
    'Shuffle', 'every-epoch', ...
    'InitialLearnRate', 0.01, ...
    'Plots', 'training-progress');

% 訓練神經網路
net = trainNetwork(X_train, Y_train, layers, options);
