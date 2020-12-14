function handles = dropcStageOneTiny(handles)
%Begin stage 1: Give mouse water if they lick!


for noReinf=1:20
    %
    %     switch handles.acces
    %
    %         case 0
  
    %Wait till the mouse licks
    while getvalue(handles.dio.Line(handles.dropcProg.lick_dioin))==0
    end

    handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
    dropcReinforceNowTiny(handles);

    
    fprintf(1, '\nStage 1 Trial No: %d, time: %d', noReinf, toc);
    
    
    iti = (handles.dropcProg.timePerTrial+4)*rand(1);
    
    %if handles.dropcProg.skipIntervals==0
    startTime=toc;
    while (toc-startTime)<iti
    end
    %end
    
    save(handles.dropcProg.output_file,'handles');

end
