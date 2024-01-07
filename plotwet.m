% 讀取數據
data = importdata('totalnumdata.txt', ' ', 0);
labels = importdata('totallabel.txt', ' ', 0);

% scatter(1:length(labels) , data(:,3) , '.' , 1:length(labels) , data(:,3) , '.');

for i = 1:length(labels)
    if (labels(i) == 1)
        plot(i , data(i,3) , '.' ,"Color","r");
    else
        plot(i , data(i,3) , '.' ,"Color","b");
    end
    hold on;
end

