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
handles.dropcProg.output_file='C:\Users\restrepo\Desktop\Amber\052517-Purge-test2';
%handles.dropcProg.output_file='/Users/restrepd/Documents/Projects/testdropc/m01.mat';

%Reinforce on odorA only? (1=yes, go-no go, 0=no, reinforce both, go-go)
handles.dropcProg.go_nogo=1;

%Enter odorA valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.odorA_OdorValve=uint8(8); %Make sure to use int8
handles.dropcProg.odorA_Name='EA';


%Enter odorB valve (1,2,4,8,16,32,64,128) and odor name
handles.dropcProg.odorB_OdorValve=uint8(4); %Make sure to use int8
handles.dropcProg.odorB_Name='PA';

%Enter final valve interval in sec (1.5 sec is usual)
handles.dropcProg.fvtime=1.5;

%Enter time interval for odors A a nd B
handles.dropcProg.odorDT=0.5;

%Enter the inter odor interval
handles.dropcProg.interDT=1.5;

%Enter time for water delivery (sec, try 0.5 s)
handles.dropcProg.rfTime=0.3;

%Enter time per trial (sec, not less than 8 s)
%Must be larger than TIME_POST+shortTime+dt_ra*dropcProg.noRAsegments+2
handles.dropcProg.timePerTrial=8;

%If you want this computer to save the odor shorts make this variable one
handles.dropcProg.sendShorts=0;

%When do I turn the opto on? 0=no opto, 1=FV, 2=odor, 3=reward
%Please note that the duration of the light is set by Master 8
handles.dropcProg.whenOptoOn=1;

%If you want the computer to punish the mouse for a false alarm by not
%starting the next trial for a ceratin interval enter the interval in
%seconds here. 
handles.dropcProg.dt_punish=0;

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
handles.dropcProg.odorA_Odor=1;
handles.dropcProg.odorB_Odor=2;
handles.dropcProg.sumPdOn=7;
handles.dropcProg.sumNoLick=8;

%Set the numbers for digital output to DT3010
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




%Setup reinforcements depending on whether the user chose go-no go vs. go-go
if handles.dropcProg.go_nogo==1
    %go-no go
    handles.dropcProg.fracReinforcement(1)=1.0; %Reinforcement for odorA
    handles.dropcProg.fracReinforcement(2)=0; %Reinforcement for odorB
    handles.dropcProg.doBuzz=0;
    reinforceodorB_=0; %If this is zero reinforce only for hit, CR
else
    %go-go
    reinforceodorB_=1;   %If this is one then reinforce regradless of the odor
    dropcProg.doBuzz=1;
    dropcProg.fracReinforcement(1)=0.7;   %Reinforcement for odorA
    dropcProg.fracReinforcement(2)=0.7;   %Reinforcement of odorB
end

% dropcProg.fracReinforcement(3)=0.5;
% dropcProg.fracReinforcement(4)=1.0;

