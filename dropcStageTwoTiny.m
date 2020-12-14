function handles = dropcStageTwoTiny(handles)
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
        
        %Wait till the mouse pokes into the sampling chamber
        while (dropcNosePokeNowTiny(handles)==0)
        end
        
        if (dropcFinalValveOKBeginTiny(handles)==1)
            %This mouse stayed on during the final valve; do the
            %single trial!
            
            
            trialResult=dropcDoesMouseRespondNowTiny(handles);
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            if (trialResult~=2)
                %Turn valves off
                putvalue(handles.dio.Line(1:4),uint8(0));
                    
                handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                
                dropcReinforceAppropriatelyTiny(handles);
                
                %Mouse must leave
                while dropcNosePokeNowTiny(handles)==1
                end
                
                resultOfTrial=1;
                fprintf(1, 'trial time %d, trial result = %d\n',   handles.dropcData.trialTime(handles.dropcData.trialIndex),trialResult);
        
            else
                
                %This is a short trial that ended after odor onset
                
        
                    pause(handles.dropcProg.timePerTrial)
              
                
                fprintf(1, 'Short, ');
                %                         start_toc=toc;
                %                         while toc-start_toc<handles.dropcProg.timePerTrial
                %                         end
                
                
                handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                
                %Turn valves off
                    putvalue(handles.dio.Line(1:4),uint8(0));
                    
                resultOfTrial= -2;
                
            end
            
        else
            
            %This is a short trial because mouse was not poking at end of FinalValve
            %It ended before odor onset
            fprintf(1, 'Short, ');
            
           
            start_toc=toc;
            while toc-start_toc<handles.dropcProg.shortTime+handles.dropcProg.noRAsegments*handles.dropcProg.dt_ra
            end
            
            handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
            handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
            handles.dropcData.trialScore(handles.dropcData.trialIndex)=3;
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            %Turn valves off
            putvalue(handles.dio.Line(1:4),uint8(0));
            
            resultOfTrial= -2;
        end
    end
    
    save(handles.dropcProg.output_file,'handles');
    
end
