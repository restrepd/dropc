function finalValveOK = dropcFinalValveOK_two_spout_new(handles)
%Diverts final valve towards the exhaust, turns valve odor on, finds out whther the mouse stays in the
%odor sampling area and turns the final valve back towards the port

start_toc=toc;

noSamples=0;
noSamplesMouseOn=0;



%Otherwise, fvtime falls randomly between 1 and 1.5
fvtime = 0.666666*handles.dropcProg.fvtime +0.333333*handles.dropcProg.fvtime*rand(1);


%Notify draq, turn final valve and odor on, etc...


%Turn on (or not) opto stimulus during FV
opto_on=0;
% handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=0;
% if (handles.dropcProg.whenOptoOn==1)
%     % if handles.dropcProg.odorValve==handles.dropcProg.splusOdorValve %for S+
%     %if handles.dropcProg.odorValve==handles.dropcProg.sminusOdorValve %for S-
%     %if you want to randomly send TTL opto uncomment this line
%     %         if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
%     dataValue=uint8(0);
%     putvalue(handles.dio.Line(9:12),dataValue);
%     opto_on=1;
%     handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
%     %         end
%     %end
%     
% end

%Notify INTAN
if opto_on==0
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
else
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.opto_on;
end
dropcUpdateDraqPort(handles);


%Divert final valve towards the exhaust and the purge valve towars the port
dataValue = handles.dropcDioOut.final_valveLeft+handles.dropcDioOut.final_valveRight;
if handles.dropcProg.makeNoise==1
    dataValue = dataValue+handles.dropcDioOut.noise;
end
dataValue=bitcmp(dataValue);

putvalue(handles.dio.Line(17:24),dataValue);


%Turn on odor valve
dataValue=handles.dropcProg.odorValveLeft+handles.dropcProg.odorValveRight;
dataValue=bitcmp(uint8(dataValue));

putvalue(handles.dio.Line(1:8),dataValue);


% wait for FV
while (toc-start_toc<fvtime)
%     noSamples=noSamples+1;
%     if sum(getvalue(handles.dio.Line(27:28)))~=2
%         noSamplesMouseOn=noSamplesMouseOn+1;
%     end
end


% %Turn on (or not) opto stimulus during odor delivery
% opto_on=0;
% 
% %If this is not a short then give the light
% if (noSamplesMouseOn/noSamples) > 0.2
%     
%     if handles.dropcProg.whenOptoOn==2
% %         if handles.dropcProg.odorValve==handles.dropcProg.splusOdorValve %for S+
% % %             %if handles.dropcProg.odorValve==handles.dropcProg.sminusOdorValve %for S-
% % %             %if you want to randomly send TTL opto uncomment this line
% % %             %         if handles.dropcProg.randomOpto(handles.dropcData.fellowsNo)==1
% % %             dataValue=uint8(0);
% % %             putvalue(handles.dio.Line(9:12),dataValue);
% % %             opto_on=1;
% % %             handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
% % %             %         end
% %         end
%     end
%     
% end

%Notify draq of odor onset

%Notify draq
if opto_on==0
    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset;
else
    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.odor_onset+handles.dropcDraqOut.opto_on;
end
dropcUpdateDraqPort(handles);


%Turn FinalValve towards the odor port: turn purge to exhaust, turn on odor...)
dataValue=bitcmp(uint8(0));
putvalue(handles.dio.Line(17:24),dataValue);

% %Turn opto TTL off
% if (handles.dropcProg.whenOptoOn==1)
%     dataValue=uint8(15);
%     putvalue(handles.dio.Line(9:12),dataValue);
% end


% if (fvtime<0.3)
%     finalValveOK=1;
% else
%     
%     if (noSamplesMouseOn/noSamples) > 0.2
%         finalValveOK=1;
%     else
%         finalValveOK=0;
%     end
% end
finalValveOK=1;

end
