function handles = dropcStageOne(handles)
%Begin stage 1: Give mouse water if they lick!


for noReinf=1:20

     while (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)     
     end

    sumLickStatus=handles.dropcProg.sumNoLick;
    while (sumLickStatus==handles.dropcProg.sumNoLick)
        %Mouse is not licking
        sumLickStatus=sum(getvalue(handles.dio.Line(25:32)));
    end


    handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
    dropcReinforceNow(handles);

    fprintf(1, '\nStage 1 Trial No: %d, time: ', noReinf, toc);


    iti = (handles.dropcProg.timePerTrial+4)*rand(1);

    %if handles.dropcProg.skipIntervals==0
        startTime=toc;
        while (toc-startTime)<iti
        end
    %end

    save(handles.dropcProg.output_file,'handles');

end
