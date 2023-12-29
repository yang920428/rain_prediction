% Adaboost
clear; clc; close;

% data import and circle fitting
A_feature = importdata("feature_ball.txt");
A_label = importdata("label_ball.txt");
[size_feature size_col_fea]=size(A_feature);
[size_label size_col_lab]=size(A_label);
A_for_training = zeros(size_feature,5);
for i = 1:size_feature
    A_for_training(i,1) = A_feature(i,1);
end
c = 1;
c_for_feature = 1;
while(true)
    A_for_training(c_for_feature,2) = A_label(c,3);
    [Xc, Yc, r, a] = circfit(A_label( c:c+A_for_training(c_for_feature,1)-1 , 1), A_label( c:c+A_for_training(c_for_feature,1)-1 , 2));
    sc = 0;
    for i = c:c+A_for_training(c_for_feature,1)-1
        sc = sc + ( r - sqrt( (Xc - A_label(i,1)) ^ 2 + (Yc - A_label(i,2)) ^ 2 ) ) ^ 2;
    end
    if(A_for_training(c_for_feature,1) == 1)
        A_for_training(c_for_feature,4) = 0.005;%5
    else
        A_for_training(c_for_feature,4) = sc;
    end
    dist_mean = 0; x_mean = sum(A_label(c:c+A_for_training(c_for_feature,1)-1, 1)) / A_for_training(c_for_feature,1); y_mean = sum(A_label(c:c+A_for_training(c_for_feature,1)-1, 2)) / A_for_training(c_for_feature,1);
    for i = c:c+A_for_training(c_for_feature,1)-1
        dist_mean = dist_mean + norm(([A_label(i,1) A_label(i,2)] - [x_mean y_mean]),2) ^ 2;
    end
    A_for_training(c_for_feature,5) = sqrt( (1 / (A_for_training(c_for_feature,1)) ) * dist_mean );
    A_for_training(c_for_feature,3) = r;
    c = c + A_for_training(c_for_feature,1);
    c_for_feature = c_for_feature + 1;
    if(c > size_label)
        break;
    end
end

for i = 1:size_feature
    if(A_for_training(i,1) == 1)
        A_for_training(i,3) = 0.005;%99
    end
end

% Define some variable.
D_t = zeros(size_feature/2,1);

negative_label_count = 0;
for i = 1:size_feature/2
    if(A_for_training(i,2) == 0)
        A_for_training(i,2) = -1;
        negative_label_count = negative_label_count + 1;
    end
end
positive_label_count = size_feature/2 - negative_label_count;
wei = [7.123892048080823, -9.687817747072515, -0.010636447842295, -0.002237199960926, -8.010317082957496];
p0 = 0.8393;
p1 = 0.1628;
mean_seg_1 = 1.1098;
mean_seg_0 = 5.6727;
std_seg_1 = 5.0275;
std_seg_0 = 10.4441;
mean_r_1 = 1.3062;
mean_r_0 = 7.8914;
std_r_1 = 11.2651;
std_r_0 = 26.7345;
mean_std_1 = 0.0029;
mean_std_0 = 0.0153;
std_std_1 = 0.0123;
std_std_0 = 0.0252;
mean_sc_1 = 0.0001;
mean_sc_0 = 0.0008;
std_sc_1 = 0.0008;
std_sc_0 = 0.0021;

% Initialize the weight distribution.
for i = 1:size_feature/2
    if(A_for_training(i,2) > 0)
        D_t(i) = 1 / (2 * positive_label_count);
    else
        D_t(i) = 1 / (2 * negative_label_count);
    end
end

