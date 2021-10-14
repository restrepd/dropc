function handles = dropcStageTwo_two_spout(handles)
%Begin stage 1: Give mouse water if they lick!

while handles.dropcData.trialIndex<160
    
    
    %Do one trial
    handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    handles.dropcData.ii_lick(handles.dropcData.trialIndex)=0;
    trialNo=handles.dropcData.trialIndex;
    fprintf(1, 'Trial No: %d, ', trialNo);
    %Now run the trial
    resultOfTrial=-2;
    while (resultOfTrial == -2)
        %While mouse is doing short samples
        
        %Wait till the mouse licks on either spout
        while (sum(getvalue(handles.dio.Line(27:28)))==2)
        end
        
        if (dropcFinalValveOKBegin_two_spout(handles)==1)
            %This mouse stayed on during the final valve; do the
            %single trial!
            
            
            [trialResult, left_right]=dropcDoesMouseRespondNow_two_spout(handles);
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            if (trialResult~=2)
                dropcTurnValvesOffNow(handles);
%                 handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
%                 handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                handles.dropcData.left_right(handles.dropcData.trialIndex)=left_right;
                handles.dropcData.stage(handles.dropcData.trialIndex)=2;
                
                dropcReinforceAppropriately_two_spout(handles,left_right,trialResult);
                
                if left_right==0
                    fprintf(1, 'trial time %d, spout = left, trial result = %d\n',   handles.dropcData.trialTime(handles.dropcData.trialIndex),trialResult);
                else
                    fprintf(1, 'trial time %d, spout = right, trial result = %d\n',   handles.dropcData.trialTime(handles.dropcData.trialIndex),trialResult);
                end
                
                %Mouse must leave
                while (sum(getvalue(handles.dio.Line(27:28)))~=2)
                end
                
                resultOfTrial=1;
              
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
                
                
%                 handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
%                 handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                handles.dropcData.stage(handles.dropcData.trialIndex)=2;
                
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
            
%             handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
%             handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
            handles.dropcData.trialScore(handles.dropcData.trialIndex)=3;
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            handles.dropcData.stage(handles.dropcData.trialIndex)=2;
            
            dropcTurnValvesOffNow(handles);
            resultOfTrial= -2;
        end
    end
    
    save(handles.dropcProg.output_file,'handles');
    
end
