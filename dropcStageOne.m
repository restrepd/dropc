function handles = dropcStageOne(handles)
%Begin stage 1: Give mouse water if they lick!


for noReinf=1:20
    %
    %     switch handles.acces
    %
    %         case 0
  
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
    %         case 1
    %             %ACCES
    %             %UInt32 DIO_ReadAll(UInt32 DeviceIndex, out UInt32 pData)
    %             data = NET.createArray('System.Byte', 4);
    %
    %             lickOn=0;
    %             while lickOn==0
    %                 AIOUSBNet.AIOUSB.DIO_ReadAll(-3, data);
    %                 %         data(2)
    %                 %If you enter 3, you are reading byte 2: relays
    %                 %If you enter 1 you are reading PA
    %                 %If you enter 2 you read PB
    %
    %                 %         photodiodeBlocked=bitand(1,data(2));
    %                 lickOn=bitand(1,data(2));
    %             end
    %
    %             handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    %             handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
    %             dropcReinforceNow_ac(handles);
    %
    %     end
    
    
    
    
    fprintf(1, '\nStage 1 Trial No: %d, time: %d', noReinf, toc);
    
    
    iti = (handles.dropcProg.timePerTrial+4)*rand(1);
    
    %if handles.dropcProg.skipIntervals==0
    startTime=toc;
    while (toc-startTime)<iti
    end
    %end
    
    save(handles.dropcProg.output_file,'handles');

end
