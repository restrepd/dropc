function handles = dropcStageTwo_hf(handles)
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
        while (dropcNosePokeNow(handles)==0)
        end
        
        dropcFinalValveOKBegin_hf
        
        
        trialResult=dropcDoesMouseRespondNow_hf(handles);
        handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
        
        
        dropcTurnValvesOffNow(handles);
        handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
        handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
        handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
        handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
        %Notify odor off
        handles.dropcData.eventIndex=handles.dropcData.eventIndex+1;
        handles.dropcData.eventTime(handles.dropcData.eventIndex)=toc;
        handles.dropcData.event(handles.dropcData.eventIndex)=6;
        
        dropcReinforceAppropriately(handles);
        
        %Notify reinforcement given
        handles.dropcData.eventIndex=handles.dropcData.eventIndex+1;
        handles.dropcData.eventTime(handles.dropcData.eventIndex)=toc;
        handles.dropcData.event(handles.dropcData.eventIndex)=7;
        
        %Mouse must leave
        while dropcNosePokeNow(handles)==1
        end
        
        resultOfTrial=1;
        fprintf(1, 'trial time %d, trial result = %d\n',   handles.dropcData.trialTime(handles.dropcData.trialIndex),trialResult);
  
    end
    
    save(handles.dropcProg.output_file,'handles');
    
end
