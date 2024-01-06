import  numpy as np

A = 17.27
B = 237.7
# alpha = [0.9555,
#     0.2853,
#     0.3265,
#     0.2730,
#     0.1946];
alpha = [0.7379,
    0.3494,
    0.1975,
    0.1053,
    0.1700]
T = np.array([[0.99,0.01] , [0.01 , 0.99]])
# Z = np.array([[ 0.3492 , 0.0236] ,[0.6508 , 0.9764]])
Z = np.array([[ 0.2280 , 0.0085] ,[0.7720 , 0.9915]])

def sign(n):
    if (n>0):
        return 1
    elif (n == 0):
        return 0;
    else:
        return -1;

def gamma(T , RH , a , b):
    return a*T/(b+T)+np.log10(RH/100)

def w1(vec):
    return 2*int(vec[2] >= 99)-1

# def w2(vec):
#     return 2*int(vec[1] < vec[1] - (100 - vec[2])/5 )-1

def w2(vec):
    return 2*int( vec[1] < gamma(vec[1] , vec[2] , A , B) )-1

def w3(vec):
    return 2*int( vec[0] >= 1000 )-1;

def w4(vec):
    return 2*int( vec[2] >= 90 )-1;

def w5(vec):
    return 2*int( vec[5] <= 0.4 )-1;

def H(vec):
    return sign(alpha[0]*w1(vec) + alpha[1]*w2(vec) + alpha[2]*w3(vec) + alpha[3]*w4(vec) + alpha[4]*w5(vec))

ac_sum = 0;
check_set = np.zeros((28,1))
next_time = 1;

while 1:
    t = int(input("input t :"));
    if (t < 0):
        break;
    n = int(input("day : "));
    path = "D:\\Program_set\\project_zike\\NumOnly\\numOnly_"+str(t)+".txt"
    labelpath = "D:\\Program_set\\project_zike\\label\\label_"+str(t)+".txt"
    station_data = np.loadtxt(path);
    labeldata = np.loadtxt(labelpath);

    l = len(station_data);

    z = np.zeros((10 , 1))
    for i in range(10):
        z[i] = H(station_data[l-1-10+i-n])

    filter = np.array([0.5 , 0.5]).reshape(2,1)
    for i in range(10):
        if (z[i] == 1):
            Zi = np.array([[Z[0 , 0] , 0 ] , [0, Z[1 ,0]]])
            Tt = T.transpose()
            filter = np.dot(Zi , np.dot(Tt , filter))
            filter = filter/(filter[0] + filter[1])
        else:
            Zi = np.array([[Z[0 , 1] , 0 ] , [0, Z[1 , 1]]])
            Tt = T.transpose();
            filter = np.dot(Zi , np.dot(Tt , filter))
            filter = filter/(filter[0] + filter[1])
        
    T = np.linalg.matrix_power(T , next_time);
    predict = np.dot(T , filter)
    if (predict[0] > predict[1]):
        pre = 1;
    else:
        pre = -1;

    print(pre == labeldata[len(labeldata) -1-n ])
