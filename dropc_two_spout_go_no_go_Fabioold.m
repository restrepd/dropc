%dropc_two_spout_odor
%
% Presents the rewarded odor randomly on the left or right spout
% Rewards for odor or for location of the spout (left vs. right)
%
%% Close all
clear all
close all

%Start the random number generator
rng('shuffle')

%% Setup the figure
% figure(1)
% hold on
% subplot(2,1,1)
% title('Licks per trial. To stop execution Cntrl C')

%% User should change these variables

%To stop this program enter cntrl shift esc

%First file name for output
%IMPORTANT: This should be a .mat file
handles.dropcProg.output_file='C:\Users\Mini Fabio\Documents\Fabio_olfatometro_2021\Data\20230413_testing_leftside_diego_';
%handles.dropcProg.output_file='/Users/restrepd/Documents/Projects/testdropc/m01.mat';

%Reinforce on S+ only? (1=yes, go-no go, 0=no, reinforce both, go-go)
handles.dropcProg.go_nogo=1;

%Reward for odor or for space?
handles.dropcProg.reward_location_vs_odor=1; 

%1=reward for S+ licks regardless of location (go-no go begin), 
%2=reward for odor on the right side go-no go
%3=reward for odor on the left side go-no go
%4=reward for left side go-go
%5=reward for right side go-go
%6=Fabio's S+ goes from one side to the other 

%Which side is rewarded if reward is given based on spout location
handles.dropcProg.reward_left_vs_right=0; %0= reward for licks on left spout, 1= reward for licks on right spout

switch handles.dropcProg.reward_location_vs_odor
    case 1
        disp(['dropc_two_spout_go_no_go reward for licks regardless of location (go-no go begin)'])
    case 2
        disp(['dropc_two_spout_odor rewarded for the odor'])
    case 3
        disp(['dropc_two_spout_odor rewarded for the spout location (left vs. right)'])
    case 4
        disp(['dropc_two_spout_odor rewarded for odor on the left (always, begin stage 2)'])
    case 5
        disp(['dropc_two_spout_odor rewarded for odor on the right (always, begin stage 3)'])
end

if handles.dropcProg.reward_location_vs_odor==3
    if handles.dropcProg.reward_left_vs_right==1
        disp(['Mouse will be rewarded at the right spout'])
    else
        disp(['Mouse will be rewarded at the left spout'])
    end
end

handles.dropcProg.typeOfOdor=1; %handles.dropcProg.splusOdor=1;

%Enter right valves (8,16,32) and odor name
handles.dropcProg.rewardedOdorValveRight=uint8(32); %Make sure to use int8
handles.dropcProg.rewardedOdorNameRight='MO';

handles.dropcProg.otherOdorValveRight=uint8(16); %Make sure to use int8
handles.dropcProg.otherOdorNameRight='ISO';

%Enter left valves (1,2,4) and odor name
handles.dropcProg.rewardedOdorValveLeft=uint8(2); %Make sure to use int8
handles.dropcProg.rewardedOdorNameLeft='ACT';

handles.dropcProg.otherOdorValveLeft=uint8(4); %Make sure to use int8
handles.dropcProg.otherOdorNameLeft='MO';

%Enter final valve interval in sec (1.5 sec is usual)
handles.dropcProg.fvtime=1.5;

%Enter time interval for short trial test (0.5 sec is usual)
handles.dropcProg.shortTime=0.1;

%Enter number of response area segments (usually 4, must be less than 6)
handles.dropcProg.noRAsegments=2;
% noRA_segments=handles.dropcProg.noRAsegments;

%Enter response area DT for each response area segment (0.5 sec is usual)
handles.dropcProg.dt_ra=1;

%Enter time to stop odor delivery in sec. Make >shortTime and <=dt_ra*noRAsegments+shortTime, normally 2.5 s
handles.dropcProg.odor_stop=2.5;

%Enter time for water delivery (sec, try 0.5 s)
handles.dropcProg.rfTime=0.2; %0.2