% %Setup transition to partial reinforcement
% if (transitionToPartial==1)
%     if (afterCriterion==0)
%         handles.dropcProg.fracReinforcement(1)=0.7;
%         handles.dropcProg.fracReinforcement(3)=0.7;
%         if (reinforceodorB_==1)
%             handles.dropcProg.fracReinforcement(2)=0.7;
%         end
%     end
% end



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
        
        %Decide which is the first odor
        rand_nos=rand(1,2);
        if (rand_nos(1)<0.5)
            %odorA odor
            handles.dropcProg.odor1Valve=handles.dropcProg.odorA_OdorValve;
            handles.dropcProg.typeOfOdor1=handles.dropcProg.odorA_Odor;
            disp(['Trial No: ' num2str(handles.dropcData.trialIndex) ' odor 1: odorA'])
        else
            %odorB odor
            handles.dropcProg.odor1Valve=handles.dropcProg.odorB_OdorValve;
            handles.dropcProg.typeOfOdor1=handles.dropcProg.odorB_Odor;
            disp(['Trial No: ' num2str(handles.dropcData.trialIndex) 'odor 1: odorB'])
        end

        %Decide which is the second odor
         if (rand_nos(2)<0.5)
            %odorA odor
            handles.dropcProg.odor2Valve=handles.dropcProg.odorA_OdorValve;
            handles.dropcProg.typeOfOdor2=handles.dropcProg.odorA_Odor;
            disp(['Trial No: ' num2str(handles.dropcData.trialIndex) ' odor 2: odorA'])
        else
            %odorB odor
            handles.dropcProg.odor2Valve=handles.dropcProg.odorB_OdorValve;
            handles.dropcProg.typeOfOdor2=handles.dropcProg.odorB_Odor;
            disp(['Trial No: ' num2str(handles.dropcData.trialIndex) 'odor 2: odorB'])
        end



        %Now run the trial



        resultOfTrial=-2;
        while (resultOfTrial == -2)
            %While mouse is doing short samples

            %Wait till the mouse pokes into the sampling chamber
            while (dropcNosePokeNow(handles)==0)
            end

            if (dropcFinalValveOKdnms(handles)==1)
                %This mouse stayed on during the final valve; do the
                %single trial!


                trialResult=dropcDoesMouseRespondNow(handles);
                handles.dropcData.allTrialIndex=handles.dropcData.allTrialIndex+1;
                handles.dropcData.allTrialResult(handles.dropcData.allTrialIndex)=trialResult;
                handles.dropcData.allTrialTime(handles.dropcData.allTrialIndex)=toc;
                handles.dropcData.allTrialTypeOfOdor(handles.dropcData.allTrialIndex)=handles.dropcProg.typeOfOdor;

                if (trialResult~=2)
                    %This is a go
                    
                    %Turn opto TTL off 
                    if (handles.dropcProg.whenOptoOn==2)
                        dataValue=uint8(15);
                        putvalue(handles.dio.Line(9:12),dataValue);
                    end
                    
                    dropcTurnValvesOffNow(handles);
                    handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                    handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                    handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                    handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                    
                    %result_of_trial=trialResult
                    disp(['Result of trial= ' num2str(trialResult)])
                    dropcReinforceAppropriately(handles);
                    
                    %Turn opto TTL off 
                    if (handles.dropcProg.whenOptoOn==3)
                        dataValue=uint8(15);
                        putvalue(handles.dio.Line(9:12),dataValue);
                    end
                    
                    handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
                    dropcTurnValvesOffNow(handles);
                    %Mouse must leave

                    while dropcNosePokeNow(handles)==1
                    end

                    resultOfTrial=1;

                else

                    %This is a short trial that ended after odor onset

                    %Notify draq


                    %                         handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_after+handles.dropcDraqOut.odor_onset;
                    %                         dropcUpdateDraqPort(handles);
                    dropcTurnValvesOffNow(handles);
                    %This turns all off
                    handles.dropcDigOut.draqPortStatus=uint8(0);
                    dropcUpdateDraqPort(handles);
                    
                    if handles.dropcProg.sendShorts==1
                        %Send a short
                        %                             handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_after+handles.dropcDraqOut.draq_trigger;
                        %                             dropcUpdateDraqPort(handles);
                        %
                        %                             start_toc=toc;
                        %                             while toc-start_toc<0.2
                        %                             end
                        %
                        %Extremely important. If you do not do this you do not transfer all
                        %trials to the draq computer
                        %Notify draq of odor number
                        
                        handles.dropcData.shortTime(handles.dropcData.shortIndex)=toc;
                        handles.dropcData.shortType(handles.dropcData.shortIndex)=1;
                        handles.dropcData.shortIndex(handles.dropcData.shortIndex)=handles.dropcData.shortIndex(handles.dropcData.shortIndex)+1;
                        
                        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_before;
                        dropcUpdateDraqPort(handles);
                        start_toc=toc;
                        while (toc-start_toc<0.3)
                        end
                        
                        dropcStartDraq(handles)
                        
                        pause(handles.dropcProg.timePerTrial)
                    end
                    
                    disp('Short after odor onset')
                    %                         start_toc=toc;
                    %                         while toc-start_toc<handles.dropcProg.timePerTrial
                    %                         end




                    
                    resultOfTrial= -2;

                end

            else

                %This is a short trial because mouse was not poking at end of FinalValve
                %It ended before odor onset

                %Notify draq
                dropcTurnValvesOffNow(handles);
                %This turns all off
                handles.dropcDigOut.draqPortStatus=uint8(0);
                dropcUpdateDraqPort(handles);
                
                pause(handles.dropcProg.timePerTrial)
                
                resultOfTrial= -2;
                handles.dropcData.allTrialIndex=handles.dropcData.allTrialIndex+1;
                handles.dropcData.allTrialResult(handles.dropcData.allTrialIndex)=3;
                handles.dropcData.allTrialTime(handles.dropcData.allTrialIndex)=toc;
                handles.dropcData.allTrialTypeOfOdor(handles.dropcData.allTrialIndex)=handles.dropcProg.typeOfOdor;
                
                disp('Short before odor onset')
            end
        end

        %Output record of trial performance

        if handles.dropcData.odorType(handles.dropcData.trialIndex-1)==handles.dropcProg.odorA_Odor
            if handles.dropcData.trialScore(handles.dropcData.trialIndex-1)==1
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'X'];
            else
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'O'];
            end
        else
            if handles.dropcData.trialScore(handles.dropcData.trialIndex-1)==1
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'O'];
            else
                handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance 'X'];
            end
        end

        if rem(handles.dropcData.trialIndex,20)==1
            handles.dropcData.trialPerformance=[handles.dropcData.trialPerformance ' '];
        end

        dropcDisplayOutString(handles.dropcData.trialPerformance)

        if handles.dropcData.trialIndex-1>=20
            for trialNo=1:handles.dropcData.trialIndex-1
                if handles.dropcData.odorType(trialNo)==handles.dropcProg.odorA_Odor
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

            max_block=floor((handles.dropcData.trialIndex-1)/20);
            if handles.dropcData.trialIndex>1
                if rem((handles.dropcData.trialIndex-1),20)==1
                    block=block+1;
                    percent_correct(block)= 100*sum(correctTrial((block-1)*20+1:block*20))/20;
                    percent_corr_str=[percent_corr_str num2str(percent_correct(block)) ' '];
                end
            end

            %             blockNo=1:max_block;
            %             plot(blockNo,percent_correct,'x-r')
            %             xlim([0 11])
            %             ylim([40 110])
            %             ylabel('Percent correct')
            %             xlabel('Block No')
            %             title('Percent correct')
            %percent_corr=percent_correct
            disp(percent_corr_str)
        end


        save(handles.dropcProg.output_file,'handles');





    end

end

delete(handles.dio)

clear handles

