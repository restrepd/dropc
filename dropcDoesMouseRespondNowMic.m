function didMouseRespond=dropcDoesMouseRespondNowMic(handles)
%	Does the mouse respond?


%     didMouseRespond=1; Mouse responded 
%
%     didMouseRespond=0; Mouse did not respond
%
%     didMouseRespond=2; This was a short

%Record licks using the microphone input

%Sample the licks using the microphone input

%Acquire microphone data
start(handles.ai)
data=getdata(handles.ai);



if sum(abs(data(2:handles.dropcProg.shortTime*handles.dropcProg.freq)-data(1:handles.dropcProg.shortTime*handles.dropcProg.freq-1))>handles.dropcProg.thr)>0
    didMousePoke=1;
else
    didMousePoke=0;
end

%If the mouse licked during short time go through the trial
if didMousePoke==1
    
    %Did the mouse lick in each of the RAs?
    didLick=zeros(1,handles.dropcProg.noRAsegments);
    
    for ii=1:handles.dropcProg.noRAsegments
        ii_start=handles.dropcProg.shortTime*handles.dropcProg.freq+(ii-1)*handles.dropcProg.dt_ra*handles.dropcProg.freq;
        ii_end=handles.dropcProg.shortTime*handles.dropcProg.freq+ii*handles.dropcProg.dt_ra*handles.dropcProg.freq-1;
        if sum(abs(data(ii_start+1:ii_end+1)-data(ii_start:ii_end))>handles.dropcProg.thr)>0
            didLick(ii)=1;
        end
    end
    
    if sum(didLick)>=handles.dropcProg.noRAsegments
        didMouseRespond=1;
    else
        didMouseRespond=0;
    end
else
    %This is a short
    didMouseRespond=2;
    if handles.dropcProg.sendShorts==1
        %Send a short

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



