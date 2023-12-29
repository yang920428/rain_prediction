% 讀取數據
data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

% 提取日照時數數據
sunshine_hours = data(:, 5);

% 將日照時數中labels為1的點標注
rainy_points = sunshine_hours(labels == 1);
non_rainy_points = sunshine_hours(labels == 0);

% 計算日照時數的最大值和最小值
max_sunshine_hours = max(sunshine_hours);
min_sunshine_hours = min(sunshine_hours);

% 將日照時數切成十份
num_bins = 10;
sunshine_bins = linspace(min_sunshine_hours, max_sunshine_hours, num_bins + 1);

% 使用 histcounts 函数计算每个區段中下雨和沒下雨的點數
hist_rainy = histcounts(rainy_points, sunshine_bins);
hist_non_rainy = histcounts(non_rainy_points, sunshine_bins);

% 绘制直方图
figure;
bar(sunshine_bins(1:end-1), [hist_rainy; hist_non_rainy]', 'hist');
xlabel('日照時數');
ylabel('點數');
title('日照時數分佈狀態');

% 添加圖例
legend('下雨', '沒下雨');

% 打印統計結果
disp('日照時數分佈統計結果:');
for i = 1:num_bins
    fprintf('區間 %d: 下雨 %d 點, 沒下雨 %d 點\n', i, hist_rainy(i), hist_non_rainy(i));
end
