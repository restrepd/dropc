function didMouseRespond=dropcDoesMouseRespondNowdnms(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded
%
%     didMouseRespond=0; Mouse did not respond
%
%     didMouseRespond=2; This was a short

startOdor=toc;
while toc-startOdor<handles.dropcProg.odorDT
end

%Divert final valve towards the exhaust and the purge valve towars the port
dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
if handles.dropcProg.makeNoise==1
    dataValue = dataValue+handles.dropcDioOut.noise;
end
dataValue=bitcmp(dataValue);

putvalue(handles.dio.Line(17:24),dataValue);


%Turn on odor2 valve
dataValue=handles.dropcProg.odor2Valve;
dataValue=bitcmp(uint8(dataValue));
putvalue(handles.dio.Line(1:8),dataValue);

startDelay=toc;

while toc-startDelay<handles.dropcProg.interDT
end

%Turn FinalValve towards the odor port: turn purge to exhaust, turn on odor...)
dataValue=bitcmp(uint8(0));
putvalue(handles.dio.Line(17:24),dataValue);

%Is the mouse responding?
didMouseRespond=0;

startOdor=toc;
while toc-startOdor<handles.dropcProg.odorDT
    
    %lickStatus=dropcGetLickStatus(handles);
    if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
        %sum(handles.dropcProg.noLick))
        %Mouse licked!
        didMouseRespond=1;
    end
end









