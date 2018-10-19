function dropcTurnValvesOffNow(handles)
%Turns all valves off


%Turns off odor valves
putvalue(handles.dio.Line(1:8),uint8(255));

%Turn off the FV
putvalue(handles.dio.Line(17:24),uint8(255));

