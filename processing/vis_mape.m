figure
hold on 

n = 20;
bar([0:1/n:1-1/n]+1/n/2, cat(2,pdf1,pdf2), 'BarWidth', 2)

xlim([0,1])
xlabel('MAPE %')
ylabel('PDF %')

legend({'LR','LSTM'})