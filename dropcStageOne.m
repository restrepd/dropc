function handles = dropcStageOne(handles)
%Begin stage 1: Give mouse water if they lick!


for noReinf=1:20
    noReinf

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




    iti = (handles.dropcProg.timePerTrial+4)*rand(1);

    %if handles.dropcProg.skipIntervals==0
        startTime=toc;
        while (toc-startTime)<iti
        end
    %end

    save(handles.dropcProg.output_file,'handles');

%     %Now plot the data
%     figure(1)
% 
%     %ITI
%     if handles.dropcData.trialIndex>2
%         ITI=handles.dropcData.trialTime(2:end)-handles.dropcData.trialTime(1:end-1);
%         trialNoITI=(1:length(ITI));
%         plot(trialNoITI,ITI,'ob')
%         xlim([0 22])
%         ylabel('ITI (sec)')
%         xlabel('Trial No')
%         title('Stage 1: Inter trial intervals')
% 
%     end

end
