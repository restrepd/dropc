function [didMouseRespond,left_right]=dropcDoesMouseRespondNow_two_spout(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded
%
%     didMouseRespond=0; Mouse did not respond
%
%     didMouseRespond=2; This was a short
%
%     left_right=0; left

%First take animal through the short time
noSamples=0;
noSamplesMouseOn=0;
start_toc=toc;
didMousePoke=0;
%noSamples=noSamples+1;
sumNoLick=1;
sumLickStatusLeft=0;
sumLickStatusRight=0;
num=0;
while toc-start_toc<handles.dropcProg.shortTime
    
    %Mouse is not licking
    sumLickStatusLeft=sumLickStatusLeft+getvalue(handles.dio.Line(28));
    sumLickStatusRight=sumLickStatusRight+getvalue(handles.dio.Line(27));
    num=num+1;
end

if (sumLickStatusLeft~=num)||(sumLickStatusRight~=num)
    didMousePoke=1;
end

%Notify INTAN of odor onset
left_right=-1;
handles.dropcDraqOut.st2_left_spout=uint8(8);
handles.dropcDraqOut.st2_right_spout=uint8(10);

if (sumLickStatusLeft==num)&(sumLickStatusRight==num)
    handles.dropcDigOut.draqPortStatus=0;
else
    if (sumLickStatusLeft<sumLickStatusRight)
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.st2_left_spout;
        left_right=0;
    else
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.st2_right_spout;
        left_right=1;
    end
end

dropcUpdateDraqPort(handles);

%if (noSamplesMouseOn/noSamples) > 0.2
if didMousePoke==1
    %Now take the animal through the RA
    
    
    
    %         isLicking = 0;
    
    if handles.dropcProg.typeOfOdor==4
        %This is a begin session
        group=floor((handles.dropcData.trialIndex-1)/20)+1;
        if (group<=2)
            reqSegments=1;
        else
            if (group<=4)
                reqSegments=1+(handles.dropcProg.noRAsegments-1)/3;
            else
                if (group<=6)
                    reqSegments=1+2*(handles.dropcProg.noRAsegments-1)/3;
                else
                    reqSegments=handles.dropcProg.noRAsegments;
                end
            end
        end
        
    else
        %Otherwise the required number of segments is noRAsegments
        reqSegments=handles.dropcProg.noRAsegments;
    end
    
    didLick=zeros(1,handles.dropcProg.noRAsegments);
    
    for ii=1:handles.dropcProg.noRAsegments
        end_toc=toc+handles.dropcProg.dt_ra;
        this_toc=toc;
        while (this_toc<end_toc)
            %lickStatus=dropcGetLickStatus(handles);
            handles.dropcData.ii_lick(handles.dropcData.trialIndex)=handles.dropcData.ii_lick(handles.dropcData.trialIndex)+1;
            handles.dropcData.lick_toc(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=this_toc;
            %Mouse is not licking
            sumLickStatusLeft=getvalue(handles.dio.Line(28));
            sumLickStatusRight=getvalue(handles.dio.Line(27));
            
            if (sumLickStatusLeft~=sumNoLick)||(sumLickStatusRight~=sumNoLick)
                %sum(handles.dropcProg.noLick))
                %Mouse licked!
                didLick(ii)=1;
                handles.dropcData.lick(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=1;
            else
                handles.dropcData.lick(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=0;
            end
            this_toc=toc;
        end
        
    end
    
    
    
    
    %If mouse licked >= RA segments
    
    if sum(didLick)>=reqSegments
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
        
        
    end
    pause(handles.dropcProg.timePerTrial)
end



