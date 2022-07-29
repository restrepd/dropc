clear all
file1 = '032822_training_odor1.mat';
file2 = '032922_training_odor2.mat';
file3 = '033022_training_odor3.mat';
file4 = '040822_training_odor4.mat';
file5 = '041122_training_odor5.mat';
file6 = '041222_training_odor6.mat';
file7 = '041322_training_odor7.mat';
file8 = '041422_training_odor8.mat';
file9 = '041522_training_odor9.mat';

data1 = load(file1);
data2 = load(file2);
data3 = load(file3);
data4 = load(file4);
data5 = load(file5);
data6 = load(file6);
data7 = load(file7);
data8 = load(file8);
data9 = load(file9);

data = [...
    data1.handles.dropcData.trialPerformance, ...
    data2.handles.dropcData.trialPerformance, ...
    data3.handles.dropcData.trialPerformance, ...
    data4.handles.dropcData.trialPerformance, ...
    data5.handles.dropcData.trialPerformance, ...
    data6.handles.dropcData.trialPerformance, ...
    data7.handles.dropcData.trialPerformance, ...
    data8.handles.dropcData.trialPerformance, ...
    data9.handles.dropcData.trialPerformance];


for p = 1:length(data)
        if data(p) == 'X'
        dataperformance(p) = 1;  
        end
        if data(p) == 'O'
        dataperformance(p) = 0;  
        end

end

cont = 1;
for p= 1: 10: length(dataperformance)-20
percentcorrect(cont) = 100*sum(dataperformance(p:p+20))/20;
cont = cont +1 ;
end

figure(1)
plot(percentcorrect,'-o')
%bar(percentcorrect)
xlabel('Block #')
ylabel('Percent of HITS')

figure(2)
plot(movmean(percentcorrect,5),'-o')
%bar(movmean(percentcorrect,5))
xlabel('Block #')
ylabel('Percent of HITS')

figure(3)
stem(dataperformance)
