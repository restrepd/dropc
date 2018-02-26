%% Close all
clear all
close all

%% User should change these variables

%First file name for output
%IMPORTANT: This should be a .mat file
handles.dropcProg.output_file='/Users/restrepd/Documents/projects/testdropc/05262015_test2_U5397_test.mat';


load(handles.dropcProg.output_file);

%Now plot the data
figure(1)

%Percent correct per block
subplot(2,2,1)

if handles.dropcData.trialIndex>20
    for trialNo=1:handles.dropcData.trialIndex
        if handles.dropcData.odorType(trialNo)==handles.dropcProg.splusOdor
            if handles.dropcData.trialScore(trialNo)==1
                correctTrial(trialNo)=1;
            else
                correctTrial(trialNo)=0;
            end
        else
            if handles.dropcData.trialScore(trialNo)==1
                correctTrial(trialNo)=0;
            else
                correctTrial(trialNo)=1;
            end
        end
    end
    
    max_block=floor(handles.dropcData.trialIndex/20);
    for block=1:max_block
        percent_correct(block)= 100*sum(correctTrial((block-1)*20+1:block*20))/20;
    end
    blockNo=1:max_block;
    plot(blockNo,percent_correct,'x-r')
    xlim([0 11])
    ylim([40 110])
    ylabel('Percent correct')
    xlabel('Block No')
    title('Percent correct')
    
end


%ITI
subplot(2,2,2)
if handles.dropcData.trialIndex>2
    ITI=handles.dropcData.trialTime(2:end)-handles.dropcData.trialTime(1:end-1);
    trialNoITI=(1:length(ITI));
    plot(trialNoITI,ITI,'ob')
    xlim([0 210])
    ylabel('ITI (sec)')
    xlabel('Trial No')
    title('Inter trial intervals')
    
end

%Responses
subplot(2,1,2)
trialNo=1:200;
spodor=(handles.dropcData.odorValve==handles.dropcProg.splusOdorValve);
spscores=handles.dropcData.trialScore(spodor);
sptrials=trialNo(spodor);
plot(sptrials,spscores,'-or')
hold on
smodor=(handles.dropcData.odorValve==handles.dropcProg.sminusOdorValve);
smscores=handles.dropcData.trialScore(smodor);
smtrials=trialNo(smodor);
plot(smtrials,smscores,'-xb')
ylim([-0.2 1.2])
xlim([0 210])
ylabel('Lick 1=yes, 0=no')
xlabel('Trial No')
title('Licks per trial number S+: red o S-:blue x')

pffft=1