%Enter time per trial (sec, not less than 8 s)
%Must be larger than TIME_POST+shortTime+dt_ra*dropcProg.noRAsegments+2
handles.dropcProg.timePerTrial=8;

%If you want this computer to save the odor shorts make this variable one
handles.dropcProg.sendShorts=0;

%When do I turn the opto on? 0=no opto, 1=FV, 2=odor, 3=reward
%Please note that the duration of the light is set by Master 8
handles.dropcProg.whenOptoOn=2;

%If you want the computer to punish the mouse for a false alarm by not
%starting the next trial for a ceratin interval enter the interval in
%seconds here.
handles.dropcProg.dt_punish=30;

handles.dropcProg.dt_iti=15;

%Enter comment
handles.comment='Test';

%Transition to partial reinforcement after reaching criterion? (1=yes, 0=no)
% transitionToPartial=0;

%If transition to partial will take place: Start partial reinforcement immediately (0) or after criterion is reached (1)?
% afterCriterion=1;

%Open valve for background odor (1=yes, 0=no)
% handles.dropcProg.backgroundOdor=0;

%% Set the variables for testing
%handles.dropcProg.testProg=0;
%handles.dropcProg.skipIntervals=0;

%% Initialize variables that the user will not change

handles.dropcData.trialPerformance=[];
handles.dropcData.ii_lick=[];
percent_corr_str=[];
block=0;

% dropcData
%Fellows random numbers are started randomly
handles.dropcData.fellowsNoOdor=randn(1,300);
handles.dropcData.fellowsNoSide=randn(1,300);

handles.dropcData.trialIndex=1;     %These are all trials excluding shorts
handles.dropcData.allTrialIndex=0;  %These are all trials including short and long trials
handles.dropcData.shortIndex=1;


%Note: handles.dropcData.allTrialResult 0=not licked, 1=licked, 2=short
%odor, 3=short FV


%Initialize the variables that define how the olfactometer runs
% dropcProg

%Set the variables that will not change
handles.dropcProg.numTrPerBlock=20;
handles.dropcProg.makeNoise = 0;
handles.dropcProg.consoleOut=1;
handles.dropcProg.splusOdor=1;
handles.dropcProg.sminusOdor=2;
handles.dropcProg.sumPdOn=7;
handles.dropcProg.sumNoLick=8;

%Set the numbers for digital output to INTAN
handles.dropcDraqOut.final_valve=uint8(6);
handles.dropcDraqOut.opto_on=uint8(64);
handles.dropcDraqOut.s_plus=uint8(1);
handles.dropcDraqOut.odor_onset=uint8(18);
handles.dropcDraqOut.short_before=uint8(2);
handles.dropcDraqOut.short_after=uint8(4);
handles.dropcDraqOut.hit=uint8(8);
handles.dropcDraqOut.miss=uint8(10);
handles.dropcDraqOut.correct_rejection=uint8(12);
handles.dropcDraqOut.false_alarm=uint8(14);
handles.dropcDraqOut.draq_trigger=uint8(128);
handles.dropcDraqOut.reinforcement=uint8(16);

%Set the numbers for digital output to olfactometer DIO96H/50
handles.dropcDioOut.final_valveLeft=uint8(4);
handles.dropcDioOut.final_valveRight=uint8(2);
handles.dropcDioOut.purge_valve=uint8(4);
handles.dropcDioOut.noise=uint8(8);
handles.dropcDioOut.background_valve=uint8(3);
handles.dropcDioOut.water_valve=uint8(1);
handles.dropcDioOut.water_valve_left=uint8(8);
handles.dropcDioOut.water_valve_right=uint8(1);

%% Then do all that needs to be done before the experiment starts
file_exists=exist(handles.dropcProg.output_file,'file');
run_program = 1;
if file_exists==2
    % Tell user to change the name
    run_program=0;
    h = msgbox('dropcspm cannot run: File already exists; change name');
end

