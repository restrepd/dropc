function didMouseRespond=dropcDoesMouseRespondNowUNO(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded 
%
%     didMouseRespond=0; Mouse did not respond
%
%     didMouseRespond=2; This was a short

%First send the arduino a start TTL
putvalue(handles.dio.Line(9),0);%Turns 9 on

%Wait for the arduino to be done
start_toc=toc;
while toc-start_toc<2.6
end

short_dio=getvalue(handles.dio.Line(25));   %Short coming from pin 8 in the Arduino
allRAs_dio=getvalue(handles.dio.Line(26));  %All RAs coming from pin 13 in the Arduino

putvalue(handles.dio.Line(9),1);%Turns 9 off

if (short_dio==0)||(handles.dropcProg.enforceShorts==0)
    %This is not a short  
    if allRAs_dio==0
        didMouseRespond=1;
    else
        didMouseRespond=0;
    end
else
    %This is a short
    didMouseRespond=2;
    if handles.dropcProg.sendShorts==1
        %Send a short
        %                             handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_after+handles.dropcDraqOut.draq_trigger;
        %                             dropcUpdateDraqPort(handles);
        %
        %                             start_toc=toc;
        %                             while toc-start_toc<0.2
        %                             end
        %
        %Extremely important. If you do not do this you do not transfer all
        %trials to the draq computer
        
        
        
        handles.dropcData.shortTime(handles.dropcData.shortIndex)=toc;
        handles.dropcData.shortType(handles.dropcData.shortIndex)=2;
        handles.dropcData.shortIndex(handles.dropcData.shortIndex)=handles.dropcData.shortIndex(handles.dropcData.shortIndex)+1;
        
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_after;
        dropcUpdateDraqPort(handles);
        start_toc=toc;
        while (toc-start_toc<0.3)
        end
        
        dropcStartDraq(handles)
        
        pause(handles.dropcProg.timePerTrial)
    end
end

pffft=1;



