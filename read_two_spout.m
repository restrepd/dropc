%read_two_spout 
clear all
close all

sliding_window=20; %Trials for determination of behavioral performance
min_precent_high_beh=80; %Minimum percent correct for good behavior blocks
max_percent_low_beh=65;
shift_baseline=0;
day_boundries=0; %day boundries are drawn if this is 1

% file{1} = '051622_training_odor19.mat';
% file{2} = '051722_training_odor20.mat';
% file{3} = '051822_training_odor21.mat';
% file{4} = '051922_training_odor22.mat';
% file{5} = '052022_training_odor23.mat';

%These are the data acquired with the code biased for low percent, the
%baseline has to be shifted
shift_baseline=1;
file{1}= '032822_training_odor1.mat';
file{2} = '032922_training_odor2.mat';
file{3} = '033022_training_odor3.mat';
file{4} = '040822_training_odor4.mat';
file{5} = '041122_training_odor5.mat';
file{6} = '041222_training_odor6.mat';
file{7} = '041322_training_odor7.mat';
file{8} = '041422_training_odor8.mat';
file{9} = '041522_training_odor9.mat';

trialPerformance=[];
trialResult=[];
trials_per_file=[];
trialLeftRight=[];
for ii_file=1:length(file)
    these_data = load(file{ii_file});
    trialPerformance=[trialPerformance these_data.handles.dropcData.trialPerformance];
    trials_per_file(ii_file)=length(these_data.handles.dropcData.trialPerformance);
    trialResult=[trialResult these_data.handles.dropcData.allTrialResult];
    trialLeftRight=[trialLeftRight these_data.handles.dropcData.allTrial_left_right];
    t_per_file(ii_file)=length(these_data.handles.dropcData.allTrialResult);
end

% data2 = load(file2);
% data3 = load(file3);
% data4 = load(file4);
% data5 = load(file5);
% data6 = load(file6);
% data7 = load(file7);
% data8 = load(file8);
% data9 = load(file9);
% 
% data = [...
%     data1.handles.dropcData.trialPerformance, ...
%     data2.handles.dropcData.trialPerformance, ...
%     data3.handles.dropcData.trialPerformance, ...
%     data4.handles.dropcData.trialPerformance, ...
%     data5.handles.dropcData.trialPerformance, ...
%     data6.handles.dropcData.trialPerformance, ...
%     data7.handles.dropcData.trialPerformance, ...
%     data8.handles.dropcData.trialPerformance, ...
%     data9.handles.dropcData.trialPerformance];


for p = 1:length(trialPerformance)
        if trialPerformance(p) == 'X'
        dataperformance(p) = 1;  
        end
        if trialPerformance(p) == 'O'
        dataperformance(p) = 0;  
        end

end

n_trials=length(trialResult);

 for ii=1:n_trials-sliding_window+1
%         first_time=handlesin.dropcData.trialTime(ii);
%         last_time=handlesin.dropcData.trialTime(ii+sliding_window-1);
       
        rspm_out.pCorr(ii+(sliding_window/2))=100*sum(trialResult(ii:ii+sliding_window-1))/sliding_window;
        rspm_out.left_right(ii+(sliding_window/2))=100*sum(trialLeftRight(ii:ii+sliding_window-1))/sliding_window;
        if ii==1
            
            rspm_out.pCorr(ii:(sliding_window/2))=rspm_out.pCorr(ii+(sliding_window/2));
            rspm_out.left_right(ii:(sliding_window/2))=rspm_out.left_right(ii+(sliding_window/2));
        end
        if ii==n_trials-sliding_window+1
          
            rspm_out.pCorr(ii+(sliding_window/2)+1:n_trials)=rspm_out.pCorr(ii+(sliding_window/2));
            rspm_out.left_right(ii+(sliding_window/2)+1:n_trials)=rspm_out.left_right(ii+(sliding_window/2));
        end
 end
 
 no_trials=length(dataperformance);

 for ii=1:no_trials-sliding_window+1
%         first_time=handlesin.dropcData.trialTime(ii);
%         last_time=handlesin.dropcData.trialTime(ii+sliding_window-1);
        rspm_out.perCorr(ii+(sliding_window/2))=100*sum(dataperformance(ii:ii+sliding_window-1))/sliding_window;
     
        if ii==1
            rspm_out.perCorr(ii:(sliding_window/2))=rspm_out.perCorr(ii+(sliding_window/2));
           
        end
        if ii==no_trials-sliding_window+1
            rspm_out.perCorr(ii+(sliding_window/2)+1:no_trials)=rspm_out.perCorr(ii+(sliding_window/2));
            
        end
 end
 
 if shift_baseline==1
     rspm_out.perCorr=rspm_out.perCorr+(50-mean(rspm_out.perCorr(1:500)));
 end
