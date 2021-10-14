function handles = dropcStageOne_two_spout(handles)
%Begin stage 1: Give mouse water if they lick!


for noReinf=1:20
    %
    %     switch handles.acces
    %
    %         case 0
  
    %Wait till the mouse licks on either spout
    while (sum(getvalue(handles.dio.Line(27:28)))==2)
    end

%     sumLickStatus=handles.dropcProg.sumNoLick;
    sumNoLick=1;
    sumLickStatusLeft=sumNoLick;
    sumLickStatusRight=sumNoLick;
    while (sumLickStatusLeft==sumNoLick)&(sumLickStatusRight==sumNoLick)
        %Mouse is not licking
        sumLickStatusLeft=getvalue(handles.dio.Line(28));
        sumLickStatusRight=getvalue(handles.dio.Line(27));
    end
    
    handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
    handles.dropcData.stage(handles.dropcData.trialIndex)=1;
    
    if sumLickStatusLeft~=sumNoLick
        dropcReinforceNow_two_spout(handles,0);
        fprintf(1, '\nStage 1 Trial No: %d, spout = left, time: %d', noReinf, toc);
        handles.dropcData.left_right(handles.dropcData.trialIndex)=0;
    else
        dropcReinforceNow_two_spout(handles,1);
        fprintf(1, '\nStage 1 Trial No: %d, spout = right, time: %d', noReinf, toc);
        handles.dropcData.left_right(handles.dropcData.trialIndex)=1;
    end
    
    
    
    
    iti = (handles.dropcProg.timePerTrial+4)*rand(1);
    
    %if handles.dropcProg.skipIntervals==0
    startTime=toc;
    while (toc-startTime)<iti
    end
    %end
    
    save(handles.dropcProg.output_file,'handles');

end
