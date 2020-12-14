function isMouseIn = dropcNosePokeNowTiny(handles)
%Finds out whether user pressed 'S' for stop



 
    photodiodeStatus=getvalue(handles.dio.Line(handles.dropcProg.photodiode_dioin));
    
    lickStatus=getvalue(handles.dio.Line(handles.dropcProg.lick_dioin));


%Note: either the mouse blocks the photodiode or it is licking
if (lickStatus==1)||(photodiodeStatus==1)
    isMouseIn=1;
else
    isMouseIn=0;
end