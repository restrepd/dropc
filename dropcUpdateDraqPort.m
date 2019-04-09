function dropcUpdateDraqPort(handles)
%	Initialize the DIO96H/50.



dataValue=handles.dropcDigOut.draqPortStatus;
putvalue(handles.dio.Line(57:64),dataValue);

