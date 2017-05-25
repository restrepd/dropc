function dropcTurnValvesOffNow(handles)
%Turns all valves off




%Turns off all FIRSTPORTs
putvalue(handles.dio.Line(1:8),uint8(255));
putvalue(handles.dio.Line(17:24),uint8(255));

