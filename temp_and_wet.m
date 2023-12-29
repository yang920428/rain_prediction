% 读取数据
data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

% 提取温度和相对湿度以及降雨标签的数据
temperature = data(:, 2);  % 第二列是温度
humidity = data(:, 3);  % 第三列是相对湿度
rain_labels = labels(:);  % 降雨标签

% 绘制散点图
figure;

% 绘制下雨的点，红色，半径为10
scatter(temperature(rain_labels == 1), humidity(rain_labels == 1), 10, 'r', 'filled');
hold on;

% 绘制没有下雨的点，蓝色，半径为5
scatter(temperature(rain_labels == 0), humidity(rain_labels == 0), 5, 'b', 'filled');

% 设置图的标题和轴标签
title('Scatter Plot of Temperature and Humidity');
xlabel('Temperature');
ylabel('Relative Humidity');

% 显示图例
legend('Rain', 'No Rain');

% 保持坐标轴比例一致
axis equal;

% 显示网格
grid on;

% 显示图形
hold off;

%相對濕度>=90為分界