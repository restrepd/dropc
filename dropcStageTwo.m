function handles = dropcStageTwo(handles)
%Begin stage 1: Give mouse water if they lick!

while handles.dropcData.trialIndex<160
    
    
    %Do one trial
    handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    handles.dropcData.ii_lick(handles.dropcData.trialIndex)=0;
    trialNo=handles.dropcData.trialIndex;
    fprintf(1, '\nTrial No: %d, ', trialNo);
    %Now run the trial
    resultOfTrial=-2;
    while (resultOfTrial == -2)
        %While mouse is doing short samples
        
        %Wait till the mouse pokes into the sampling chamber
        while (dropcNosePokeNow(handles)==0)
        end
        
        if (dropcFinalValveOKBegin(handles)==1)
            %This mouse stayed on during the final valve; do the
            %single trial!
            
            
            trialResult=dropcDoesMouseRespondNow(handles);
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            if (trialResult~=2)
                dropcTurnValvesOffNow(handles);
                handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                
                dropcReinforceAppropriately(handles);
                
                %Mouse must leave
                while dropcNosePokeNow(handles)==1
                end
                
                resultOfTrial=1;
                fprintf(1, 'trial time %d, trial result = %d\n',   handles.dropcData.trialTime(handles.dropcData.trialIndex),trialResult);
        
            else
                
                %This is a short trial that ended after odor onset
                
                %Notify draq
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
                    dropcStartDraq(handles)
                else
                    pause(handles.dropcProg.timePerTrial)
                end
                
                fprintf(1, 'Short, ');
                %                         start_toc=toc;
                %                         while toc-start_toc<handles.dropcProg.timePerTrial
                %                         end
                
                
                handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                
                dropcTurnValvesOffNow(handles);
                resultOfTrial= -2;
                
            end
            
        else
            
            %This is a short trial because mouse was not poking at end of FinalValve
            %It ended before odor onset
            fprintf(1, 'Short, ');
            
            %Notify draq
            
            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_before+handles.dropcDraqOut.odor_onset;
            dropcUpdateDraqPort(handles);
            
            start_toc=toc;
            while toc-start_toc<handles.dropcProg.shortTime+handles.dropcProg.noRAsegments*handles.dropcProg.dt_ra
            end
            
            handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
            handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
            handles.dropcData.trialScore(handles.dropcData.trialIndex)=3;
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            dropcTurnValvesOffNow(handles);
            resultOfTrial= -2;
        end
    end
    
    save(handles.dropcProg.output_file,'handles');
    
end
