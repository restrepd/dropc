function dropcReinforceNowTiny(handles)
%Turns all valves off

%Turn on water valve
putvalue(handles.dio.Line(1:4),uint8(handles.dropcProg.waterValve));

%Wait for rfTime
start_time=toc;
while (toc-start_time<handles.dropcProg.rfTime)
end

%Turn off water valve
putvalue(handles.dio.Line(1:4),uint8(0));



