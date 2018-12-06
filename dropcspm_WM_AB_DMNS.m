%dropcspm_WM runs a delayed non-match to sample (DMNS) working memory
%task

%% Close all
clear all
close all

%% Setup the figure
% figure(1)
% hold on
% subplot(2,1,1)
% title('Licks per trial. To stop execution Cntrl C')

%% User should change these variables

%To stop this program enter cntrl shift esc

%First file name for output
%IMPORTANT: This should be a .mat file
handles.dropcProg.output_file='C:\Users\restrepo\Desktop\amber\062917_test1b_WM';
%handles.dropcProg.output_file='/Users/restrepd/Documents/Projects/testdropc/m01.mat';

%Reinforce on S+ only? (1=yes, go-no go, 0=no, reinforce both, go-go)
handles.dropcProg.go_nogo=1;

%Enter odor a  valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.odor_a_OdorValve=uint8(32); %Make sure to use int8
handles.dropcProg.odor_a_Name='iso';


%Enter odor b valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.odor_b_OdorValve=uint8(32); %Make sure to use int8
handles.dropcProg.odor_b_Name='mo';

%Enter final valve interval in sec (1.5 sec is usual)
handles.dropcProg.fvtime=1.5;

%Enter time interval for short trial test (0.5 sec is usual)
handles.dropcProg.shortTime=0.5;

%Enter number of response area segments (usually 4, must be less than 6)
handles.dropcProg.odorTime=1;

%Enter response area DT for each rasponse area segment (0.5 sec is usual)
handles.dropcProg.must_lick_dt=0.2;

%Enter time to stop odor delivery in sec. Make >shortTime and <=dt_ra*noRAsegments+shortTime, normally 2.5 s
handles.dropcProg.odor_stop=2.5;

%Enter time for water delivery (sec, try 0.5 s)
handles.dropcProg.rfTime=0.3;

%Enter final purge time
handles.dropcProg.finalPurgeTime=1;

%Enter delay interval
handles.dropcProg.delayInterval=2;

%Enter punish interval
handles.dropcProg.punishInterval=10;

%Enter time per trial (sec, not less than 8 s)
%Must be larger than TIME_POST+shortTime+dt_ra*dropcProg.noRAsegments+2
handles.dropcProg.timePerTrial=8;

%If you want this computer to save the odor shorts make this variable one
handles.dropcProg.sendShorts=0;

%When do I turn the opto on? 0=no opto, 1=FV, 2=odor, 3=reward
%Please note that the duration of the light is set by Master 8
handles.dropcProg.whenOptoOn=1;

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
percent_corr_str=[];
block=0;

% dropcData
%Fellows random numbers are started randomly
handles.dropcData.fellowsNo=20*ceil(10*rand(1))-19;
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
handles.dropcProg.odor_a_Odor=1;
handles.dropcProg.odor_b_Odor=2;
handles.dropcProg.sumPdOn=7;
handles.dropcProg.sumNoLick=8;

%Set the numbers for digital output to DT3010
handles.dropcDraqOut.final_valve=uint8(1);
handles.dropcDraqOut.opto_on=uint8(64);
handles.dropcDraqOut.odorA=uint8(2);
handles.dropcDraqOut.odorB=uint8(4);
handles.dropcDraqOut.short=uint8(8);
handles.dropcDraqOut.draq_trigger=uint8(128);
handles.dropcDraqOut.reinforcement=uint8(16);

%Set the numbers for digital output to olfactometer DIO96H/50
handles.dropcDioOut.final_valve=uint8(2);
handles.dropcDioOut.purge_valve=uint8(4);
handles.dropcDioOut.noise=uint8(8);
handles.dropcDioOut.background_valve=uint8(3);
handles.dropcDioOut.water_valve=uint8(1);

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
    reinforceodor_b_=0; %If this is zero reinforce only for hit, CR
else
    %go-go
    reinforceodor_b_=1;   %If this is one then reinforce regradless of the odor
    dropcProg.doBuzz=1;
    dropcProg.fracReinforcement(1)=0.7;   %Reinforcement for S+
    dropcProg.fracReinforcement(2)=0.7;   %Reinforcement of S-
end

correct_per_trial=[];
actual_trials=0;



