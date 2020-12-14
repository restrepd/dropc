function finalValveOK = dropcFinalValveOK_hf_tp(handles)
%Diverts final valve towards the exhaust, turns valve odor on, finds out whther the mouse stays in the
%odor sampling area and turns the final valve back towards the port

start_toc=toc;

noSamples=0;
noSamplesMouseOn=0;



%Fvtime falls randomly between 1 and 1.5
fvtime = 0.666666*handles.dropcProg.fvtime +0.333333*handles.dropcProg.fvtime*rand(1);


%Notify draq, turn final valve and odor on, etc...


% %Turn on (or not) opto stimulus during FV
% opto_on=0;
% % handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=0;
% if (handles.dropcProg.whenOptoOn==1)
%     % if handles.dropcProg.odorValve==handles.dropcProg.splusOdorValve %for S+
%     %if handles.dropcProg.odorValve==handles.dropcProg.sminusOdorValve %for S-
%     %if you want to randomly send TTL opto uncomment this line
%     %         if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
%     dataValue=uint8(0);
%     putvalue(handles.dio.Line(9:12),dataValue);
%     opto_on=1;
% %     handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
%     %         end
%     %end
%     
% end

%Notify draq final valve on and odor or side rewarded
if (handles.dropcProg.odor_rewarded==1)
    handles.dropcDigOut.draqPortStatus=uint8(1);
else
    handles.dropcDigOut.draqPortStatus=uint8(2);
end
dropcUpdateDraqPort(handles);

%Divert final valves towards the exhaust and the purge valve towars the port
putvalue(handles.dio.Line(17:24),uint8(0));


%Turn on odor valve
if handles.dropcProg.deliver_left
    dataValue=handles.dropcProg.odorValveLeft;
else
    dataValue=handles.dropcProg.odorValveRight;
end
dataValue=bitcmp(uint8(dataValue));

putvalue(handles.dio.Line(1:8),dataValue);

%Find out whether the mouse is poking
while (toc-start_toc<fvtime)
    noSamples=noSamples+1;
    if dropcNosePokeNow(handles)==1
        noSamplesMouseOn=noSamplesMouseOn+1;
    end
end


% %Turn on (or not) opto stimulus during odor delivery
% opto_on=0;
% 
% %If this is not a short then give the light
% if (noSamplesMouseOn/noSamples) > 0.2
%     
%     if handles.dropcProg.whenOptoOn==2
%         if handles.dropcProg.odorValve==handles.dropcProg.splusOdorValve %for S+
%             %if handles.dropcProg.odorValve==handles.dropcProg.sminusOdorValve %for S-
%             %if you want to randomly send TTL opto uncomment this line
%             %         if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
%             dataValue=uint8(0);
%             putvalue(handles.dio.Line(9:12),dataValue);
%             opto_on=1;
% %             handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
%             %         end
%         end
%     end
%     
% end

%Notify draq of odor onset

%Notify draq
if handles.dropcProg.deliver_left==1
    if handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor
        handles.dropcDigOut.draqPortStatus=3;
    else
        handles.dropcDigOut.draqPortStatus=4;
    end
else
    if handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor
        handles.dropcDigOut.draqPortStatus=5;
    else
        handles.dropcDigOut.draqPortStatus=6;
    end
end
dropcUpdateDraqPort(handles);


%Turn FinalValve towards the odor port: turn purge to exhaust, turn on odor...)
dataValue=bitcmp(uint8(0));
putvalue(handles.dio.Line(17:24),dataValue);

if (fvtime<0.3)
    finalValveOK=1;
else
    
    if (noSamplesMouseOn/noSamples) > 0.2
        finalValveOK=1;
    else
        finalValveOK=0;
    end
end

end
