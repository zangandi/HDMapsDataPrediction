clear all
e111 = load('D:\Dropbox\results\clean\111.mat');
e110 = load('D:\Dropbox\results\clean\110.mat');
e101 = load('D:\Dropbox\results\clean\101.mat');
e100 = load('D:\Dropbox\results\clean\100.mat');
e011 = load('D:\Dropbox\results\clean\011.mat');
e010 = load('D:\Dropbox\results\clean\010.mat');

N = 10

pdf111 = getPFD(e111.YTest, e111.YPred, N);
pdf110 = getPFD(e110.YTest, e110.YPred, N);
pdf101 = getPFD(e101.YTest, e101.YPred, N);
pdf100 = getPFD(e100.YTest, e100.YPred, N);
pdf011 = getPFD(e011.YTest, e011.YPred, N);
pdf010 = getPFD(e010.YTest, e010.YPred, N);

figure
hold on 

n = N;
bar([0:1/n:1-1/n]+1/n/2, cat(2,pdf111,pdf110,pdf101,pdf100,pdf011,pdf010), 'BarWidth', 1)

xlim([0,1])
xlabel('MAPE %')
ylabel('PDF %')

legend({'111','110','101','100','011','010'})
%%%%%%%%%%%
clear all
e111 = load('D:\Dropbox\results\clean\111.mat');
lstm = load('D:\Dropbox\results\clean\lstm.mat');
od = load('D:\Dropbox\results\clean\od.mat');
lr = load('D:\Dropbox\results\clean\lr.mat');

N = 10

a = getPFD(e111.YTest, e111.YPred, N);
b = getPFD(lstm.YTest, lstm.YPred, N);
c = getPFD(od.YTest, od.YPred, N);
d = getPFD(lr.YTest, lr.YPred, N);


figure
hold on 

n = N;
bar([0:1/n:1-1/n]+1/n/2, cat(2,a,b,c,d), 'BarWidth', 1)

xlim([0,1])
xlabel('MAPE %')
ylabel('PDF %')

legend({'Ours','LSTM','DeepOD','LR'})







