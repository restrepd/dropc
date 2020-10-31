function didMouseRespond=dropcDoesMouseRespondNow_ac(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded 
%
%     didMouseRespond=0; Mouse did not respond
%
%     didMouseRespond=2; This was a short

%First take animal through the short time
noSamples=0;
noSamplesMouseOn=0;
start_toc=toc;
didMousePoke=0;
while toc-start_toc<handles.dropcProg.shortTime
    %noSamples=noSamples+1;
    if dropcNosePokeNow_ac(handles)==1
        %noSamplesMouseOn=noSamplesMouseOn+1;
        didMousePoke=1;
    end
end

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
%             handles.dropcData.ii_lick(handles.dropcData.trialIndex)=handles.dropcData.ii_lick(handles.dropcData.trialIndex)+1;
%             handles.dropcData.lick_toc(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=this_toc;
            switch handles.acces
                
                case 0
                    
                    if (sum(getvalue(handles.dio.Line(25:32)))~=handles.dropcProg.sumNoLick)
                        %sum(handles.dropcProg.noLick))
                        %Mouse licked!
                        didLick(ii)=1;
%                         handles.dropcData.lick(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=1;
                    else
%                         handles.dropcData.lick(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=0;
                    end
                case 1
                    %ACCES
                    %UInt32 DIO_ReadAll(UInt32 DeviceIndex, out UInt32 pData)
                    data = NET.createArray('System.Byte', 4);
                    AIOUSBNet.AIOUSB.DIO_ReadAll(-3, data);
                    
                    %If you enter 3, you are reading byte 2: relays
                    %If you enter 1 you are reading PA
                    %If you enter 2 you read PB

                    lickOn=bitand(1,data(2));
                    if lickOn
                        %sum(handles.dropcProg.noLick))
                        %Mouse licked!
                        didLick(ii)=1;
%                         handles.dropcData.lick(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=1;
                    else
%                         handles.dropcData.lick(handles.dropcData.trialIndex,handles.dropcData.ii_lick(handles.dropcData.trialIndex))=0;
                    end
                    
            end
            this_toc=toc;
        end
        
    end
    
    
    %         RAtime=handles.dropcProg.noRAsegments*handles.dropcProg.dt_ra;
    %         start_toc=toc;
    %
    %         while (toc-start_toc<RAtime)
    %
    %             lickStatus=dropcGetLickStatus(handles);
    %
    %             if (sum(lickStatus)~=sum(handles.dropcProg.noLick))
    %                 %Mouse licked!
    %                 didLick(1+floor((toc-start_toc)/handles.dropcProg.dt_ra))=1;
    %                 %Make sure to do autoShape if this is begin!!!
    %                 %autoShape(response, progStat, olfStat);
    %             end
    %         end
    
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
        switch handles.acces
            
            case 0
                dropcUpdateDraqPort(handles);
            case 1
                AIOUSBNet.AIOUSB.DIO_Write8(uint32(-3),0,uint8(handles.dropcDigOut.draqPortStatus));
        end
        
        start_toc=toc;
        while (toc-start_toc<0.3)
        end
        
        if handles.acces==0
            dropcStartDraq(handles)
        end
        
        
    end
%     pause(handles.dropcProg.timePerTrial)
end



