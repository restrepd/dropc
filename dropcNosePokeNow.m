function isMouseIn = dropcNosePokeNow(handles)
%Finds out whether user pressed 'S' for stop



    
    photodiodeStatus=getvalue(handles.dio.Line(33:40));
    
    lickStatus=getvalue(handles.dio.Line(25:32));


%Note: either the mouse blocks the photodiode or it is licking
if ((sum(lickStatus)~=handles.dropcProg.sumNoLick)||(handles.dropcProg.sumPdOn~=sum(photodiodeStatus)))
    isMouseIn=1;
else
    isMouseIn=0;
end