function [didMouseRespond,left_right]=dropcDoesMouseRespondNow_two_spoutUNO(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded
%
%     didMouseRespond=0; Mouse did not respond
%
%     didMouseRespond=2; This was a short
%
%     left_right=0; left

%First send the two arduinos a start TTL
putvalue(handles.dio.Line(9),0);%Turns 9 on

%Wait for the arduino to be done
start_toc=toc;
while toc-start_toc<2.6
end


short_dio_left=getvalue(handles.dio.Line(29));   %From pin 8 short in the left Arduino
allRAs_dio_left=getvalue(handles.dio.Line(30));  %From pin 13 in the left Arduino all RA licks
short_dio_right=getvalue(handles.dio.Line(31));   %From pin 8 short in the right Arduino
allRAs_dio_right=getvalue(handles.dio.Line(32));  %From pin 13 in the right Arduino all RA licks

putvalue(handles.dio.Line(9),1);%Turns 9 off

if (short_dio==0)||(handles.dropcProg.enforceShorts==0)
    
    %This is not a short  
    didMouseRespond=0;
    left_right=-1;
    
    %Did the mouse respond on the left?
    if allRAs_dio_left==0
        didMouseRespond=1;
        left_right=0;
    end
    
    %Did the mouse respond on the right?
    if allRAs_dio_right==0
        didMouseRespond=1;
        left_right=1;
    end
    
    %Notify INTAN of outcome
    handles.dropcDraqOut.st2_left_spout=uint8(8);
    handles.dropcDraqOut.st2_right_spout=uint8(10);
    
    if (didMouseRespond==0)
        handles.dropcDigOut.draqPortStatus=0;
    else
        if (left_right==0)
            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.st2_left_spout;
        else
            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.st2_right_spout;
        end
    end
    dropcUpdateDraqPort(handles);
    
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



