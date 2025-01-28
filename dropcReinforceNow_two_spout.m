function dropcReinforceNow_two_spout(handles,left_right)
%Turns all valves off



%Notify INTAN
handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.reinforcement+handles.dropcDraqOut.draq_trigger;
dropcUpdateDraqPort(handles);

%Turn on water valve
if left_right==0
    %Left
    dataValue=handles.dropcDioOut.water_valve_left;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    
    %Wait for rfTime
    start_time=toc;
    while (toc-start_time<handles.dropcProg.rfTime_left)
    end
else
    %Right
    dataValue=handles.dropcDioOut.water_valve_right;
    dataValue=bitcmp(dataValue);
    putvalue(handles.dio.Line(17:24),dataValue);
    %Wait for rfTime
    start_time=toc;
    while (toc-start_time<handles.dropcProg.rfTime_right)
    end
end



handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);

%Turn off water valve
dataValue=uint8(0);
dataValue=bitcmp(dataValue);
putvalue(handles.dio.Line(17:24),dataValue);



