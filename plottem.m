% 讀取數據
data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

% 提取溫度數據
temperature = data(:, 2);

% 將溫度中labels為1的點標注
rainy_points = temperature(labels == 1);
non_rainy_points = temperature(labels == 0);

% 計算溫度的最大值和最小值
max_temperature = max(temperature);
min_temperature = min(temperature);

% 將溫度切成十份
num_bins = 10;
temperature_bins = linspace(min_temperature, max_temperature, num_bins + 1);

% 使用 histcounts 函数计算每个區段中下雨和沒下雨的點數
hist_rainy = histcounts(rainy_points, temperature_bins);
hist_non_rainy = histcounts(non_rainy_points, temperature_bins);

% 绘制直方图
figure;
bar(temperature_bins(1:end-1), [hist_rainy; hist_non_rainy]', 'hist');
xlabel('溫度');
ylabel('點數');
title('溫度分佈狀態');

% 添加圖例
legend('下雨', '沒下雨');

% 打印統計結果
disp('溫度分佈統計結果:');
for i = 1:num_bins
    fprintf('區間 %d: 下雨 %d 點, 沒下雨 %d 點\n', i, hist_rainy(i), hist_non_rainy(i));
end