% Training
f = @(z1,z2,z3,z4) 0*(z1+z2+z3+z4);
for t = 1:2
    % Normalize the weights.
    sum_D = sum(D_t);
    for i = 1:size_feature/2
        D_t(i) = D_t(i) / sum_D;
    end
    
    % Train the weak classifiers.
    h_log = @(z1,z2,z3,z4) sign( wei(1)*z1 + wei(2)*z2 + wei(3)*z3 + wei(4)*z4 + wei(5) );
    h_NB = @(z1,z2,z3,z4) sign(p1*normpdf(z1, mean_seg_1, std_seg_1)*normpdf(z2, mean_r_1, std_r_1)*normpdf(z3, mean_sc_1, std_sc_1)*normpdf(z4, mean_std_1, std_std_1) - p0*normpdf(z1, mean_seg_0, std_seg_0)*normpdf(z2, mean_r_0, std_r_0)*normpdf(z3, mean_sc_0, std_sc_0)*normpdf(z4, mean_std_0, std_std_0));
    r = zeros(2,1);
    for i = 1:size_feature/2 % For h_log
        r(1) = r(1) + D_t(i) * A_for_training(i,2) * h_log(A_for_training(i,1),A_for_training(i,3),A_for_training(i,4),A_for_training(i,5));
    end
    for i = 1:size_feature/2 % For h_NB
        r(2) = r(2) + D_t(i) * A_for_training(i,2) * h_NB(A_for_training(i,1),A_for_training(i,3),A_for_training(i,4),A_for_training(i,5));
    end
    
    % Select the maxima of r.
    judge_ind = 0;
    for ind = 1:2
        if(r(ind) == max(r))
            judge_ind = ind;
            break;
        end
    end
    if(judge_ind == 1)
        h = h_log;
    else
        h = h_NB;
    end
    r_j = r(judge_ind);


    % Update the weights.
    a_t = 1 / 2 * log((1 + r_j) / (1 - r_j))
    for i = 1:size_feature/2
        D_t(i) = D_t(i) * exp( -a_t * A_for_training(i,2) * h(A_for_training(i,1),A_for_training(i,3),A_for_training(i,4),A_for_training(i,5)) );
    end

    % Get the classifier function
    f = @(z1,z2,z3,z4) f(z1,z2,z3,z4) + a_t * h(z1,z2,z3,z4);
end

% Get the final strong classifier.
H = @(z1,z2,z3,z4) sign(f(z1,z2,z3,z4));

% Testing
TP = 0; FN = 0; FP = 0; TN = 0;
Tabel_title = {'predict_yes';'predict_no'};
for i = 1:size_feature/2
    if((H(A_for_training(i+size_feature/2,1), A_for_training(i+size_feature/2,3),A_for_training(i+size_feature/2,4),A_for_training(i+size_feature/2,5)) == 1) && (A_for_training(i+size_feature/2,2) == 1))
        TP = TP + 1;
    elseif((H(A_for_training(i+size_feature/2,1), A_for_training(i+size_feature/2,3),A_for_training(i+size_feature/2,4),A_for_training(i+size_feature/2,5)) == -1) && (A_for_training(i+size_feature/2,2) == 1))
        FN = FN + 1;
    elseif((H(A_for_training(i+size_feature/2,1), A_for_training(i+size_feature/2,3),A_for_training(i+size_feature/2,4),A_for_training(i+size_feature/2,5)) == 1) && (A_for_training(i+size_feature/2,2) == 0))
        FP = FP + 1;
    else
        TN = TN + 1;
    end
end
real_yes = [TP;FN];
real_no = [FP;TN];
T = table(Tabel_title, real_yes, real_no)

fprintf("accuracy: %f\n",(TP+TN)/(size_feature/2));
fprintf("precision: %f\n",TP/(TP+FP));
fprintf("recall: %f\n",TP/(TP+FN));

function [xc, yc, R, a] = circfit(x, y)
    n = length(x); xx = x .* x; xy = x .* y; yy = y .* y;
    A = [sum(x) sum(y) n; sum(xy) sum(yy) sum(y); sum(xx) sum(xy) sum(x)];
    B = [-sum(xx + yy); -sum(xx.*y + yy.*y); -sum(xx.*x + xy.*y)];
    a = A \ B;
    xc = -.5 * a(1);
    yc = -.5 * a(2);
    R = sqrt((a(1)^2 + a(2)^2) / 4 - a(3));
end