%Get the random Fellows numbers for choosing S+/S- for trials
[handles.dropcProg.randomFellows handles.dropcProg.randomOpto]=dropcGetSlotnickOdorList();


%Setup reinforcements depending on whether the user chose go-no go vs. go-go
if handles.dropcProg.go_nogo==1
    %go-no go
    handles.dropcProg.fracReinforcement(1)=1.0; %Reinforcement for S+
    handles.dropcProg.fracReinforcement(2)=0; %Reinforcement for S-
    handles.dropcProg.doBuzz=0;
    reinforceSminus=0; %If this is zero reinforce only for hit, CR
else
    %go-go
    reinforceSminus=1;   %If this is one then reinforce regradless of the odor
    dropcProg.doBuzz=1;
    dropcProg.fracReinforcement(1)=0.7;   %Reinforcement for S+
    dropcProg.fracReinforcement(2)=0.7;   %Reinforcement of S-
end




%% Now run the olfactometer
if run_program==1
    
    allrandn=randn(1,400);
    ii_rn=1;
    next_rewarded_odor_side=0;
    trialResult=1;

    %Initialize the DIO96H/50 before the mouse comes in
    handles=dropcInitializePortsNow(handles);
    
    % Ask user to get mouse in box
    mouse_in_cage = 0;
    while mouse_in_cage == 0
        choice = questdlg('Now place ths mouse in the box: Is the mouse in?, did you start draq?', ...
            'Overwrite?', ...
            'Yes','No','No');
        % Handle response
        switch choice
            case 'Yes'
                
                mouse_in_cage = 1;
            case 'No'
                
                mouse_in_cage = 0;
                
        end
    end
    
    %
    % %Trigger Inverted Logic
    % fprintf(1, '\nWaiting for trigger...\n ');
    % while getvalue(handles.dio.Line(34))==0
    % end
    % fprintf(1, '\nStart of session...\n ');
    %
    tic
    
    while toc<1
    end
    stopTrials=0;
    
    while (stopTrials==0)&(handles.dropcData.trialIndex<200)
        %Do one trial
        
        fprintf('\n')
        handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;

        %Decide whether rewarded odor is on the left or right
        switch handles.dropcProg.reward_location_vs_odor
            case {1,2,3,4,5}
                %Which side for the odor
                if (handles.dropcData.fellowsNoOdor(handles.dropcData.trialIndex)>0)
                    %Rewarded odor on the left side
                    handles.dropcProg.rewarded_odor_side=0; %Rewarded odor is on the left side
                    handles.dropcProg.odorValveLeft=handles.dropcProg.rewardedOdorValveLeft;
                    handles.dropcProg.left_typeOfOdor=handles.dropcProg.rewardedOdorNameLeft;
                    handles.dropcProg.odorValveRight=handles.dropcProg.otherOdorValveRight;
                    handles.dropcProg.right_typeOfOdor=handles.dropcProg.otherOdorNameRight;
                    disp(['Trial No: ' num2str(handles.dropcData.trialIndex) '; Rewarded odor on the left'])
                else
                    %Rewarded odor on the right side
                    handles.dropcProg.rewarded_odor_side=1; %Rewarded odor is on the right side
                    handles.dropcProg.odorValveRight=handles.dropcProg.rewardedOdorValveRight;
                    handles.dropcProg.right_typeOfOdor=handles.dropcProg.rewardedOdorNameRight;
                    handles.dropcProg.odorValveLeft=handles.dropcProg.otherOdorValveLeft;
                    handles.dropcProg.left_typeOfOdor=handles.dropcProg.otherOdorNameLeft;
                    disp(['Trial No: ' num2str(handles.dropcData.trialIndex) '; Rewarded odor on the right'])
                end

        end

        
        handles.dropcData.ii_lick(handles.dropcData.trialIndex)=0;

        short_trial=1;
        while short_trial==1
            %Wait till the mouse licks on either spout
            while (sum(getvalue(handles.dio.Line(27:28)))==2)
            end

            finalValveOK=dropcFinalValveOK_two_spout_go_no_go(handles);
            %This mouse stayed on during the final valve; do the
            %single trial!

            if finalValveOK==1
                short_trial=0;
            end
        end



        RA_responses=zeros(1,handles.dropcProg.noRAsegments);

        for noRA_segments=1:handles.dropcProg.noRAsegments

            this_toc=toc;
            while toc-this_toc<handles.dropcProg.dt_ra
                if handles.dropcProg.rewarded_odor_side==0
                    %Rewarded odor on the left side
                    left_bit=getvalue(handles.dio.Line(28)); %if this is zero the mouse licks left
                    if left_bit==0
                        RA_responses(noRA_segments)=1;
                        left_right=0;
                    end
                else
                    right_bit=getvalue(handles.dio.Line(27)); %if this is zero the mouse licks right
                    if right_bit==0
                        left_right=1;
                        RA_responses(noRA_segments)=1;
                    end
                end
            end

        end

        trialResult=0;

        if left_right==0
            %Mouse licking on the left side
            if handles.dropcProg.rewarded_odor_side==0
                disp(['Mouse engaged in left port during S+ trial '])
                spm=1;
                if sum(RA_responses)==length(RA_responses)
                    %This is a hit
                    %Notify INTAN
                    handles.dropcDigOut.draqPortStatus=8;
                    dropcUpdateDraqPort(handles);
                    this_toc=toc
                    while toc-this_toc<0.1
                    end
                    dropcReinforceNow_two_spout(handles,left_right);
                    disp(['Left port, hit '])
                    trialResult=1;
                else
                    %This is a miss
                    %Notify INTAN
                    handles.dropcDigOut.draqPortStatus=9;
                    dropcUpdateDraqPort(handles);
                    disp(['Left port, miss '])
                end
            else
                disp(['Mouse engaged in left port during S- trial '])
                spm=0;
                    if sum(RA_responses)==length(RA_responses)
                    %This is a false alarm
                    %Notify INTAN
                    handles.dropcDigOut.draqPortStatus=10;
                    dropcUpdateDraqPort(handles);
                    disp(['Left port, FA '])
                else
                    %This is a correct rejection
                    %Notify INTAN
                    handles.dropcDigOut.draqPortStatus=11;
                    dropcUpdateDraqPort(handles);
                    disp(['Left port, CR '])
                    trialResult=1;
                end
            end
        else
             %Mouse licking on the right side
            if handles.dropcProg.rewarded_odor_side==0
                disp(['Mouse engaged in right port during S- trial '])
                spm=0;
                   if sum(RA_responses)==length(RA_responses)
                    %This is a false alarm
                    %Notify INTAN
                    handles.dropcDigOut.draqPortStatus=14;
                    dropcUpdateDraqPort(handles);
                    disp(['Right port, FA '])
                else
                    %This is a correct rejection
                    %Notify INTAN
                    handles.dropcDigOut.draqPortStatus=15;
                    dropcUpdateDraqPort(handles);
                    disp(['Right port, CR '])
                    trialResult=1;
                end

            else
                disp(['Mouse engaged in right port during S+ trial '])
                spm=1;
                if sum(RA_responses)==length(RA_responses)
                    %This is a hit
                    %Notify INTAN
                    handles.dropcDigOut.draqPortStatus=12;
                    dropcUpdateDraqPort(handles);
                    this_toc=toc
                    while toc-this_toc<0.1
                    end
                    dropcReinforceNow_two_spout(handles,left_right);
                    disp(['Right port, hit '])
                    trialResult=1;
                else
                    %This is a miss
                    %Notify INTAN
                    handles.dropcDigOut.draqPortStatus=13;
                    dropcUpdateDraqPort(handles);
                    disp(['Right port, miss '])
                end
            end
        end