% cont = 1;
% for p= 1: 10: length(dataperformance)-sliding_window
%     percentcorrect(cont) = 100*sum(dataperformance(p:p+sliding_window))/sliding_window;
%     cont = cont +1 ;
% end

% figure(1)
% plot(percentcorrect,'-o')
% %bar(percentcorrect)
% xlabel('Block #')
% ylabel('Percent of HITS')
% 
% figure(2)
% plot(movmean(percentcorrect,5),'-o')
% %bar(movmean(percentcorrect,5))
% xlabel('Block #')
% ylabel('Percent of HITS')
% 
% figure(3)
% stem(dataperformance)
figNo=0;


figNo=figNo+1;

try
    close figNo
catch
end

hFig1 = figure(figNo);
set(hFig1, 'units','normalized','position',[.25 .25 .5 .25])

% rspm_out.perCorr=percentcorrect;

jj_low=find(rspm_out.perCorr<max_percent_low_beh);
plot(jj_low,rspm_out.perCorr(jj_low),'ob')
hold on
jj_high=find(rspm_out.perCorr>min_precent_high_beh);
plot(jj_high,rspm_out.perCorr(jj_high),'or')

jj_mid=find((rspm_out.perCorr<=min_precent_high_beh)&(rspm_out.perCorr>=max_percent_low_beh));
plot(jj_mid,rspm_out.perCorr(jj_mid),'o','MarkerEdgeColor',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7])
hold on
plot([1 length(rspm_out.perCorr)],[50 50],'-k')

if day_boundries==1
    for filN=1:length(file)
        plot([sum(trials_per_file(1:filN)) sum(trials_per_file(1:filN)) ],[0 100],'-k')
    end
end

% if ischar(FileName)==1
%     title(['Percent correct vs. trial number ' FileName])
% else
%     title(['Percent correct vs. trial number ' FileName{1}])
% end

title(['Percent correct vs. trial number '])
xlabel('Trial number')
ylabel('Percent correct')
ylim([0 100])


figNo=figNo+1;

try
    close figNo
catch
end

hFig1 = figure(figNo);
set(hFig1, 'units','normalized','position',[.25 .25 .5 .25])

% rspm_out.pCorr=percentcorrect;

jj_low=find(rspm_out.pCorr<max_percent_low_beh);
plot(jj_low,rspm_out.pCorr(jj_low),'ob')
hold on
jj_high=find(rspm_out.pCorr>min_precent_high_beh);
plot(jj_high,rspm_out.pCorr(jj_high),'or')

jj_mid=find((rspm_out.pCorr<=min_precent_high_beh)&(rspm_out.pCorr>=max_percent_low_beh));
plot(jj_mid,rspm_out.pCorr(jj_mid),'o','MarkerEdgeColor',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7])
hold on
plot([1 length(rspm_out.pCorr)],[50 50],'-k')

for filN=1:length(file)
    plot([sum(t_per_file(1:filN)) sum(t_per_file(1:filN)) ],[0 100],'-k')
end

% if ischar(FileName)==1
%     title(['Percent correct vs. trial number ' FileName])
% else
%     title(['Percent correct vs. trial number ' FileName{1}])
% end

title(['Percent correct vs. trial number '])
xlabel('Trial number')
ylabel('Percent correct')
ylim([0 100])

figNo=figNo+1;

try
    close figNo
catch
end

hFig1 = figure(figNo);
set(hFig1, 'units','normalized','position',[.25 .25 .5 .25])

% rspm_out.left_right=percentcorrect;

jj_low=find(rspm_out.left_right<max_percent_low_beh);
plot(jj_low,rspm_out.left_right(jj_low),'ob')
hold on
jj_high=find(rspm_out.left_right>min_precent_high_beh);
plot(jj_high,rspm_out.left_right(jj_high),'or')

jj_mid=find((rspm_out.left_right<=min_precent_high_beh)&(rspm_out.left_right>=max_percent_low_beh));
plot(jj_mid,rspm_out.left_right(jj_mid),'o','MarkerEdgeColor',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7])
hold on
plot([1 length(rspm_out.left_right)],[50 50],'-k')

for filN=1:length(file)
    plot([sum(t_per_file(1:filN)) sum(t_per_file(1:filN)) ],[0 100],'-k')
end

% if ischar(FileName)==1
%     title(['Percent correct vs. trial number ' FileName])
% else
%     title(['Percent correct vs. trial number ' FileName{1}])
% end

title(['Left/Right vs. trial number '])
xlabel('Trial number')
ylabel('Left/Right')
ylim([0 100])

pfffft=1;
