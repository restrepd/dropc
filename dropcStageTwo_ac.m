function handles = dropcStageTwo_ac(handles)
%Begin stage 1: Give mouse water if they lick!

while handles.dropcData.trialIndex<160
    
    
    %Do one trial
    handles.dropcData.ii_lick(handles.dropcData.trialIndex)=0;
    trialNo=handles.dropcData.trialIndex;
   
    %Now run the trial
    resultOfTrial=-2;
    while (resultOfTrial == -2)
        %While mouse is doing short samples
        
        %Wait till the mouse pokes into the sampling chamber
        while (dropcNosePokeNow_ac(handles)==0)
        end
        
        handles.dropcData.startTrialTime=toc;
        if (dropcFinalValveOKBegin_ac(handles)==1)
            %This mouse stayed on during the final valve; do the
            %single trial!
            
            
            trialResult=dropcDoesMouseRespondNow_ac(handles);
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            if (trialResult~=2)
                
                switch handles.acces
                    
                    case 0
                        dropcTurnValvesOffNow(handles);
                        %Turn valves and opto TTL off
                    case 1
                        %ACCES
                        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,255);
                        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,0);
                end
                
                handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                
                dropcReinforceAppropriately_ac(handles);
                
                %Mouse must leave
                while dropcNosePokeNow_ac(handles)==1
                end
                
                fprintf(1, 'Trial No: %d, trial time %d, trial result = %d\n', handles.dropcData.trialIndex, handles.dropcData.trialTime(handles.dropcData.trialIndex),trialResult);
                if rem(handles.dropcData.trialIndex,20)==0
                   percent_trials_licked=100*sum(handles.dropcData.trialScore(handles.dropcData.trialIndex-19:handles.dropcData.trialIndex))/20;
                   fprintf(1, '\n\nPercent correct for block No %d: %d\n\n', floor(handles.dropcData.trialIndex/20),percent_trials_licked);
                   save(handles.dropcProg.output_file,'handles');
                end
                
                handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
                
            else
                
                %This is a short trial that ended after odor onset
                
                
                %                 pause(handles.dropcProg.timePerTrial)
                
                
                fprintf(1, 'Short odor period\n');
                %                         start_toc=toc;
                %                         while toc-start_toc<handles.dropcProg.timePerTrial
                %                         end
                
                
                handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                
                switch handles.acces
                    
                    case 0
                        dropcTurnValvesOffNow(handles);
                        %Turn valves and opto TTL off
                    case 1
                        
                        
                        %PA (0) is the output to INTAN (0 to 5) and laser (6)
                        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,0);
                        
                        %NC,NO (2) is relays, 255 is off
                        AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,255);
                        
                end
                
                resultOfTrial= -2;
                
            end
            
        else
            
            %This is a short trial because mouse was not poking at end of FinalValve
            %It ended before odor onset
            fprintf(1, 'Short final valve\n');
            
            switch handles.acces
                
                case 0
                    dropcTurnValvesOffNow(handles);
                    %Turn valves and opto TTL off
                case 1
                    %PA (0) is the output to INTAN (0 to 5) and laser (6)
                    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,0);
                    
                    %NC,NO (2) is relays, 255 is off
                    AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),2,255);
                    
            end
            
            start_toc=toc;
            while toc-start_toc<handles.dropcProg.shortTime+handles.dropcProg.noRAsegments*handles.dropcProg.dt_ra
            end
            
            handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
            handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
            handles.dropcData.trialScore(handles.dropcData.trialIndex)=3;
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            
            resultOfTrial= -2;
        end
    end
    
    save(handles.dropcProg.output_file,'handles');
    
end