% 
%         if sum(RA_responses)==length(RA_responses)
%             if handles.dropcProg.rewarded_odor_side==0
%                 %Rewarded odor on the left side
%                 left_right=0;
%                 dropcReinforceNow_two_spout(handles,left_right);
%                 disp(['Left port, mouse licked for S+ on the left side '])
%             else
%                 left_right=1;
%                 dropcReinforceNow_two_spout(handles,left_right);
%                 disp(['Right port, mouse licked for S+ right side '])
%             end
%         else
%             if (handles.dropcData.fellowsNoOdor(handles.dropcData.trialIndex)>0)
%                 %Rewarded odor on the left side
%                 left_right=0;
% 
%                 disp(['Left port, mouse licked for S+ ' num2str(trialResult) ' mouse rewarded'])
%             else
%                 left_right=1;
%                 dropcReinforceNow_two_spout(handles,left_right);
%                 disp(['Right port, mouse licked for S+= ' num2str(trialResult) ' mouse rewarded'])
%             end
%         end
% 
% 
%         left_bit=1;
%         right_bit=1;
%         
%         while (left_bit==1)&(right_bit==1)
%             left_bit=getvalue(handles.dio.Line(28)); %if this is zero the mouse licks left
%             right_bit=getvalue(handles.dio.Line(27)); %if this is zero the mouse licks right
%         end
%                 end
%         trialResult=0;
%         
%         switch handles.dropcProg.reward_location_vs_odor
%             case 1
%                 %Begin, mouse gets water wherever s/he licks
%                 if left_bit==0
%                     trialResult=1;
%                     left_right=0;
%                     dropcReinforceNow_two_spout(handles,left_right);
%                     disp(['Left port, mouse licked= ' num2str(trialResult) ' mouse rewarded'])
%                 end
%                 
%                 if right_bit==0
%                     trialResult=1;
%                     left_right=1;
%                     dropcReinforceNow_two_spout(handles,left_right);
%                     disp(['Right port, mouse licked= ' num2str(trialResult) ' mouse rewarded'])
%                 end
%             case {2,4,5,6}
%                 %Reward odor delivery
%                 if left_bit==0
%                     left_right=0;
%                 end
%                 if right_bit==0
%                     left_right=1;
%                 end
%                 if (handles.dropcProg.rewarded_odor_side==0)&(left_bit==0)
%                     trialResult=1;
%                     left_right=0;
%                     dropcReinforceNow_two_spout(handles,left_right);
%                     disp(['Left port, mouse licked= ' num2str(trialResult) ' mouse rewarded'])
%                 else
%                     disp(['Left port, mouse licked= ' num2str(trialResult) ' mouse not rewarded'])
%                     
%                     %Do delay if needed
%                     start_dt_punish=toc;
%                     while (toc-start_dt_punish)<handles.dropcProg.dt_punish
%                     end
%                     
%                 end
%                 
%                 if (handles.dropcProg.rewarded_odor_side==1)&(right_bit==0)
%                     trialResult=1;
%                     left_right=1;
%                     dropcReinforceNow_two_spout(handles,left_right);
%                     disp(['Right port, mouse licked= ' num2str(trialResult) ' mouse rewarded'])
%                 else
%                     disp(['Right port, mouse licked= ' num2str(trialResult) ' mouse not rewarded'])
%                     %Do delay if needed
%                     start_dt_punish=toc;
%                     while (toc-start_dt_punish)<handles.dropcProg.dt_punish
%                     end
%                 end
%             case 3
%                 %Reward the side
%                   if left_bit==0
%                     left_right=0;
%                 end
%                 if right_bit==0
%                     left_right=1;
%                 end
%                 if (handles.dropcProg.reward_left_vs_right==0)&(left_bit==0)
%                     trialResult=1;
%                     left_right=0;
%                     dropcReinforceNow_two_spout(handles,left_right);
%                     disp(['Left port, mouse licked= ' num2str(trialResult) ' mouse rewarded'])
%                 else
%                     disp(['Left port, mouse licked= ' num2str(trialResult) ' mouse not rewarded'])
%                     %Do delay if needed
%                     start_dt_punish=toc;
%                     while (toc-start_dt_punish)<handles.dropcProg.dt_punish
%                     end
%                 end
%                 
%                 if (handles.dropcProg.reward_left_vs_right==1)&(right_bit==0)
%                     trialResult=1;
%                     left_right=1;
%                     dropcReinforceNow_two_spout(handles,left_right);
%                     disp(['Right port, mouse licked= ' num2str(trialResult) ' mouse rewarded'])
%                 else
%                     disp(['Right port, mouse licked= ' num2str(trialResult) ' mouse not rewarded'])
%                     %Do delay if needed
%                     start_dt_punish=toc;
%                     while (toc-start_dt_punish)<handles.dropcProg.dt_punish
%                     end
%                 end
%         end
%                 
        dropcTurnValvesOffNow(handles);
        
