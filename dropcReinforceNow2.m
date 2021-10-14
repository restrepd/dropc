function dropcReinforceNow2(handles)
%Turns all valves off



%Notify Data Wave
handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.reinforcement+handles.dropcDraqOut.draq_trigger;
dropcUpdateDraqPort(handles);

%Turn on water valve
dataValue=handles.dropcDioOut.water_valve;
dataValue=bitcmp(dataValue);
putvalue(handles.dio.Line(17:24),dataValue);

%Wait for rfTime
start_time=toc;
while (toc-start_time<handles.dropcProg.rfTime)
end

handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);

%Turn off water valve
dataValue=uint8(0);
dataValue=bitcmp(dataValue);
putvalue(handles.dio.Line(17:24),dataValue);



