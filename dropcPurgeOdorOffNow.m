function dropcPurgeOdorOffNow(handles)
%Turns all valves off




%Turns off odor valve
putvalue(handles.dio.Line(1:8),uint8(255));


%Divert final valve towards the exhaust 
%Divert purge valve towards the port 
dataValue = handles.dropcDioOut.final_valve+handles.dropcDioOut.purge_valve;
dataValue=bitcmp(dataValue);
putvalue(handles.dio.Line(17:24),dataValue);