%         [trialResult, left_right]=dropcDoesMouseRespondNow_two_spout(handles);
        handles.dropcData.allTrialIndex=handles.dropcData.allTrialIndex+1;
        handles.dropcData.allTrialResult(handles.dropcData.allTrialIndex)=trialResult;
        handles.dropcData.allTrial_left_right(handles.dropcData.allTrialIndex)=left_right;
        handles.dropcData.allTrial_spm(handles.dropcData.allTrialIndex)=spm;
        handles.dropcData.allTrialTime(handles.dropcData.allTrialIndex)=toc;
        handles.dropcData.allTrialLeftTypeOfOdor{handles.dropcData.allTrialIndex}=handles.dropcProg.left_typeOfOdor;
        handles.dropcData.allTrialRightTypeOfOdor{handles.dropcData.allTrialIndex}=handles.dropcProg.right_typeOfOdor;
        handles.dropcData.allTrial_rewarded_odor_side(handles.dropcData.allTrialIndex)=handles.dropcProg.rewarded_odor_side;
        %                 handles.dropcData.ii_lick(handles.dropcData.trialIndex)=0;
        
        start_toc=toc;
        while toc-start_toc<handles.dropcProg.dt_iti
        end
        
        
        
        
        %Output record of trial performance
        if handles.dropcProg.reward_location_vs_odor==1
