% 讀取數據
data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

% 提取氣壓數據
pressure = data(:, 1);

% 將氣壓中labels為1的點標注
rainy_points = pressure(labels == 1);
non_rainy_points = pressure(labels == 0);

% 計算氣壓的最大值和最小值
max_pressure = max(pressure);
min_pressure = min(pressure);

% 將氣壓切成十份
num_bins = 10;
pressure_bins = linspace(min_pressure, max_pressure, num_bins + 1);

% 使用 histcounts 函数计算每个區段中下雨和沒下雨的點數
hist_rainy = histcounts(rainy_points, pressure_bins);
hist_non_rainy = histcounts(non_rainy_points, pressure_bins);

% 绘制直方图
figure;
bar(pressure_bins(1:end-1), [hist_rainy; hist_non_rainy]', 'hist');
xlabel('氣壓');
ylabel('點數');
title('氣壓分佈狀態');

% 添加圖例
legend('下雨', '沒下雨');

% 打印統計結果
disp('氣壓分佈統計結果:');
for i = 1:num_bins
    fprintf('區間 %d: 下雨 %d 點, 沒下雨 %d 點\n', i, hist_rainy(i), hist_non_rainy(i));
end