%% Now run the olfactometer
if run_program==1
    
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
    tic
    
    while toc<1
    end
    stopTrials=0;
    
    while (stopTrials==0)&(handles.dropcData.trialIndex<200)
        %Do one trial
        
        fprintf('\n')
        %Decide which are odor 1 and 2
        
        %Odor 1
        
            %odor a
            handles.dropcProg.odorValve1=handles.dropcProg.odor_a_OdorValve;
            handles.dropcProg.typeOfOdor1=handles.dropcProg.odor_a_Odor;
            handles.dropcDraqOut.odor1=handles.dropcDraqOut.odorA;
            disp(['Trial No: ' num2str(handles.dropcData.trialIndex) '; Odor 1: odor A'])
     
        
        %Odor 2
        if (rand > 0.5)
            %odor a
            handles.dropcProg.odorValve2=handles.dropcProg.odor_a_OdorValve;
            handles.dropcProg.typeOfOdor2=handles.dropcProg.odor_a_Odor;
            handles.dropcDraqOut.odor2=handles.dropcDraqOut.odorA;
            disp(['Trial No: ' num2str(handles.dropcData.trialIndex) '; Odor 2: odor A'])
        else
            %odor b
            handles.dropcProg.odorValve2=handles.dropcProg.odor_b_OdorValve;
            handles.dropcProg.typeOfOdor2=handles.dropcProg.odor_b_Odor;
            handles.dropcDraqOut.odor2=handles.dropcDraqOut.odorB;
            disp(['Trial No: ' num2str(handles.dropcData.trialIndex) '; Odor 2: odor B'])
        end
        
        
        
        
        %Now run the trial
        
        
        
        resultOfTrial=0;
        while (resultOfTrial == 0)
            %While mouse is doing short samples
            
            %Wait till the mouse pokes into the sampling chamber
            while (dropcNosePokeNow(handles)==0)
            end
            
            resultOfTrial=dropcFinalValveOK_WM1(handles);
            if (resultOfTrial==1)
                
                %Wait for the end of odor 1
                this_time=toc;
                while toc-this_time<handles.dropcProg.odorTime
                end
                
                %Turn off draq
                handles.dropcDigOut.draqPortStatus=0;
                dropcUpdateDraqPort(handles);
                
                %Now purge out odor 1 and bring in odor 2 to the final
                %valve
                
                %Divert final valve towards the exhaust
                %Divert purge valve towards the port
                dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
                dataValue=bitcmp(dataValue);
                putvalue(handles.dio.Line(17:24),dataValue);
                
                
                %Turn on odor valve
                dataValue=handles.dropcProg.odorValve2;
                dataValue=bitcmp(uint8(dataValue));
                
                putvalue(handles.dio.Line(1:8),dataValue);
                
                %Wait for the delay interval
                this_time=toc;
                while toc-this_time<handles.dropcProg.delayInterval
                end
                
                
                
                
                %Turn FinalValve towards the odor port: turn on odor...)
                dataValue=bitcmp(uint8(0));
                putvalue(handles.dio.Line(17:24),dataValue);
                
                %Notify draq of odor 2
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor2;
                dropcUpdateDraqPort(handles);
                
                %Wait for the end of odor 2
                this_time=toc;
                while toc-this_time<handles.dropcProg.odorTime
                end
                
                %Divert final valve towards the exhaust
                %Divert purge valve towards the port
                dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
                dataValue=bitcmp(dataValue);
                putvalue(handles.dio.Line(17:24),dataValue);
                
                %Turn off all odor valves
                putvalue(handles.dio.Line(1:8),uint8(255));
                
                
                %Turn off draq
                handles.dropcDigOut.draqPortStatus=0;
                dropcUpdateDraqPort(handles);
                
                %Trigger
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.draq_trigger;
                dropcUpdateDraqPort(handles);
                
                end_toc=toc+handles.dropcProg.must_lick_dt;
                didLick=0;
                while (toc<end_toc)
                    %lickStatus=dropcGetLickStatus(handles);
                    if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
                        %sum(handles.dropcProg.noLick))
                        %Mouse licked!
                        didLick=1;
                    end
                end
                
                was_reinforced=0;
                if handles.dropcProg.odorValve1~=handles.dropcProg.odorValve2
                    if didLick==1
                        %Notify draq of reinforcement
                        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.reinforcement;
                        dropcUpdateDraqPort(handles);
                        dropcReinforceNow(handles);
                        was_reinforced=1;
                        
                        %Turn off draq
                        handles.dropcDigOut.draqPortStatus=0;
                        dropcUpdateDraqPort(handles);
                        
                        actual_trials=actual_trials+1;
                        correct_per_trial(actual_trials)=1;
                        disp('Different odors, mouse licked, correct response')
                    else
                        actual_trials=actual_trials+1;
                        correct_per_trial(actual_trials)=0;
                        disp('Different odors, mouse did not lick, incorrect response')
                        %Punish mouse for lack of response to nonmatch
                        
                        
                        start_time=toc;
                        while (toc-start_time<handles.dropcProg.rfTime)
                        end
                        %Turn off draq
                        handles.dropcDigOut.draqPortStatus=0;
                        dropcUpdateDraqPort(handles);
                        
                        start_toc=toc;
                        while toc-start_toc<handles.dropcProg.punishInterval
                        end
                    end
                else
                    
                    start_time=toc;
                    while (toc-start_time<handles.dropcProg.rfTime)
                    end
                    %Turn off draq
                    handles.dropcDigOut.draqPortStatus=0;
                    dropcUpdateDraqPort(handles);
                    if didLick==1
                        actual_trials=actual_trials+1;
                        correct_per_trial(actual_trials)=0;
                        disp('The same odor, mouse licked, incorrect response')
                    else
                        actual_trials=actual_trials+1;
                        correct_per_trial(actual_trials)=1;
                        disp('The same odor, mouse did not lick, correct response')
                    end
                end
                
                
                
                start_toc=toc;
                while toc-start_toc<handles.dropcProg.fvtime
                end
                
                %Divert final valve towards the port
                %Divert purge valve towards exhaust
                putvalue(handles.dio.Line(17:24),uint8(255));
                
                
                
                handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
                
                %Mouse must leave
                
                while dropcNosePokeNow(handles)==1
                end
                
                handles.dropcData.allTrialIndex=handles.dropcData.allTrialIndex+1;
                handles.dropcData.allTrialResult(handles.dropcData.allTrialIndex)=1;
                handles.dropcData.allTrialdidLick(handles.dropcData.allTrialIndex)=didLick;
                handles.dropcData.allTrialwasReinforced(handles.dropcData.allTrialIndex)=was_reinforced;
                handles.dropcData.allTrialTime(handles.dropcData.allTrialIndex)=toc;
                handles.dropcData.allTrialOdor1(handles.dropcData.allTrialIndex)=handles.dropcProg.typeOfOdor1;
                handles.dropcData.allTrialOdor2(handles.dropcData.allTrialIndex)=handles.dropcProg.typeOfOdor2;
                handles.dropcData.correct(handles.dropcData.allTrialIndex)=correct_per_trial(actual_trials);
                disp('End of full tiral')
                
                if rem(actual_trials,20)==0
                    %This is a block
                    fprintf(1,'\nBlock number %d, percent correct= %d\n\n',ceil(actual_trials/20),100*sum(correct_per_trial(end-19:end))/20)
                end
            else
                %This is a short
                handles.dropcData.allTrialIndex=handles.dropcData.allTrialIndex+1;
                handles.dropcData.allTrialResult(handles.dropcData.allTrialIndex)=2;
                handles.dropcData.allTrialdidLick(handles.dropcData.allTrialIndex)=0;
                handles.dropcData.allTrialwasReinforced(handles.dropcData.allTrialIndex)=0;
                handles.dropcData.allTrialTime(handles.dropcData.allTrialIndex)=toc;
                handles.dropcData.allTrialOdor1(handles.dropcData.allTrialIndex)=handles.dropcProg.typeOfOdor1;
                handles.dropcData.allTrialOdor2(handles.dropcData.allTrialIndex)=handles.dropcProg.typeOfOdor2;
                handles.dropcData.correct(handles.dropcData.allTrialIndex)=-1;
                
                disp('Short')
                
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short;
                dropcUpdateDraqPort(handles);
                
                start_toc=toc;
                while toc-start_toc<1
                end
                
                handles.dropcDigOut.draqPortStatus=0;
                dropcUpdateDraqPort(handles);
                

                %Turn off all odor valves
                putvalue(handles.dio.Line(1:8),uint8(255));

                %Divert final valve towards the exhaust
                %Divert purge valve towards the port
                dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
                dataValue=bitcmp(dataValue);
                putvalue(handles.dio.Line(17:24),dataValue);
                
                start_toc=toc;
                while toc-start_toc<handles.dropcProg.fvtime
                end
                
                %Divert final valve towards the port
                %Divert purge valve towards exhaust
                putvalue(handles.dio.Line(17:24),uint8(255));
                
                %Punish mouse for short
                while toc-start_toc<handles.dropcProg.punishInterval
                end
                
            end
        end
        
        
        
        
        save(handles.dropcProg.output_file,'handles');
        
        
        
        
        
    end
    
end

delete(handles.dio)

clear handles