%             Mouse is being trained on Begin
            if (handles.dropcProg.rewarded_odor_side==left_right)&(trialResult==1)
                correctTrial(handles.dropcData.trialIndex)=1;
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'X'];
            else
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'O'];
                correctTrial(handles.dropcData.trialIndex)=1;
            end
        end

        if handles.dropcProg.reward_location_vs_odor==2
            %Mouse was rewarded for the odor
            if (handles.dropcProg.rewarded_odor_side==left_right)&(trialResult==1)
                correctTrial(handles.dropcData.trialIndex)=1;
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'X'];
            else
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'O'];
                correctTrial(handles.dropcData.trialIndex)=0;
            end
        end
        
        if handles.dropcProg.reward_location_vs_odor==3
            %Mouse was rewarded for location
            if (handles.dropcProg.reward_left_vs_right==left_right)&(trialResult==1)
                correctTrial(handles.dropcData.trialIndex-1)=1;
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'X'];
            else
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'O'];
                correctTrial(handles.dropcData.trialIndex-1)=0;
            end
        end
        
        if rem(handles.dropcData.trialIndex,20)==1
            handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance ' '];
        end
        
        dropcDisplayOutString(handles.dropcData.trialPerformance)
        
        if handles.dropcData.trialIndex-1>=20
            
            
            max_block=floor((handles.dropcData.trialIndex-1)/20);
            if handles.dropcData.trialIndex>1
                if rem((handles.dropcData.trialIndex-1),20)==1
                    block=block+1;
                    percent_correct(block)= 100*sum(correctTrial((block-1)*20+1:block*20))/20;
                    percent_corr_str=[percent_corr_str num2str(percent_correct(block)) ' '];
                end
            end
            
            
            disp(percent_corr_str)
        end
        
        
        save(handles.dropcProg.output_file,'handles');
        
        handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    
    
end

delete(handles.dio)

clear handles

end
